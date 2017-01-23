class Record < ApplicationRecord
  # Associations
  validates_presence_of :type, :date, :project

  # Associations
  belongs_to :project

  # Overrides
  def to_s
    "#{I18n.l(date)} - #{total_time} (#{human_type_value})" +
    (description.present? ? ": #{description}" : '')
  end

  # Methods
  def self.types
    %w(TimeRecord AmountRecord)
  end

  def self.human_type_value(type)
    I18n.t("activerecord.attributes.record.type_values.#{type}")
  end

  def human_type_value
    Record.human_type_value(type)
  end

  def total_time
    "#{hours}h #{minutes}m"
  end
end
