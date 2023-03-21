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
      return handle_failure(code: 400, error: em_incomplete_history) if incomplete_history_present?

      save_sleep_history
    end

    private def incomplete_history_present?
      user.sleep_histories.incomplete.present?
    end

    private def save_sleep_history
      # Build the history with the current time
      sleep_history = user.sleep_histories.build(clock_in_time: Time.current)

      # Save it to database
      if sleep_history.save
        # Return success if the history is successfully saved
        # I don't think that return all the records would be good
        # So I limit it to last 10 rows only descending by created_at for performance-wise
        handle_success(user.sleep_histories.order(created_at: :desc).limit(10).pluck(:clock_in_time))
      else
        # Return failure if the history is failed to save
        handle_failure(code: 400, error: em_failed_to_save(sleep_history))
      end
    end
  end
end
