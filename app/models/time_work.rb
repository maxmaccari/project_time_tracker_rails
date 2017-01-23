class TimeWork < ApplicationRecord
  # Validations
  validates_presence_of :date, :project, :initial_hour

  validates_numericality_of :initial_hour, greater_than_or_equal_to: 0,
    less_than: 24, only_integer: true

  validates_numericality_of :final_hour, greater_than_or_equal_to: 0,
    less_than: 24, only_integer: true, allow_nil: true

  validates_numericality_of :initial_minute, greater_than_or_equal_to: 0,
    less_than: 60, only_integer: true, allow_nil: true

  validates_numericality_of :final_minute, greater_than_or_equal_to: 0,
    less_than: 60, only_integer: true, allow_nil: true

  validate :final_time_cannot_be_before_initial_time

  # Associations
  belongs_to :project

  # Callbacks
  before_save :initial_and_final_minutes_makers

  # Methods
  def hours
    initial_and_final_minutes_makers
    hours = 0
    if final_hour.present?
      hours += final_hour - initial_hour
      if initial_minute.present? && final_minute.present?
        hours -= initial_minute > final_minute ? 1 : 0
      end
    end
    hours
  end

  def minutes
    minutes = 0
    if final_hour.present? && final_minute.present?
      if final_hour == initial_hour
        minutes += final_minute - initial_minute
      else
        minutes += final_minute - initial_minute if initial_minute < final_minute
        minutes += 60 - (initial_minute - final_minute) if initial_minute > final_minute
      end
    end
    minutes
  end

  # Aux Methods
  private
  def final_time_cannot_be_before_initial_time
    if initial_hour.present? && final_hour.present?
      if final_hour < initial_hour
        errors.add(:final_hour, "cannot be before initial hour")
      end

      if initial_minute.present? && final_minute.present? &&
        initial_hour == final_hour && final_minute < initial_minute
        errors.add(:final_minute, "cannot be before initial minute")
      end
    end
  end

  def initial_and_final_minutes_makers
    if self.final_minute.blank?
      self.final_minute = 0
    end

    if self.initial_minute.blank?
      self.initial_minute = 0
    end

    if self.final_hour.blank?
      self.final_minute = nil
    end
  end
end
