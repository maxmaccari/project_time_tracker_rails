require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_numericality_of(:estimated_hours).
        is_greater_than_or_equal_to(0).
        only_integer.
        allow_nil }

    describe 'final date' do
      subject { create(:project, initial_date: Date.today) }

      it { should allow_value(Date.today).for(:final_date) }
      it { should allow_value(Date.tomorrow).for(:final_date) }
      it { should_not allow_value(Date.yesterday).for(:final_date) }
    end

    describe 'initial date' do
      subject { create(:project, final_date: Date.today) }

      it { should allow_value(Date.today).for(:initial_date) }
      it { should allow_value(Date.yesterday).for(:initial_date) }
      it { should_not allow_value(Date.tomorrow).for(:initial_date) }
    end
  end

  describe 'associations' do
    it { should belong_to :parent }
    it { should have_many :projects }
  end

  describe 'to_s' do
    subject { create(:project) }
    it 'must return #title' do
      expect(subject.to_s).to eq(subject.title)
    end
  end
end
