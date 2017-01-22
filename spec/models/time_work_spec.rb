require 'rails_helper'

RSpec.describe TimeWork, type: :model do
  describe 'validations' do
    it { should validate_presence_of :date }
    it { should validate_presence_of :project }
    it { should validate_presence_of :initial_hour }

    it { should validate_numericality_of(:initial_hour).
        is_greater_than_or_equal_to(0).
        is_less_than(24).
        only_integer }

    it { should validate_numericality_of(:final_hour).
        is_greater_than_or_equal_to(0).
        is_less_than(24).
        only_integer.
        allow_nil }

    it { should validate_numericality_of(:initial_minute).
        is_greater_than_or_equal_to(0).
        is_less_than(60).
        only_integer.
        allow_nil}

    it { should validate_numericality_of(:final_minute).
        is_greater_than_or_equal_to(0).
        is_less_than(60).
        only_integer.
        allow_nil }

    describe 'final hour' do
      subject { create(:time_work, initial_hour: 3 ) }

      it { should allow_value(3).for(:final_hour) }
      it { should allow_value(4).for(:final_hour) }
      it { should_not allow_value(2).for(:final_hour) }
    end
  end

  describe 'associations' do
    it { should belong_to :project }
  end

  # # Methods
  # describe 'hours' do
  #   subject { create(:time_work, initial_time: Time.current - 3.hours) }
  #
  #   it 'must return hours from now if final_time is nil' do
  #     expect(subject.hours).to eq(3)
  #   end
  #
  #   it 'must return hours from final_time if final_time is not nil' do
  #     subject.final_time = Time.current - 2.hours
  #     expect(subject.hours).to eq(1)
  #   end
  # end
  #
  # # Methods
  # describe 'minutes' do
  #   subject { create(:time_work, initial_time: Time.current - 210.minutes) }
  #
  #   it 'must return hours from now if final_time is nil' do
  #     expect(subject.hours).to eq(3)
  #     expect(subject.minutes).to eq(30)
  #   end
  #
  #   it 'must return hours from final_time if final_time is not nil' do
  #     subject.final_time = Time.current - 150.minutes
  #     expect(subject.hours).to eq(2)
  #     expect(subject.minutes).to eq(30)
  #   end
  # end
end
