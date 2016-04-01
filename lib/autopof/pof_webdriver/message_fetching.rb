module PofWebdriver::MessageFetching
  def check_messages
    login
    inbox_page = goto_inbox
    check_for_responses(inbox_page)
  end

private
  def goto_inbox
    Log.info "#{self.class.name}: goto_inbox"
    visit("inbox.aspx")
  end

  def check_for_responses(inbox_page)
    Log.info "#{self.class.name}: check_for_responses"
    messages = inbox_page.search(".inbox-message-wrapper")

    messages.each do |message|
      process_message(message)
      wait_between_actions
    end

    if next_page_link = inbox_page.search('#inbox-message-footer-pagination a').first
      next_page = visit(next_page_link['href'])
      wait_between_actions
      check_for_responses(next_page)
    end
  end

  def waiting_for_response_from?(username)
    Message.messages_awaiting_response_for(username).any?
  end

  def process_message(message)
    profile_link = message.search("a[href*='viewprofile']").first
    message_link = message.search("a[id*='inbox-readmessage-link-']").first

    username = message_link.search('.inbox-message-user-name, .inbox-message-user-name-upgraded').text.strip.split.first
    sent_at = parse_msg_date(message_link.search('.inbox-message-recieved-date').text)
    Log.info "#{self.class.name}: processing message from #{username} at #{sent_at}"

    unless Message.exists_for?(username: username, sent_at: sent_at)
      sender_profile = cache_profile_for(username, profile_link)
      message_page = visit(message_link['href'])
      message = message_page.search('.msg-row .message-content').last.text
      Message.create_received_message(sender: sender_profile, content: message, sent_at: sent_at)
    end
  end

  def cache_profile_for(username, profile_link)
    if profile = Profile.find(username: username)
      return profile
    end

    ProfileCacher.new(visit(profile_link['href']).body).cache
  end

  def record_response(username, link)
    Log.info "#{self.class.name}: record_response(username: #{username})"
  end

  def parse_msg_date(str)
    DateTime.strptime(str, "%m/%d/%Y %H:%M:%S %p").strftime("%F %T")
  end
end
