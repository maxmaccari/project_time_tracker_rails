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
    self.final_time = value.present? ? hours_and_minutes_to_time(value, time_to_minutes(final_time)) : nil
  end

  def final_minute=(value)
    self.final_time = value.present? ? hours_and_minutes_to_time(time_to_hours(final_time), value) : self.final_time
  end

  def hours
    final_time.present? ? time_to_hours(final_time - initial_time) :
      time_to_hours( initial_time <= (Time.current.hour.hour + Time.current.min.minutes).value ?
      ((Time.current.hour.hour + Time.current.min.minutes).value - initial_time) : 0  )
  end

  def minutes
    final_time.present? ? time_to_minutes(final_time - initial_time) :
      time_to_minutes( initial_time <= (Time.current.hour.hour + Time.current.min.minutes).value ?
      ((Time.current.hour.hour + Time.current.min.minutes).value - initial_time) : 0  )
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

  # Aux Methods
  private
  def final_time_cannot_be_before_initial_time
    if initial_time.present? && final_time.present?
      if final_time < initial_time
        errors.add(:final_time, "cannot be before initial time")
        if ( final_hour < initial_hour )
          errors.add(:final_hour, "cannot be before initial hour")
        end
        if (final_hour == initial_hour && final_minute < initial_minute)
          errors.add(:final_minute, "cannot be before initial minute")
        end
      end
    end
  end
end
