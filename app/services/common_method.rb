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
end
