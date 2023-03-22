# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "#follow" do
    it "creates a new relationship" do
      expect {
        user.follow(other_user)
      }.to change(Relationship, :count).by(1)
    end

    it "creates the correct following relationship for user" do
      user.follow(other_user)
      expect(user).to be_following(other_user)
    end

    it "creates the correct followers relationship for other_user" do
      user.follow(other_user)
      expect(other_user.followers).to be_include(user)
    end
  end

  describe "#unfollow" do
    before do
      user.follow(other_user)
    end

    it "destroys the correct relationship" do
      expect {
        user.unfollow(other_user)
      }.to change(Relationship, :count).by(-1)
    end

    it "destroys the correct following relationship for user" do
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be false
    end

    it "destroys the correct follower relationship for other_user" do
      user.unfollow(other_user)
      expect(other_user.followers).not_to be_include(user)
    end
  end
end
