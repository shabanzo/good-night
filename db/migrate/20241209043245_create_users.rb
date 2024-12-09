# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    return if table_exists? :users

    create_table :users do |t|
      t.string :name

      t.timestamps
    end
  end
end
