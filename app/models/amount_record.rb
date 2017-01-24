class AmountRecord < Record
  # Validations
  validates_numericality_of :hours, only_integer: true,
    greater_than_or_equal_to: 0

  validates_numericality_of :minutes, only_integer: true,
    greater_than_or_equal_to: 0, less_than_or_equal_to: 60
end
