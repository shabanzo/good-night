# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    follower { nil }
    followee { nil }
  end
end
