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
    let(:incomplete_sleep_history) { create(:incomplete_sleep_history, user: user) }

    before do
      incomplete_sleep_history
    end

    it 'updates an incomplete sleep_history to be completed' do
      expect {
        user.clock_out!
      }.to change(user.sleep_histories.incomplete, :count).by(-1)
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

    describe 'following for the 2nd time' do
      before do
        user.follow(target_user)
      end

      it 'does not follow the same user again' do
        expect {
          user.follow(target_user)
        }.not_to change(Relationship, :count)
      end
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
