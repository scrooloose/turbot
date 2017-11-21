class InterestPreferenceProcessor
  attr_reader :user, :interest_ids

  def initialize(user:, interest_ids:)
    @user = user
    @interest_ids = interest_ids
  end

  def perform
    process_existing_template_messages
    create_new_template_messages
  end

private

  def process_existing_template_messages
    user.template_messages.each do |template_message|
      want_enabled = interest_ids.include?(template_message.interest_id)

      if want_enabled && template_message.may_enable?
        template_message.enable!
        next
      end

      if !want_enabled && template_message.may_disable?
        template_message.disable!
        next
      end
    end
  end

  def create_new_template_messages
    interests_to_create_messages_for.each do |id|
      user.template_messages.create!(
        interest_id: id,
        state: TemplateMessage::STATE_PENDING_CONTENT
      )
    end
  end

  def interests_to_create_messages_for
    interest_ids.select do |id|
      !user.template_messages.exists?(interest_id: id)
    end

  end
end
