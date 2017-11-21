class SettingsController < ApplicationController
  SettingActions = ["messages", "interests"]

  before_action :require_login

  def edit
    raise(ActiveRecord::RecordNotFound) unless SettingActions.include?(params[:id])
    self.send("edit_#{params[:id]}")
  end

  def update
    raise(ActiveRecord::RecordNotFound) unless SettingActions.include?(params[:id])
    self.send("update_#{params[:id]}")
  end

private

  def edit_messages
    @template_messages = current_user.template_messages.where.not(
      state: TemplateMessage::STATE_DISABLED
    )
  end

  def edit_interests
    @interests = Interest.all
  end

  def update_interests
    current_user.update_enabled_interests(
      enabled_interest_ids: params[:interest_ids].map(&:to_i)
    )

    redirect_to edit_setting_path(id: "messages"), notice: "Interests Updated"
  end

  def update_messages
    params[:messages].values.each do |message|
      template_message = current_user.template_messages.find_or_initialize_by(interest: Interest.find(message["interest_id"]))
      template_message.content = message["message"]

      unless template_message.content.present?
        template_message.content_removed! if template_message.may_content_removed?
      end

      template_message.save!
    end

    redirect_to edit_setting_path, id: "messages", notice: "Messages Updated"
  end

end
