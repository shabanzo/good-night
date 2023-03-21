# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::SleepHistory::ClockIn do
  include CommonMethod
  let(:user) { create(:user) }
  let(:incomplete_sleep_history) { create(:incomplete_sleep_history, user: user) }

  context 'when the user not found' do
    it 'returns failure = true' do
      clock_in_klass = described_class.call(user_id: 1)
      expect(clock_in_klass).to be_failure
    end

    it 'returns code = 404' do
      clock_in_klass = described_class.call(user_id: 1)
      expect(clock_in_klass.failure[:code]).to eq(404)
    end

    it 'returns proper message' do
      clock_in_klass = described_class.call(user_id: 1)
      expect(clock_in_klass.failure[:error]).to eq(em_user_not_found)
    end
  end

  context 'when the user exists and incomplete history also exists' do
    before do
      user
      incomplete_sleep_history
    end

    it 'returns failure = true' do
      clock_in_klass = described_class.call(user_id: user.id)
      expect(clock_in_klass).to be_failure
    end

    it 'returns code = 400' do
      clock_in_klass = described_class.call(user_id: user.id)
      expect(clock_in_klass.failure[:code]).to eq(400)
    end

    it 'returns proper message' do
      clock_in_klass = described_class.call(user_id: user.id)
      expect(clock_in_klass.failure[:error]).to eq(em_incomplete_history)
    end
  end

  context 'when the user exists and there is no incomplete history' do
    let(:sleep_histories) { create_list(:sleep_history, 15, user: user) }

    before do
      user
      sleep_histories
    end

    it 'returns success = true' do
      clock_in_klass = described_class.call(user_id: user.id)
      expect(clock_in_klass).to be_success
    end

    it 'returns max 10 rows only' do
      clock_in_klass = described_class.call(user_id: user.id)
      expect(clock_in_klass.success.size).to eq(10)
    end
  end
end
