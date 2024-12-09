# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepHistory::ClockIn do
  include ResultHandler
  let(:user) { create(:user) }
  let(:incomplete_sleep_history) { create(:incomplete_sleep_history, user: user) }

  context 'when the user not found' do
    let(:clock_in_klass) { described_class.call(user_id: 1) }

    it 'returns failure = true' do
      expect(clock_in_klass).to be_failure
    end

    it 'returns code = 404' do
      expect(clock_in_klass.failure[:code]).to eq(404)
    end

    it 'returns proper message' do
      expect(clock_in_klass.failure[:error]).to eq(em_user_not_found)
    end
  end

  context 'when the user exists and incomplete history also exists' do
    let(:clock_in_klass) { described_class.call(user_id: user.id) }

    before do
      user
      incomplete_sleep_history
    end

    it 'returns failure = true' do
      expect(clock_in_klass).to be_failure
    end

    it 'returns code = 400' do
      expect(clock_in_klass.failure[:code]).to eq(400)
    end

    it 'returns proper message' do
      expect(clock_in_klass.failure[:error]).to eq(em_incomplete_history_exists)
    end
  end

  context 'when the user exists and there is no incomplete history' do
    let(:clock_in_klass) { described_class.call(user_id: user.id) }
    let(:sleep_histories) { create_list(:sleep_history, 15, user: user) }

    before do
      user
      sleep_histories
    end

    it 'returns success = true' do
      expect(clock_in_klass).to be_success
    end

    it 'returns proper message' do
      expect(clock_in_klass.success[:message]).to eq(sm_clock_in)
    end

    it 'returns max 5 rows only' do
      expect(clock_in_klass.success[:data].size).to eq(5)
    end
  end
end
