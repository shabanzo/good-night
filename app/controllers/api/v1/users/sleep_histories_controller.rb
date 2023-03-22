# frozen_string_literal: true

module Api
  module V1
    module Users
      class SleepHistoriesController < ApplicationController
        def clock_in
          clock_in_klass = ::SleepHistory::ClockIn.call(user_id: params[:user_id])
          if clock_in_klass.success?
            render json: clock_in_klass.success, status: :created
          else
            render json: {
              message: clock_in_klass.failure[:error]
            }, status: clock_in_klass.failure[:code]
          end
        end
      end
    end
  end
end
