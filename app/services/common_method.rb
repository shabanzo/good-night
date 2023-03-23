# frozen_string_literal: true

module CommonMethod
  def user
    User.find(user_id)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def target_user
    User.find(target_user_id)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  # Error messages
  def em_user_not_found
    "Not found; User not found!"
  end

  def em_target_user_not_found
    "Not found; Target user not found!"
  end

  def em_incomplete_history
    "Bad request; You have incomplete sleep history! Please clock it out first!"
  end

  def em_already_following
    "Bad request; You are already following the target user!"
  end

  def em_already_unfollowed
    "Bad request; You've already unfollowed the target user!"
  end

  def em_failed_to_save(obj)
    "Failed to save; #{obj.errors.full_messages.join('; ')}"
  end

  # Success messages
  def sm_clock_in
    'Congratulations, your clock-in has been recorded successfully!'
  end

  def sm_follow
    'You are now following this user!'
  end

  def sm_unfollow
    'You are now unfollow this user!'
  end
end
