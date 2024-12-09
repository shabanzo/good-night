# frozen_string_literal: true

class User < ApplicationRecord
  has_many :sleep_histories

  has_many :active_relationships, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Follow', foreign_key: 'followee_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followee
  has_many :followers, through: :passive_relationships, source: :follower

  def clock_in!
    sleep_histories.create
  end

  def clock_out!
    sleep_histories.incomplete.last.update clock_out_time: DateTime.current
  end
end
