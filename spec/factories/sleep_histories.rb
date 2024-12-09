# frozen_string_literal: true

FactoryBot.define do
  factory :sleep_history do
    association :user
    clock_in_time { Faker::Time.between_dates(from: Date.current - 30, to: Date.current, period: :night) }
    clock_out_time { Faker::Time.between_dates(from: Date.current - 30, to: Date.current, period: :morning) }
    duration_minutes { Faker::Number.number(digits: 2) }
  end

  factory :incomplete_sleep_history, class: 'SleepHistory' do
    association :user
    clock_in_time { DateTime.current.beginning_of_day }
  end
end
