class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    return if table_exists? :relationships

    create_table :relationships do |t|
      t.references :follower, null: false, foreign_key: true
      t.references :followed, null: false, foreign_key: true

      t.timestamps
    end
  end
end
