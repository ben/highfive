module AdminHelper
  def name_fallback(slack_user)
    slack_user.real_name.blank? ? slack_user.name : slack_user.real_name
  end
end
