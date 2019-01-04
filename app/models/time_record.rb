# frozen_string_literal: true

class TimeRecord < Record
  # Validations
  validates_numericality_of :initial_time, greater_than_or_equal_to: 0,
                                           only_integer: true

  validates_numericality_of :final_time, greater_than_or_equal_to: 0,
                                         only_integer: true, allow_nil: true

  validate :final_time_cannot_be_before_initial_time

  def initial_hour
    time_to_hours(initial_time)
  end

  def initial_minute
    time_to_minutes(initial_time)
  end

  def initial_hour=(value)
    self.initial_time = hours_and_minutes_to_time(value, initial_minute)
  end

  def initial_minute=(value)
    self.initial_time = hours_and_minutes_to_time(initial_hour, value)
  end

  def final_hour
    final_time.present? ? time_to_hours(final_time) : Time.current.hour
  end

  def final_minute
    final_time.present? ? time_to_minutes(final_time) : Time.current.min
  end

  def final_hour=(value)
    self.final_time =
      if value.present?
        hours_and_minutes_to_time(value, time_to_minutes(final_time))
      end
  end

  def final_minute=(value)
    self.final_time =
      if value.present?
        hours_and_minutes_to_time(time_to_hours(final_time), value)
      else
        final_time
      end
  end

  def hours
    if final_time.present?
      time_to_hours(final_time - initial_time)
    else
      current_time_hours
    end
  end

  def minutes
    if final_time.present?
      time_to_minutes(final_time - initial_time)
    else
      current_time_minutes
    end
  end

  def opened?
    final_time.blank?
  end

  def closed?
    final_time.present?
  end

  def total_time
    super
  end

  private

  def current_time
    (Time.current.hour.hour + Time.current.min.minutes).value
  end

  def current_time_hours
    return 0 unless initial_time <= current_time

    time_to_hours(current_time - initial_time)
  end

  def current_time_minutes
    return 0 unless initial_time <= current_time

    time_to_minutes(current_time - initial_time)
  end

  def final_time_cannot_be_before_initial_time
    return unless initial_time.present? && final_time.present?

    initial_time_error if final_time < initial_time
    final_hour_error if final_hour < initial_hour
    final_minute_error if final_minute_invalid?
  end

  def initial_time_error
    errors.add(:final_time, 'cannot be before initial time')
  end

  def final_hour_error
    errors.add(:final_hour, 'cannot be before initial hour')
  end

  def final_minute_invalid?
    final_hour == initial_hour && final_minute < initial_minute
  end

  def final_minute_error
    errors.add(:final_minute, 'cannot be before initial minute')
  end
end
