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

  validate :final_hour_cannot_be_before_initial_hour

  def final_hour_cannot_be_before_initial_hour
    if initial_hour.present? && final_hour.present? && final_hour < initial_hour
      errors.add(:final_hour, "cannot be before initial hour")
    end
  end

  # Associations
  belongs_to :project

  # Methods
  def hours
    return (final_time.hour - initial_time.hour) if final_time.present?
    (Time.current.hour - initial_time.hour)
  end
end
