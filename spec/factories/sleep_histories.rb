FactoryBot.define do
  factory :sleep_history do
    clock_in_time { "2023-03-21 17:25:12" }
    clock_out_time { "2023-03-21 17:25:12" }
    duration_minutes { 1 }
  end
end
