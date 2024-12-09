# frozen_string_literal: true

module ResultHandler
  private

  # Struct for success responses
  ResultSuccess = Struct.new(:success?, :failure?, :success)
  # Struct for failure responses
  ResultFailure = Struct.new(:success?, :failure?, :failure)

  def handle_success(payload)
    ResultSuccess.new(true, false, payload)
  end

  def handle_failure(payload)
    ResultFailure.new(false, true, payload)
  end

  # === Error messages ===
  # User
  def em_user_not_found
    I18n.t('user.errors.not_found')
  end

  def em_target_user_not_found
    I18n.t('user.errors.target_user_not_found')
  end

  # Clock In / Clock Out
  def em_incomplete_history_exists
    I18n.t('user.clock_in.errors.incomplete_history_exists')
  end

  def em_incomplete_history_does_not_exist
    I18n.t('user.clock_out.errors.incomplete_history_does_not_exist')
  end

  # Follow / Unfollow
  def em_follow_self
    I18n.t('user.follow.errors.follow_self')
  end

  def em_already_following
    I18n.t('user.follow.errors.already_following')
  end

  def em_already_unfollowed
    I18n.t('user.unfollow.errors.already_unfollowed')
  end

  # === Success messages ===
  # Clock In / Clock Out
  def sm_clock_in
    I18n.t('user.clock_in.success')
  end

  def sm_clock_out
    I18n.t('user.clock_out.success')
  end

  # Follow / Unfollow
  def sm_follow
    I18n.t('user.follow.success')
  end

  def sm_unfollow
    I18n.t('user.unfollow.success')
  end
end
