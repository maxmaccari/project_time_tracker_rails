require 'rails_helper'

RSpec.describe AmountRecord, type: :model do
  describe 'validations' do
    it { should validate_numericality_of(:hours).
        is_greater_than_or_equal_to(0).
        only_integer }

    it { should validate_numericality_of(:minutes).
        is_greater_than_or_equal_to(0).
        is_less_than_or_equal_to(60).
        only_integer }
  end
end
