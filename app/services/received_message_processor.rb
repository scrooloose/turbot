class ReceivedMessageProcessor
  attr_reader :username, :sent_at, :content, :profile_page, :recipient

  def self.process_message(**args)
    new(args).process_message
  end

  def initialize(recipient:, username:, sent_at:, content:, profile_page: nil)
    @username = username
    @sent_at = sent_at
    @content = content
    @profile_page = profile_page
    @recipient = recipient
  end

  def process_message
    Rails.logger.info "#{self.class.name}: processing message from #{username} at #{sent_at}"

    unless recipient.received?(username: username, sent_at: sent_at)
      recipient.received_message(sender: sender_profile, content: content, sent_at: sent_at)
    end
  end

private

  def sender_profile
    if profile = Profile.find_by(username: username)
      return profile
    end

    ProfileCacher.new(profile_page).cache
  end
end
