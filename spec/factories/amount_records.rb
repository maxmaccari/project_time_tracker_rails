# frozen_string_literal: true

FactoryBot.define do
  factory :amount_record do
    type { 'AmountRecord' }
    description { 'My Description' }
    date { '2017-01-22' }
    project
  end
end
