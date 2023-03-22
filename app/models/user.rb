# frozen_string_literal: true

class User < ApplicationRecord
  has_many :sleep_histories

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    relationship = active_relationships.find_by(followed_id: other_user.id)
    relationship&.destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
