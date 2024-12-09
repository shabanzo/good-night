# frozen_string_literal: true

class SleepHistorySerializer
  include JSONAPI::Serializer
  attributes :id, :user_name, :clock_in_time, :clock_out_time, :duration_minutes

  def user_name
    object.user.name
  end
end
