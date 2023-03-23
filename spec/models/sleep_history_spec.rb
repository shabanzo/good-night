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

    describe '#calculate_duration' do
      let(:duration) { 50 }
      let(:incomplete_sleep_history) do
        create(
          :sleep_history,
          clock_in_time:    Time.zone.now - duration.minutes,
          clock_out_time:   nil,
          duration_minutes: nil
        )
      end

      around { |e| Timecop.freeze(Time.zone.now) { e.run } }

      before do
        incomplete_sleep_history
      end

      it 'calculates the duration_minutes before save' do
        incomplete_sleep_history.update clock_out_time: DateTime.current
        expect(incomplete_sleep_history.duration_minutes).to eq(duration)
      end
    end
  end
end
