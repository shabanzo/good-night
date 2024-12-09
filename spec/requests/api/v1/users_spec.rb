# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:users) { create_list(:user, 5) }

  describe '#index' do
    before do
      users
      get api_v1_users_path
    end

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns users data' do
      expect(response.parsed_body).to eq(users.as_json)
    end
  end
end
