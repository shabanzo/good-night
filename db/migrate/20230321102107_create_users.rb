class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    return if table_exists? :users

    create_table :users do |t|
      t.string :name

      t.timestamps
    end
  end
end
