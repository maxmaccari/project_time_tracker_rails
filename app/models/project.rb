class Project < ApplicationRecord
  # Validations
  validates_presence_of :title
  validates_numericality_of :estimated_hours, greater_than_or_equal_to: 0,
    only_integer: true, allow_nil: true
  validate :final_date_cannot_be_before_initial_date,
    :initial_date_cannot_be_after_final_date

  def final_date_cannot_be_before_initial_date
    if final_date.present? && initial_date.present? && final_date < initial_date
      errors.add(:final_date, "cannot be before initial date")
    end
  end

  def initial_date_cannot_be_after_final_date
    if initial_date.present? && final_date.present? &&  initial_date > final_date
      errors.add(:initial_date, "cannot be after initial date")
    end
  end

  # Associations
  belongs_to :parent, class_name: 'Project', optional: true
  has_many :projects, foreign_key: :parent_id

  # Overrides
  def to_s
    title
  end
end
