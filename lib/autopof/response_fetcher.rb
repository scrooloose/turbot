class ResponseFetcher
  include PofWebdriverCommon

  def initialize
  end

  def check_responses
    login
    inbox_page = goto_inbox
    check_for_responses(inbox_page)
  end

  def goto_inbox
    Log.debug "#{self.class.name}: goto_inbox"
    agent.get("http://www.pof.com/inbox.aspx")
  end

  def check_for_responses(inbox_page)
    Log.debug "#{self.class.name}: check_for_responses"
    response_links = inbox_page.search("//a[contains(@id, 'inbox-readmessage-link-')]")

    response_links.each do |link|
      username = link.search('.inbox-message-user-name').text.strip.split.first
      Log.debug "#{self.class.name}: processing message from #{username}"
      if waiting_for_response_from?(username)
        record_response(username, link)
      end
    end
  end

  def waiting_for_response_from?(username)
    MessageRepository.instance.messages_awaiting_response_for(username).any?
  end

  def record_response(username, link)
    Log.debug "#{self.class.name}: record_response(username: #{username})"
    message = MessageRepository.instance.messages_awaiting_response_for(username).first
    resp_page = agent.get("http://www.pof.com/#{link['href']}")
    resp_date = parse_msg_date(resp_page.search('.msg-row div:first-of-type').first.text)
    resp_text = resp_page.search('.msg-row .message-content').last.text
    DB[:messages].where(id: message[:id]).update(response: resp_text, responded_at: resp_date)
    goto_inbox
  end

  def parse_msg_date(str)
    DateTime.strptime(str, "%m/%d/%Y %H:%M:%S %p").strftime("%F %T")
  end
end

