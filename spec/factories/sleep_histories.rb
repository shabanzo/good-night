# frozen_string_literal: true

FactoryBot.define do
  factory :incomplete_sleep_history, class: 'SleepHistory' do
    association :user
    clock_in_time { DateTime.current.beginning_of_day }
  end
end
