class Work < ApplicationRecord
  # Associations
  validates_presence_of :date, :project

  # Associations
  belongs_to :project
end
