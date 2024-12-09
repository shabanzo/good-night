# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepHistory, type: :model do
  let(:incomplete_sleep_histories) { create_list(:incomplete_sleep_history, 5) }
  let(:sleep_histories) { create_list(:sleep_history, 5) }

  describe 'scopes' do
    describe '#incomplete' do
      it 'returns incomplete sleep history' do
        incomplete_sleep_histories
        expect(described_class.incomplete).to eq(incomplete_sleep_histories)
      end
    end

    describe '#completed' do
      it 'returns completed sleep history' do
        sleep_histories
        expect(described_class.completed).to eq(sleep_histories)
      end
    end
  end
end
