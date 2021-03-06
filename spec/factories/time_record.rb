# frozen_string_literal: true

FactoryBot.define do
  factory :time_record do
    type { 'TimeRecord' }
    date { '2017-01-22' }
    description { 'My Description' }
    initial_hour { 0 }
    project
  end
end
