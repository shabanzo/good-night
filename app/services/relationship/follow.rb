# frozen_string_literal: true

class Relationship
  class Follow
    include ResultHandler
    include CommonMethod

    attr_reader :user_id, :target_user_id

    def initialize(user_id:, target_user_id:)
      @user_id = user_id
      @target_user_id = target_user_id
    end

    class << self
      def call(user_id:, target_user_id:)
        new(user_id: user_id, target_user_id: target_user_id).call
      end
    end

    def call
      # Find user and target_user, return failure status if they're not existed
      return handle_failure(code: 404, error: em_user_not_found) if user.blank?
      return handle_failure(code: 404, error: em_target_user_not_found) if target_user.blank?

      # Prevent the users follow themself
      return handle_failure(code: 400, error: em_follow_self) if user == target_user

      # Prevent duplicate records
      # I put it here instead of a validation in model to put handle all error handler in one place: 'service'
      # If we put it also in model too, and the model is getting bigger and there's an issue so we have to check multiple files
      return handle_failure(code: 400, error: em_already_following) if user.following?(target_user)

      user.follow(target_user)

      handle_success(
        message: sm_follow
      )
    end
  end
end
