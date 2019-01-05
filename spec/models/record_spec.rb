# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Record, type: :model do
  subject(:record) { described_class.new }

  describe 'validations' do
    it { is_expected.to validate_presence_of :type }
    it { is_expected.to validate_presence_of :date }
    it { is_expected.to validate_presence_of :project }

    it {
      expect(record).to validate_numericality_of(:time)
        .is_greater_than_or_equal_to(0)
        .only_integer
    }
  end

  describe 'associations' do
    it { is_expected.to belong_to :project }
  end

  describe 'to_s' do
    subject(:record) { create(:amount_record, hours: 3, minutes: 30) }

    it 'must include the localizate date' do
      expect(record.to_s).to include(I18n.l(record.date))
    end

    it 'must include total time' do
      expect(record.to_s).to include(record.total_time)
    end

    it 'must include description' do
      expect(record.to_s).to include(record.description)
    end
  end

  describe '#ftime' do
    subject(:record) { create(:amount_record, hours: 3, minutes: 30) }

    it 'returns the time formatted' do
      expect(record.ftime).to eq('03:30')
    end
  end

  describe '#total_time' do
    subject(:record) { create(:amount_record, hours: 3, minutes: 30) }

    it 'must return "3h 30m"' do
      expect(record.total_time).to eq('3h 30m')
    end
  end

  describe '#human_type_value' do
    it 'must return the localized value from TimeRecord' do
      record = create(:time_record, initial_hour: 3, initial_minute: 30)
      expect(record.human_type_value).to\
        eq(I18n.t('activerecord.attributes.record.type_values.TimeRecord'))
    end

    it 'must return the localized value from AmountRecord' do
      record = create(:amount_record, hours: 3, minutes: 30)
      expect(record.human_type_value).to\
        eq(I18n.t('activerecord.attributes.record.type_values.AmountRecord'))
    end
  end

  describe '#opened?' do
    it 'is false by default' do
      expect(record).not_to be_opened
    end
  end

  describe '#closed?' do
    it 'is true by default' do
      expect(record).to be_closed
    end
  end

  # Class methods
  describe 'types related methods' do
    it 'types must return the available types' do
      expect(Record.types).to eq(%w[TimeRecord AmountRecord])
    end

    it 'human_type_value returns de localized value of type' do
      expect(Record.human_type_value(TimeRecord)).to\
        eq(I18n.t('activerecord.attributes.record.type_values.TimeRecord'))
      expect(Record.human_type_value(AmountRecord)).to\
        eq(I18n.t('activerecord.attributes.record.type_values.AmountRecord'))
    end
  end
end
