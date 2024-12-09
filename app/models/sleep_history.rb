# frozen_string_literal: true

class SleepHistory < ApplicationRecord
  belongs_to :user

  scope :incomplete, -> { where.not(clock_in_time: nil).where(clock_out_time: nil) }
  scope :completed, -> { where.not(clock_in_time: nil).where.not(clock_out_time: nil) }
end
