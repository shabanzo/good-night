class CreateSleepHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in_time
      t.datetime :clock_out_time
      t.integer :duration_minutes

      t.timestamps
    end
  end
end
