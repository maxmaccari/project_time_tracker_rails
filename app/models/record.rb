class Record < ApplicationRecord
  # Associations
  validates_presence_of :type, :date, :project

  # Associations
  belongs_to :project
end
