class TimeWork < ApplicationRecord
  # Validations
  validates_presence_of :date, :project, :initial_time
  validate :final_time_cannot_be_before_initial_time

  def final_time_cannot_be_before_initial_time
    if final_time.present? && initial_time.present? && final_time <= initial_time
      errors.add(:final_time, "cannot be before initial time")
    end
  end

  # Associations
  belongs_to :project

end
