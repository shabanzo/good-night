# frozen_string_literal: true

class SleepHistory
  class ClockIn
    include ResultHandler
    include CommonMethod

    attr_reader :user_id

    def initialize(user_id:)
      @user_id = user_id
    end

    class << self
      def call(user_id:)
        new(user_id: user_id).call
      end
    end

    def call
      # Find user and return failure status if it's not existed
      return handle_failure(code: 404, error: em_user_not_found) if user.blank?

      # Find incomplete history and return failure status if it's existed
      return handle_failure(code: 400, error: em_incomplete_history_exists) if incomplete_history_present?

      user.clock_in!

      # I don't think that return all the records would be good
      # So I limit it to last 5 rows only descending by created_at for performance-wise
      handle_success(
        message: sm_clock_in,
        data:    user.sleep_histories.order(created_at: :desc).limit(5).pluck(:clock_in_time)
      )
    end

    private

    def incomplete_history_present?
      user.sleep_histories.incomplete.present?
    end
  end
end
