class Record < ApplicationRecord
  # Associations
  validates_presence_of :type, :date, :project

  # Associations
  belongs_to :project

  def self.types
    %w(TimeRecord AmountRecord)
  end

  def self.human_type_value(type)
    I18n.t("activerecord.attributes.record.type_values.#{type}")
  end

  def human_type_value
    Record.human_type_value(type)
  end
end
