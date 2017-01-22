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
    it { should have_many :amount_works }
  end

  # Overrides
  describe 'to_s' do
    subject { create(:project) }
    it 'must return #title' do
      expect(subject.to_s).to eq(subject.title)
    end
  end

  # Methods
  describe 'hours' do
    subject { create(:project) }
    before(:each) do
      create(:amount_work, hours: 3, project: subject)
      create(:amount_work, hours: 3, project: subject)
    end

    it 'must return the total of hours of related amount works' do
      expect(subject.hours).to eq(6)
    end

    it 'must return minutes converted in hour if the sum of minutes is equals to 60' do
      create(:amount_work, minutes: 30, project: subject)
      create(:amount_work, minutes: 30, project: subject)

      expect(subject.hours).to eq(7)
    end

    it 'must return minutes converted in hours if the sum of minutes is greater to 60' do
      create(:amount_work, minutes: 45, project: subject)
      create(:amount_work, minutes: 45, project: subject)
      create(:amount_work, minutes: 50, project: subject)

      expect(subject.hours).to eq(8)
    end

    it 'must return the total of hours of related project hours' do
      project = create(:project, parent: subject)
      create(:amount_work, hours: 2, minutes: 30, project: project)
      create(:amount_work, minutes: 30, project: project)

      expect(subject.hours).to eq(9)
    end
  end

  describe 'minutes' do
    subject { create(:project) }
    before(:each) do
      create(:amount_work, minutes: 25, project: subject)
      create(:amount_work, minutes: 25, project: subject)
    end

    it 'must return the total of minutes of related amount works' do
      expect(subject.minutes).to eq(50)
    end

    it 'must return zero if sum of minutes equals to 60' do
      create(:amount_work, minutes: 10, project: subject)

      expect(subject.minutes).to eq(0)
    end

    it 'must return 30 if sum of minutes equals to 90' do
      create(:amount_work, minutes: 40, project: subject)

      expect(subject.minutes).to eq(30)
    end

    it 'must return the total of minutes of related project minutes' do
      project = create(:project, parent: subject)
      create(:amount_work, minutes: 2, project: project)
      create(:amount_work, minutes: 3, project: project)

      expect(subject.minutes).to eq(55)
    end
  end
end
