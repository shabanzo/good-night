class ChangeClockInTimeDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :sleep_histories, :clock_in_time, -> { 'CURRENT_TIMESTAMP' }
  end
end
