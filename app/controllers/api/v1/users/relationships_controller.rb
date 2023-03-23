# frozen_string_literal: true

module Api
  module V1
    module Users
      class RelationshipsController < ApplicationController
        def follow
          follow_klass = ::Relationship::Follow.call(
            user_id: params[:user_id], target_user_id: params[:target_user_id]
          )
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

        def unfollow
          unfollow_klass = ::Relationship::Unfollow.call(
            user_id: params[:user_id], target_user_id: params[:target_user_id]
          )
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
      end
    end
  end
end
