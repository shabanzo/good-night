# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController

      # GET /api/v1/users
      def index
        render json: users, each_serializer: UserSerializer, status: :ok
      end

      private def users
        @users ||= User.all.page(page).per(per_page)
      end
    end
  end
end
