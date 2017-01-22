require 'rails_helper'

RSpec.describe AmountWork, type: :model do
  describe 'validations' do
    it { should validate_presence_of :date }
    it { should validate_presence_of :project }

    it { should validate_numericality_of(:hours).
        is_greater_than_or_equal_to(0).
        is_less_than_or_equal_to(24).
        only_integer.
        allow_nil }

    it { should validate_numericality_of(:minutes).
        is_greater_than_or_equal_to(0).
        is_less_than_or_equal_to(60).
        only_integer.
        allow_nil }
  end

  describe 'associations' do
    it { should belong_to :project }
  end

  describe 'to_s' do
    subject { create(:amount_work, hours: 3, minutes: 30) }

    it 'must return "#description (#hours:#minutes)" if description is present' do
      expect(subject.to_s).to\
        eq("#{subject.description} (#{subject.hours}:#{subject.minutes})")
    end

    it 'must return "#hours:#minutes" if description is not present' do
      subject.description = nil
      expect(subject.to_s).to\
        eq("#{subject.hours}:#{subject.minutes}")
    end
  end
end
