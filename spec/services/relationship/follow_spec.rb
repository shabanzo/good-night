# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship::Follow do
  include ResultHandler

  let(:user) { create(:user) }
  let(:target_user) { create(:user) }

  before do
    target_user
  end

  context 'when the user does not exists but the target user does' do
    let(:follow_klass) { described_class.call(user_id: 99, target_user_id: target_user.id) }

    it 'returns failure = true' do
      expect(follow_klass).to be_failure
    end

    it 'returns code = 404' do
      expect(follow_klass.failure[:code]).to eq(404)
    end

    it 'returns proper message' do
      expect(follow_klass.failure[:error]).to eq(em_user_not_found)
    end
  end

  context 'when the user exists but the target user does not exist' do
    let(:follow_klass) { described_class.call(user_id: user.id, target_user_id: 99) }

    before do
      user
    end

    it 'returns failure = true' do
      expect(follow_klass).to be_failure
    end

    it 'returns code = 404' do
      expect(follow_klass.failure[:code]).to eq(404)
    end

    it 'returns proper message' do
      expect(follow_klass.failure[:error]).to eq(em_target_user_not_found)
    end
  end

  context 'when the user follow his/her self' do
    let(:follow_klass) { described_class.call(user_id: user.id, target_user_id: user.id) }

    before do
      user
    end

    it 'returns failure = true' do
      expect(follow_klass).to be_failure
    end

    it 'returns code = 404' do
      expect(follow_klass.failure[:code]).to eq(400)
    end

    it 'returns proper message' do
      expect(follow_klass.failure[:error]).to eq(em_follow_self)
    end
  end

  context 'when the user exists and the target user exists but the user already following the targeted user' do
    let(:follow_klass) { described_class.call(user_id: user.id, target_user_id: target_user.id) }
    let(:relationship) { create(:relationship, follower: user, followee: target_user) }

    before do
      user
      relationship
    end

    it 'returns failure = true' do
      expect(follow_klass).to be_failure
    end

    it 'returns code = 400' do
      expect(follow_klass.failure[:code]).to eq(400)
    end

    it 'returns proper message' do
      expect(follow_klass.failure[:error]).to eq(em_already_following)
    end
  end

  context 'when the user exists and the target user exists and no duplicates' do
    let(:follow_klass) { described_class.call(user_id: user.id, target_user_id: target_user.id) }

    before do
      user
      target_user
    end

    it 'returns success = true' do
      expect(follow_klass).to be_success
    end

    it 'returns proper message' do
      expect(follow_klass.success[:message]).to eq(sm_follow)
    end
  end
end
