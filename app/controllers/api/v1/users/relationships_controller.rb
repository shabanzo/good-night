# frozen_string_literal: true

class Api::V1::Users::RelationshipsController < ApplicationController
  # POST /api/v1/users/:user_id/relationships/follow
  def follow
    if follow_klass.success?
      render json: {
        message: follow_klass.success[:message]
      }, status: :created
    else
      render json: {
        message: follow_klass.failure[:error]
      }, status: follow_klass.failure[:code]
    end
  end

  # DELETE /api/v1/users/:user_id/relationships/unfollow
  def unfollow
    if unfollow_klass.success?
      render json: {
        message: unfollow_klass.success[:message]
      }, status: :ok
    else
      render json: {
        message: unfollow_klass.failure[:error]
      }, status: unfollow_klass.failure[:code]
    end
  end

  private

  def unfollow_klass
    @unfollow_klass ||= ::Relationship::Unfollow.call(
      user_id: params[:user_id], target_user_id: params[:target_user_id]
    )
  end

  def follow_klass
    @follow_klass ||= ::Relationship::Follow.call(
      user_id: params[:user_id], target_user_id: params[:target_user_id]
    )
  end
end
