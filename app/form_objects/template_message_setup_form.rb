class TemplateMessageSetupForm
  include ActiveModel::Model

  attr_accessor :interest_ids
  attr_accessor :messages

  def initialize(user_id:)
    @user_id = user_id
    init_from_user(User.find(user_id))
  end

  def update(params)
    if params[:interest_ids]
      update_for_interest_ids(params[:interest_ids])
    end

    if params[:messages]
      update_for_messages(params[:messages].values)
    end
    self
  end

  def save
    ActiveRecord::Base.transaction do
      user = User.find(user_id)
      user.template_messages.destroy_all
      interest_map.each do |interest_id, message|
        user.template_messages.create!(interest_id: interest_id, content: message)
      end
      user.save!
    end
  end

  def interests
    interest_map.keys.map { |id| Interest.find(id) }
  end

  def has_interest?(id)
    interest_map.keys.map(&:to_i).include?(id.to_i)
  end

private

  attr_reader :user_id

  def init_from_user(user)
    user.template_messages.each do |tm|
      interest_map[tm.interest_id] = tm.content
    end
  end

  #map interest_id => message
  def interest_map
    @interest_map ||= {}
  end

  def update_for_interest_ids(interest_ids)
    interest_map.clear
    interest_ids.each do |interest_id|
      interest_map[interest_id] = nil
    end
  end

  def update_for_messages(message_hashes)
    interest_map.clear
    message_hashes.map(&:symbolize_keys).each do |message_hash|
      interest_map[message_hash[:interest_id]] = message_hash[:message]
    end
  end
end
