# frozen_string_literal: true

module ResultHandler
  private def handle_success(payload)
    OpenStruct.new(
      success?: true,
      failure?: false,
      success:  payload
    )
  end

  private def handle_failure(payload)
    OpenStruct.new(
      success?: false,
      failure?: true,
      failure:  payload
    )
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

  def em_clocked_in_history
    "Bad request; You do not have clocked in sleep history! Please clock in first!"
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

  def sm_clock_out
    'Congratulations, your clock-out has been recorded successfully!'
  end

  def sm_follow
    'You are now following this user!'
  end

  def sm_unfollow
    'You are now unfollow this user!'
  end
end
