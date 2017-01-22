class AmountWork < ApplicationRecord
  # Validations
  validates_presence_of :date, :project

  validates_numericality_of :hours, only_integer: true, allow_nil: true,
    greater_than_or_equal_to: 0, less_than_or_equal_to: 24

  validates_numericality_of :minutes, only_integer: true, allow_nil: true,
    greater_than_or_equal_to: 0, less_than_or_equal_to: 60

  # Associations
  belongs_to :project

  # Overrides
  def to_s
    return "#{description} (#{hours}:#{minutes})" if description.present?
    "#{hours}:#{minutes}"
  end
end
