# frozen_string_literal: true

class Relationship
  class Unfollow
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

      # Check whether the user already unfollowed the target user or not
      return handle_failure(code: 400, error: em_already_unfollowed) unless user.following?(target_user)

      user.unfollow(target_user)

      handle_success(
        message: sm_unfollow
      )
    end
  end
end
