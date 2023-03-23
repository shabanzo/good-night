# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:target_user) { create(:user) }

  describe '#clock_in!' do
    it 'creates a new sleep_history' do
      expect {
        user.clock_in!
      }.to change(user.sleep_histories, :count).by(1)
    end
  end

  describe '#clock_out!' do
    let(:duration) { 50 }
    let(:incomplete_sleep_history) do
      create(
        :sleep_history,
        user:             user,
        clock_in_time:    Time.zone.now - duration.minutes,
        clock_out_time:   nil,
        duration_minutes: nil
      )
    end

    around { |e| Timecop.freeze(Time.zone.now) { e.run } }

    before do
      incomplete_sleep_history
    end

    it 'updates an incomplete sleep_history to be completed' do
      expect {
        user.clock_out!
      }.to change(user.sleep_histories.incomplete, :count).by(-1)
    end

    it 'calculates the duration_minutes' do
      user.clock_out!
      last_history = user.sleep_histories.last
      expect(last_history.duration_minutes).to eq(duration)
    end
  end

  describe '#follow' do
    it 'creates a new relationship' do
      expect {
        user.follow(target_user)
      }.to change(Relationship, :count).by(1)
    end

    it 'creates the correct following relationship for user' do
      user.follow(target_user)
      expect(user).to be_following(target_user)
    end

    it 'creates the correct followers relationship for target_user' do
      user.follow(target_user)
      expect(target_user.followers).to be_include(user)
    end
  end

  describe '#unfollow' do
    before do
      user.follow(target_user)
    end

    it 'destroys the correct relationship' do
      expect {
        user.unfollow(target_user)
      }.to change(Relationship, :count).by(-1)
    end

    it 'destroys the correct following relationship for user' do
      user.unfollow(target_user)
      expect(user.following?(target_user)).to be false
    end

    it 'destroys the correct follower relationship for target_user' do
      user.unfollow(target_user)
      expect(target_user.followers).not_to be_include(user)
    end
  end
end
