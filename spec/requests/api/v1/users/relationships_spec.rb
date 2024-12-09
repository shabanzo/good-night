# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users::Relationships', type: :request do
  include ResultHandler

  let(:user) { create(:user) }
  let(:target_user) { create(:user) }

  describe '#follow' do
    context 'when the klass returns success result' do
      let(:success_result) do
        Struct.new(:success?, :failure?, :success).new(
          true,
          false,
          { message: sm_follow }
        )
      end

      before do
        allow(Relationship::Follow).to receive(:call)
          .with(user_id: user.id.to_s, target_user_id: target_user.id).and_return(success_result)

        post "/api/v1/users/#{user.id}/relationships/follow", params: { target_user_id: target_user.id }, as: :json
      end

      it 'returns 201' do
        expect(response).to have_http_status(:created)
      end

      it 'returns correct message' do
        expect(response.parsed_body['message']).to eq(sm_follow)
      end
    end

    context 'when the klass returns failed result' do
      let(:failed_result) do
        Struct.new(:success?, :failure?, :failure).new(
          false,
          true,
          { code: 400, error: em_user_not_found }
        )
      end

      before do
        allow(Relationship::Follow).to receive(:call)
          .with(user_id: user.id.to_s, target_user_id: target_user.id).and_return(failed_result)

        post "/api/v1/users/#{user.id}/relationships/follow", params: { target_user_id: target_user.id }, as: :json
      end

      it 'returns correct error code' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns correct error message' do
        expect(response.parsed_body['message']).to eq(em_user_not_found)
      end
    end
  end

  describe '#unfollow' do
    context 'when the klass returns success result' do
      let(:success_result) do
        Struct.new(:success?, :failure?, :success).new(
          true,
          false,
          { message: sm_unfollow }
        )
      end

      before do
        allow(Relationship::Unfollow).to receive(:call)
          .with(user_id: user.id.to_s, target_user_id: target_user.id).and_return(success_result)

        delete "/api/v1/users/#{user.id}/relationships/unfollow", params: { target_user_id: target_user.id }, as: :json
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct message' do
        expect(response.parsed_body['message']).to eq(sm_unfollow)
      end
    end

    context 'when the klass returns failed result' do
      let(:failed_result) do
        Struct.new(:success?, :failure?, :failure).new(
          false,
          true,
          { code: 400, error: em_user_not_found }
        )
      end

      before do
        allow(Relationship::Unfollow).to receive(:call)
          .with(user_id: user.id.to_s, target_user_id: target_user.id).and_return(failed_result)

        delete "/api/v1/users/#{user.id}/relationships/unfollow", params: { target_user_id: target_user.id }, as: :json
      end

      it 'returns correct error code' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns correct error message' do
        expect(response.parsed_body['message']).to eq(em_user_not_found)
      end
    end
  end
end
