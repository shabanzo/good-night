# frozen_string_literal: true

require "rails_helper"

describe ::Api::V1::UsersController, type: :controller do
  let(:users) { create_list(:user, 5) }

  describe '#index' do
    before do
      users
      get :index, params: { page: 1, per_page: 10 }, as: :json
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns users data' do
      expect(response.parsed_body).to eq(users.as_json)
    end
  end
end
