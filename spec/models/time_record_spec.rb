# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeRecord, type: :model do
  subject(:record) { described_class.new }

  describe 'validations' do
    it {
      expect(record).to validate_numericality_of(:initial_time)
        .is_greater_than_or_equal_to(0)
        .only_integer
    }

    it {
      expect(record).to validate_numericality_of(:final_time)
        .is_greater_than_or_equal_to(0)
        .only_integer
        .allow_nil
    }

    describe 'final hour' do
      subject { create(:time_record, initial_hour: 3) }

      it { is_expected.to allow_value(3).for(:final_hour) }
      it { is_expected.to allow_value(4).for(:final_hour) }
      it { is_expected.not_to allow_value(2).for(:final_hour) }
    end

    describe 'initial_minute' do
      subject(:record) { create(:time_record) }

      it 'must have to be zero by default' do
        expect(record.initial_minute).to eq(0)
      end

      it 'must have to be zero by default even it is set to nil' do
        record.initial_minute = nil
        record.save

        expect(record.initial_minute).to eq(0)
      end
    end

    describe 'final_minute' do
      subject { create(:time_record, initial_minute: 30) }

      it { is_expected.to allow_value(30).for(:final_minute) }
      it { is_expected.to allow_value(40).for(:final_minute) }
      it { is_expected.not_to allow_value(29).for(:final_minute) }
    end
  end

  describe '#final_time' do
    subject(:record) { create(:time_record) }

    it 'is nil by default' do
      expect(record.final_time).to be_nil
    end

    it 'final_hour to return de current hour if is set to nil' do
      expect(record.final_hour).to eq(Time.current.hour)
    end

    it 'set final_minute to time now if final_hour is nil' do
      expect(record.final_minute).to eq(Time.current.min)
    end
  end

  describe '#initial_time' do
    subject(:record) { create(:time_record) }

    it 'must get the current time by default' do
      expect(record.final_time).to be_nil
    end
  end

  describe '#opened?' do
    subject(:record) { create(:time_record) }

    it 'is true if final_time is nil' do
      expect(record).to be_opened
    end

    it 'is false if final_time is not nil' do
      record.final_hour = 5
      expect(record).not_to be_opened
    end
  end

  describe '#closed?' do
    subject(:record) { create(:time_record) }

    it 'is true if final_time is nil' do
      expect(record).not_to be_closed
    end

    it 'is false if final_time is not nil' do
      record.final_hour = 5
      expect(record).to be_closed
    end
  end

  # Methods
  describe 'hours' do
    subject(:record) { create(:time_record, initial_hour: 5) }

    it 'must return hours from final_hour' do
      record.final_hour = 10
      expect(record.hours).to eq(5)
    end

    it 'must return 0 if minutes count only minutes' do
      record.final_hour = 6
      record.initial_minute = 30

      expect(record.hours).to eq(0)
    end

    it 'must return 1 if minutes are equals' do
      record.final_hour = 6
      record.initial_minute = 30
      record.final_minute = 30

      expect(record.hours).to eq(1)
    end
  end

  # Methods
  describe 'minutes' do
    context 'with same hours' do
      subject(:record) { create(:time_record, initial_hour: 5, final_hour: 5) }

      it 'must return minutes from initial_minutes' do
        record.final_minute = 45

        expect(record.hours).to eq(0)
        expect(record.minutes).to eq(45)
      end
    end

    context 'with different hours' do
      subject(:record) { create(:time_record, initial_hour: 5, final_hour: 6) }

      it 'initial_minute less than final_minute' do
        record.initial_minute = 15
        record.final_minute = 20

        expect(record.hours).to eq(1)
        expect(record.minutes).to eq(5)
      end

      it 'minutes equals must return 0' do
        record.initial_minute = 15
        record.final_minute = 15

        expect(record.hours).to eq(1)
        expect(record.minutes).to eq(0)
      end

      it 'initial_minute more than final_minute' do
        record.initial_minute = 15
        record.final_minute = 10

        expect(record.hours).to eq(0)
        expect(record.minutes).to eq(55)
      end
    end
  end
end
