# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepHistory, type: :model do
  let(:incomplete_sleep_history) { create_list(:incomplete_sleep_history, 5) }

  describe 'scopes' do
    it 'returns incomplete sleep history' do
      expect(described_class.incomplete).to eq(incomplete_sleep_history)
    end
  end
end
