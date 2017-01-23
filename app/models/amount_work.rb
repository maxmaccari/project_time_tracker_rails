class AmountWork < Work
  # Validations
  validates_numericality_of :hours, only_integer: true, allow_nil: true,
    greater_than_or_equal_to: 0, less_than_or_equal_to: 24

  validates_numericality_of :minutes, only_integer: true, allow_nil: true,
    greater_than_or_equal_to: 0, less_than_or_equal_to: 60

  # Overrides
  def to_s
    return "#{description} (#{hours}:#{minutes})" if description.present?
    "#{hours}:#{minutes}"
  end
end
