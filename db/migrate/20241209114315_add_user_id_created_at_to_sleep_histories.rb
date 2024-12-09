class AddUserIdCreatedAtToSleepHistories < ActiveRecord::Migration[8.0]
  def change
    add_index :sleep_histories, %i[user_id created_at]
  end
end
