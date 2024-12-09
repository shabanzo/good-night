# frozen_string_literal: true

class User < ApplicationRecord
  has_many :sleep_histories

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followee_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followee
  has_many :followers, through: :passive_relationships, source: :follower

  def clock_in!
    sleep_histories.create
  end

  def clock_out!
    sleep_histories.incomplete.last.update clock_out_time: DateTime.current
  end

  def follow(target_user)
    active_relationships.find_or_create_by(followee_id: target_user.id)
  end

  def unfollow(target_user)
    relationship = active_relationships.find_by(followee_id: target_user.id)
    relationship&.destroy
  end

  def following?(target_user)
    following.include?(target_user)
  end

  def past_week_following_sleep_histories
    following_ids = following.select(:id)
    SleepHistory.includes(:user).where(
      users:         { id: following_ids },
      clock_in_time: 1.week.ago.beginning_of_day..Time.current
    ).order(:duration_minutes)
  end
end
