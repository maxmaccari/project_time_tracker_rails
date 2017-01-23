class Record < ApplicationRecord
  # Associations
  validates_presence_of :date, :project

  # Associations
  belongs_to :project
end
