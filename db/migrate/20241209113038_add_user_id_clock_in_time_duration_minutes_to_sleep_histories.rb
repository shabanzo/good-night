# frozen_string_literal: true

class AddUserIdClockInTimeDurationMinutesToSleepHistories < ActiveRecord::Migration[8.0]
  def change
    add_index :sleep_histories, %i[user_id clock_in_time duration_minutes]
  end
end
