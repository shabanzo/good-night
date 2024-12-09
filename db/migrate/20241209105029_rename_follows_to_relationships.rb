# frozen_string_literal: true

class RenameFollowsToRelationships < ActiveRecord::Migration[8.0]
  def change
    rename_table :follows, :relationships
  end
end
