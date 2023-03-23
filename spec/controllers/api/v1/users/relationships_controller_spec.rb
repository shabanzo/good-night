# frozen_string_literal: true

require "rails_helper"

describe ::Api::V1::Users::RelationshipsController, type: :controller do
  include ResultHandler

  let(:user) { create(:user) }
  let(:target_user) { create(:user) }

  describe '#follow' do
    context 'when the klass returns success result' do
      let(:success_result) do
        OpenStruct.new(
          success?: true,
          success:  {
            message: sm_follow
          }
        )
      end

      before do
        # Mock follow service to return success request since the actual scenarios already handled here:
        # spec/services/relationship/follow.rb
        # So we only need to ensure the controller returns correct response for success one
        allow(::Relationship::Follow).to receive(:call).
          with(user_id: user.id.to_s, target_user_id: target_user.id).and_return(success_result)

        post :follow, params: { user_id: user.id, target_user_id: target_user.id }, as: :json
      end

      it 'returns 201' do
        expect(response.status).to eq(201)
      end

      it 'returns correct message' do
        expect(response.parsed_body['message']).to eq(sm_follow)
      end
    end

    context 'when the klass returns failed result' do
      let(:failed_result) do
        OpenStruct.new(
          failure?: true,
          failure:  {
            code:  400,
            error: em_user_not_found
          }
        )
      end

      let(:failed_json_response) do
        { message: failed_result.failure[:error] }.to_json
      end

      before do
        # Mock follow service to return failed result since the actual scenarios already handled here:
        # spec/services/relationship/follow.rb
        # So we only need to ensure the controller returns correct response for failed one
        allow(::Relationship::Follow).to receive(:call).
          with(user_id: user.id.to_s, target_user_id: target_user.id).and_return(failed_result)

        post :follow, params: { user_id: user.id, target_user_id: target_user.id }, as: :json
      end

      it 'returns correct error code' do
        expect(response.status).to eq(failed_result.failure[:code])
      end

      it 'returns correct error message' do
        expect(response.body).to eq(failed_json_response)
      end
    end
  end

  describe '#unfollow' do
    context 'when the klass returns success result' do
      let(:success_result) do
        OpenStruct.new(
          success?: true,
          success:  {
            message: sm_unfollow
          }
        )
      end

      before do
        # Mock unfollow service to return success request since the actual scenarios already handled here:
        # spec/services/relationship/unfollow.rb
        # So we only need to ensure the controller returns correct response for success one
        allow(::Relationship::Unfollow).to receive(:call).
          with(user_id: user.id.to_s, target_user_id: target_user.id).and_return(success_result)

        delete :unfollow, params: { user_id: user.id, target_user_id: target_user.id }, as: :json
      end

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'returns correct message' do
        expect(response.parsed_body['message']).to eq(sm_unfollow)
      end
    end

    context 'when the klass returns failed result' do
      let(:failed_result) do
        OpenStruct.new(
          failure?: true,
          failure:  {
            code:  400,
            error: em_user_not_found
          }
        )
      end

      let(:failed_json_response) do
        { message: failed_result.failure[:error] }.to_json
      end

      before do
        # Mock unfollow service to return failed result since the actual scenarios already handled here:
        # spec/services/relationship/unfollow.rb
        # So we only need to ensure the controller returns correct response for failed one
        allow(::Relationship::Unfollow).to receive(:call).
          with(user_id: user.id.to_s, target_user_id: target_user.id).and_return(failed_result)

        delete :unfollow, params: { user_id: user.id, target_user_id: target_user.id }, as: :json
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
