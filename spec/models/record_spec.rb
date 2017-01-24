require 'rails_helper'

RSpec.describe Record, type: :model do
  describe 'validations' do
    it { should validate_presence_of :type }
    it { should validate_presence_of :date }
    it { should validate_presence_of :project }

    it { should validate_numericality_of(:time).
        is_greater_than_or_equal_to(0).
        only_integer }
  end

  describe 'associations' do
    it { should belong_to :project }
  end

  describe 'to_s' do
    subject { create(:amount_record, hours: 3, minutes: 30) }

    it 'must include the localizate date' do
      expect(subject.to_s).to include(I18n.l(subject.date))
    end

    it 'must include total time' do
      expect(subject.to_s).to include(subject.total_time)
    end

    it 'must include description' do
      expect(subject.to_s).to include(subject.description)
    end
  end

  describe '#ftime' do
    subject { create(:amount_record, hours: 3, minutes: 30) }
    it 'returns the time formatted' do
      expect(subject.ftime).to eq("03:30")
    end
  end

  describe '#total_time' do
    subject { create(:amount_record, hours: 3, minutes: 30) }

    it 'must return "3h 30m"' do
      expect(subject.total_time).to eq('3h 30m')
    end
  end

  describe '#human_type_value' do
    it 'must return the localized value from TimeRecord' do
      subject = create(:time_record, initial_hour: 3, initial_minute: 30)
      expect(subject.human_type_value).to\
        eq(I18n.t('activerecord.attributes.record.type_values.TimeRecord'))
    end

    it 'must return the localized value from AmountRecord' do
      subject = create(:amount_record, hours: 3, minutes: 30)
      expect(subject.human_type_value).to\
        eq(I18n.t('activerecord.attributes.record.type_values.AmountRecord'))
    end
  end

  # Class methods
  describe 'types related methods' do
    it 'types must return the available types' do
      expect(Record.types).to eq(%w(TimeRecord AmountRecord))
    end

    it 'human_type_value returns de localized value of type' do
      expect(Record.human_type_value(TimeRecord)).to\
        eq(I18n.t('activerecord.attributes.record.type_values.TimeRecord'))
      expect(Record.human_type_value(AmountRecord)).to\
        eq(I18n.t('activerecord.attributes.record.type_values.AmountRecord'))
    end
  end
end
