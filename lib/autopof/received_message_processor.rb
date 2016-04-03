class ReceivedMessageProcessor
  attr_reader :username, :sent_at, :content, :profile_page

  def initialize(username: nil, sent_at: nil, content: nil, profile_page: nil)
    @username = username
    @sent_at = sent_at
    @content = content
    @profile_page = profile_page
  end

  def go
    unless Message.received?(username: username, sent_at: sent_at)
      Message.create_received_message(sender: sender_profile, content: content, sent_at: sent_at)
    end
  end

private

  def sender_profile
    if profile = Profile.find(username: username)
      return profile
    end

    ProfileCacher.new(profile_page).cache
  end
end
