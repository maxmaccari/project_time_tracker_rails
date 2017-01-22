require 'rails_helper'

RSpec.describe TimeWork, type: :model do
  describe 'validations' do
    it { should validate_presence_of :date }
    it { should validate_presence_of :project }
    it { should validate_presence_of :initial_time }

    describe 'final time' do
      subject { create(:time_work, initial_time: Time.now - 1.hour ) }

      it { should allow_value(Time.now - 30.minutes).for(:final_time) }
      it { should allow_value(Time.now + 1.hour).for(:final_time) }
      it { should_not allow_value(Time.now - 2.hour).for(:final_time) }
    end
  end

  describe 'associations' do
    it { should belong_to :project }
  end
end
