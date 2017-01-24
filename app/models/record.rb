class Record < ApplicationRecord
  # Associations
  validates_presence_of :type, :date, :project

  # Validations
  validates_numericality_of :time, only_integer: true,
    greater_than_or_equal_to: 0

  # Associations
  belongs_to :project

  attr_accessor :hours, :minutes, :initial_hour, :initial_minute, :final_hour, :final_minute

  def hours
    time_to_hours(time)
  end

  def minutes
    time_to_minutes(time)
  end

  def hours=(value)
    self.time = hours_and_minutes_to_time(value, minutes)
  end

  def minutes=(value)
    self.time = hours_and_minutes_to_time(hours, value)
  end

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

  def ftime
    "%02d:%02d" % [hours, minutes]
  end

  protected
  # Converter
  def time_to_hours(time)
    time.to_i / 3600
  end

  def time_to_minutes(time)
    (time.to_i - time_to_hours(time).hours.value) / 60
  end

  def hours_and_minutes_to_time(hours, minutes)
    hours.to_i.hours.value + minutes.to_i.minutes.value
  end
end
