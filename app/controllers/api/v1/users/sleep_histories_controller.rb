# frozen_string_literal: true

module Api
  module V1
    module Users
      class SleepHistoriesController < ApplicationController
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

        private def clock_in_klass
          @clock_in_klass ||= ::SleepHistory::ClockIn.call(user_id: params[:user_id])
        end

        def clock_out
          if clock_out_klass.success?
            render json: {
              message: clock_out_klass.success[:message],
              data:    clock_out_klass.success[:data]
            }, status: :ok
          else
            render json: {
              message: clock_out_klass.failure[:error]
            }, status: clock_out_klass.failure[:code]
          end
        end

        private def clock_out_klass
          @clock_out_klass ||= ::SleepHistory::ClockOut.call(user_id: params[:user_id])
        end

        def following
          render json: following_records, each_serializer: SleepHistorySerializer, status: :ok
        end

        private def user
          @user ||= User.find(params[:user_id])
        end

        private def following_records
          # Pagination for performance-wise
          @following_records ||= user.past_week_following_sleep_histories.
                                 page(page).per(per_page)
        end

        private def page
          params[:page] || 1
        end

        private def per_page
          params[:per_page] || 10
        end
      end
    end
  end
end
