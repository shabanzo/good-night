# frozen_string_literal: true

class Api::V1::Users::SleepHistoriesController < ApplicationController
  # POST /api/v1/users/:user_id/sleep_histories/clock_in
  def clock_in
    if clock_in_klass.success?
      render json: {
        message: clock_in_klass.success[:message],
        data:    clock_in_klass.success[:data]
      }, status: :created
    else
      render json: {
        message: clock_in_klass.failure[:error]
      }, status: clock_in_klass.failure[:code]
    end
  end

  private

  def clock_in_klass
    @clock_in_klass ||= ::SleepHistory::ClockIn.call(user_id: params[:user_id])
  end
end
