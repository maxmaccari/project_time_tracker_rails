# frozen_string_literal: true

class Project < ApplicationRecord
  # Validations
  validates_presence_of :title
  validate :final_date_cannot_be_before_initial_date,
           :initial_date_cannot_be_after_final_date

  validates_numericality_of :estimated_time, greater_than_or_equal_to: 0,
                                             only_integer: true, allow_nil: true

  def final_date_cannot_be_before_initial_date
    return unless final_date.present? &&
                  initial_date.present? &&
                  final_date < initial_date

    errors.add(:final_date, 'cannot be before initial date')
  end

  def initial_date_cannot_be_after_final_date
    return unless initial_date.present? &&
                  final_date.present? &&
                  initial_date > final_date

    errors.add(:initial_date, 'cannot be after initial date')
  end

  # Associations
  belongs_to :parent, class_name: 'Project', optional: true
  has_many :subprojects, class_name: 'Project', foreign_key: :parent_id
  has_many :records, dependent: :destroy

  # Scopes
  scope :root, -> { where(parent: nil) }
  scope :active, -> { where(active: true) }

  # Friendly
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Overrides
  def to_s
    title
  end

  # Methods
  def opened_records
    records.opened.order(date: :desc)
  end

  def opened_records?
    opened_records.any?
  end

  def hours
    records.inject(0) { |sum, aw| sum + aw.hours } + (total_minutes / 60) +
      subprojects.inject(0) { |sum, proj| sum + proj.hours }
  end

  def minutes
    total_minutes % 60
  end

  def total_time
    "#{hours}h #{minutes}m"
  end

  # Tracking Methods
  def total_value
    (hours + (minutes.to_f / 60.0)) * time_value if time_value.present?
  end

  def estimated_value
    return project_value if project_value.present?

    estimated_time * time_value if estimated_time.present? &&
                                   time_value.present?
  end

  private

  def total_minutes
    records.inject(0) { |sum, aw| sum + aw.minutes } +
      subprojects.inject(0) { |sum, proj| sum + proj.minutes }
  end
end
