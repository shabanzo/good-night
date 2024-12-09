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
end
