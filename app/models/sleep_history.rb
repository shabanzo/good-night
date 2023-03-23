# frozen_string_literal: true

class SleepHistory < ApplicationRecord
  belongs_to :user

  scope :incomplete, -> { where.not(clock_in_time: nil).where(clock_out_time: nil) }

  before_update :calculate_duration

  private def calculate_duration
    self.duration_minutes = ((clock_out_time - clock_in_time) / 60).to_i
  end
end
