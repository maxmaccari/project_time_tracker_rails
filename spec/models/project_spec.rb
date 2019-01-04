# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  subject(:project) { described_class.new }

  describe 'validations' do
    it { is_expected.to validate_presence_of :title }

    it {
      expect(project).to validate_numericality_of(:estimated_time)
        .is_greater_than_or_equal_to(0)
        .only_integer
        .allow_nil
    }

    describe 'final date' do
      subject { create(:project, initial_date: Date.today) }

      it { is_expected.to allow_value(Date.today).for(:final_date) }
      it { is_expected.to allow_value(Date.tomorrow).for(:final_date) }
      it { is_expected.not_to allow_value(Date.yesterday).for(:final_date) }
    end

    describe 'initial date' do
      subject { create(:project, final_date: Date.today) }

      it { is_expected.to allow_value(Date.today).for(:initial_date) }
      it { is_expected.to allow_value(Date.yesterday).for(:initial_date) }
      it { is_expected.not_to allow_value(Date.tomorrow).for(:initial_date) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to :parent }
    it { is_expected.to have_many :subprojects }
    it { is_expected.to have_many :records }
  end

  # Overrides
  describe 'to_s' do
    subject(:project) { create(:project) }

    it 'must return #title' do
      expect(project.to_s).to eq(project.title)
    end
  end

  # Methods
  describe 'hours' do
    subject(:project) { create(:project) }

    before do
      create(:amount_record, hours: 3, project: project)
      create(:amount_record, hours: 3, project: project)
    end

    it 'must return the total of hours of related amount works' do
      expect(project.hours).to eq(6)
    end

    it 'must return minutes converted in hour if the sum of minutes is equals to
    60' do
      create(:amount_record, minutes: 30, project: project)
      create(:amount_record, minutes: 30, project: project)

      expect(project.hours).to eq(7)
    end

    it 'must return minutes converted in hours if the sum of minutes is greater
    to 60' do
      create(:amount_record, minutes: 45, project: project)
      create(:amount_record, minutes: 45, project: project)
      create(:amount_record, minutes: 50, project: project)

      expect(project.hours).to eq(8)
    end

    it 'must return the total of hours of related project hours' do
      sub_project = create(:project, parent: project)

      create(:amount_record, hours: 2, minutes: 30, project: sub_project)
      create(:amount_record, minutes: 30, project: sub_project)

      expect(project.hours).to eq(9)
    end
  end

  describe 'minutes' do
    subject(:project) { create(:project) }

    before do
      create(:amount_record, minutes: 25, project: project)
      create(:amount_record, minutes: 25, project: project)
    end

    it 'must return the total of minutes of related amount works' do
      expect(project.minutes).to eq(50)
    end

    it 'must return zero if sum of minutes equals to 60' do
      create(:amount_record, minutes: 10, project: project)

      expect(project.minutes).to eq(0)
    end

    it 'must return 30 if sum of minutes equals to 90' do
      create(:amount_record, minutes: 40, project: project)

      expect(project.minutes).to eq(30)
    end

    it 'must return the total of minutes of related project minutes' do
      sub_project = create(:project, parent: project)

      create(:amount_record, minutes: 2, project: sub_project)
      create(:amount_record, minutes: 3, project: sub_project)

      expect(project.minutes).to eq(55)
    end
  end

  describe '#total_time' do
    subject(:project) { create(:project) }

    before { create(:amount_record, hours: 3, minutes: 30, project: project) }

    it 'must return "3h 30m"' do
      expect(project.total_time).to eq('3h 30m')
    end
  end

  describe '#total_value' do
    subject(:project) { create(:project) }

    it 'returns nil if nothing is defined' do
      expect(project.total_value).to be_nil
    end

    it 'returns the #total_time * #time_value if #time_value is defined' do
      create(:amount_record, hours: 2, project: project)
      create(:amount_record, hours: 3, project: project)

      project.time_value = 50

      expect(project.total_value).to(
        eq((project.hours + (project.minutes.to_f / 60.0)) * project.time_value)
      )
    end
  end

  describe '#estimated_value' do
    subject(:project) { create(:project) }

    it 'returns the #project_value if it is not nil' do
      project.project_value = 3200.0

      expect(project.estimated_value).to eq(project.project_value)
    end

    it 'returns the #estimated_time * #time_value if #project_value is nil' do
      project.estimated_time = 120
      project.time_value = 25.0

      expect(project.estimated_value).to(
        eq(project.estimated_time * project.time_value)
      )
    end

    it 'returns nil if nothing is defined' do
      expect(project.estimated_value).to be_nil
    end
  end
end
