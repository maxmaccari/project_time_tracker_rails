require 'rails_helper'

RSpec.describe TimeRecord, type: :model do
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
      subject { create(:time_record, initial_hour: 3 ) }

      it { should allow_value(3).for(:final_hour) }
      it { should allow_value(4).for(:final_hour) }
      it { should_not allow_value(2).for(:final_hour) }

      it 'set final_minute to nil if final_hour is nil' do
        subject.final_minute = 10
        subject.save

        expect(subject.final_minute).to be_nil
      end

      it 'set final_minute to 0 if final_hour is not nil' do
        subject.final_hour = 10
        subject.save

        expect(subject.final_minute).to eq(0)
      end
    end

    describe 'initial_minute' do
      subject { create(:time_record) }

      it 'must have to be zero by default' do
        expect(subject.initial_minute).to eq(0)
      end

      it 'must have to be zero by default even it is set to nil' do
        subject.initial_minute = nil
        subject.save

        expect(subject.initial_minute).to eq(0)
      end
    end

    describe 'final_minute' do
      subject { create(:time_record, initial_minute: 30, final_hour: 0) }

      it { should allow_value(30).for(:final_minute) }
      it { should allow_value(40).for(:final_minute) }
      it { should_not allow_value(29).for(:final_minute) }
    end
  end

  describe 'associations' do
    it { should belong_to :project }
  end

  # Methods
  describe 'hours' do
    subject { create(:time_record, initial_hour: 5) }

    it 'must return hours from final_hour' do
      subject.final_hour = 10
      expect(subject.hours).to eq(5)
    end

    it 'must return 0 if minutes count only minutes' do
      subject.final_hour = 6
      subject.initial_minute = 30

      expect(subject.hours).to eq(0)
    end

    it 'must return 1 if minutes are equals' do
      subject.final_hour = 6
      subject.initial_minute = 30
      subject.final_minute = 30

      expect(subject.hours).to eq(1)
    end
  end

  # Methods
  describe 'minutes' do
    context 'same hours' do
      subject { create(:time_record, initial_hour: 5, final_hour: 5) }

      it 'must return minutes from initial_minutes' do
        subject.final_minute = 45

        expect(subject.hours).to eq(0)
        expect(subject.minutes).to eq(45)
      end
    end

    context 'different hours' do
      subject { create(:time_record, initial_hour: 5, final_hour: 6) }

      it 'initial_minute less than final_minute' do
        subject.initial_minute = 15
        subject.final_minute = 20

        expect(subject.hours).to eq(1)
        expect(subject.minutes).to eq(5)
      end

      it 'minutes equals must return 0' do
        subject.initial_minute = 15
        subject.final_minute = 15

        expect(subject.hours).to eq(1)
        expect(subject.minutes).to eq(0)
      end

      it 'initial_minute more than final_minute' do
        subject.initial_minute = 15
        subject.final_minute = 10

        expect(subject.hours).to eq(0)
        expect(subject.minutes).to eq(55)
      end
    end
  end
end
