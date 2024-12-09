# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  # GET /api/v1/users
  def index
    render json: users, each_serializer: UserSerializer, status: :ok
  end

  private

  def users
    @users ||= User.all.page(page).per(per_page)
  end

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 10
  end
end
