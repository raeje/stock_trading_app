# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'models/stock', type: :model do
  describe 'find_id_by_ticker' do
    it 'non-existing stock should return nil' do
      expect(Stock.find_id_by_ticker('ABCD')).to be_nil
    end
  end
end
