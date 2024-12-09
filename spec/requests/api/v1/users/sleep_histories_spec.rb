# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::SleepHistoriesController, type: :controller do
  include ResultHandler

  let(:user) { create(:user) }
  let(:incomplete_sleep_history) { create(:incomplete_sleep_history, user: user) }

  describe '#clock_in' do
    context 'when the klass returns success result' do
      let(:sleep_histories) { create_list(:sleep_history, 15, user: user) }

      let(:clocked_in_times) do
        user.sleep_histories.order(created_at: :desc).limit(10).pluck(:clock_in_time)
      end

      let(:success_result) do
        Struct.new(:success?, :failure?, :success).new(
          true,
          false,
          {
            message: sm_clock_in,
            data:    clocked_in_times
          }
        )
      end

      before do
        # Mock clock in service to return success request since the actual scenarios already handled here:
        # spec/services/sleep_history/clock_in_spec.rb
        # So we only need to ensure the controller returns correct response for success one
        allow(SleepHistory::ClockIn).to receive(:call).with(user_id: user.id.to_s).and_return(success_result)

        post :clock_in, params: { user_id: user.id }, as: :json
      end

      it 'returns 201' do
        expect(response).to have_http_status(:created)
      end

      it 'returns clocked in times' do
        parsed_response = response.parsed_body
        expect(parsed_response['data']).to eq(clocked_in_times)
      end

      it 'returns correct message' do
        parsed_response = response.parsed_body
        expect(parsed_response['message']).to eq(sm_clock_in)
      end
    end

    context 'when the klass returns failed result' do
      let(:failed_result) do
        Struct.new(:success?, :failure?, :failure).new(
          false,
          true,
          {
            code:  400,
            error: em_user_not_found
          }
        )
      end

      let(:failed_json_response) do
        { message: failed_result.failure[:error] }.to_json
      end

      before do
        # Mock clock in service to return failed result since the actual scenarios already handled here:
        # spec/services/sleep_history/clock_in_spec.rb
        # So we only need to ensure the controller returns correct response for failed one
        allow(SleepHistory::ClockIn).to receive(:call).with(user_id: user.id.to_s).and_return(failed_result)

        post :clock_in, params: { user_id: user.id }, as: :json
      end

      it 'returns correct error code' do
        expect(response.status).to eq(failed_result.failure[:code])
      end

      it 'returns correct error message' do
        expect(response.body).to eq(failed_json_response)
      end
    end
  end
end
