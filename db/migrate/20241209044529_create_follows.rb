# frozen_string_literal: true

class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    return if table_exists? :follows

    create_table :follows do |t|
      t.references :follower, null: false, foreign_key: true
      t.references :followee, null: false, foreign_key: true

      t.timestamps
    end

    add_index :follows, %i[follower_id followee_id], unique: true
  end
end
