module PofWebdriver::ResponseFetching
  def check_for_responses_to_messages
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
    response_links = inbox_page.search("//a[contains(@id, 'inbox-readmessage-link-')]")

    response_links.each do |link|
      username = link.search('.inbox-message-user-name').text.strip.split.first
      Log.info "#{self.class.name}: processing message from #{username}"
      if waiting_for_response_from?(username)
        record_response(username, link)
        sleep(rand(5))
      end
    end

    if next_page_link = inbox_page.search('#inbox-message-footer-pagination a').first
      next_page = visit(next_page_link['href'])
      check_for_responses(next_page)
    end
  end

  def waiting_for_response_from?(username)
    Message.messages_awaiting_response_for(username).any?
  end

  def record_response(username, link)
    Log.info "#{self.class.name}: record_response(username: #{username})"
    message = Message.messages_awaiting_response_for(username).first
    resp_page = visit(link['href'])
    resp_date = parse_msg_date(resp_page.search('.msg-row div:first-of-type').first.text)
    resp_text = resp_page.search('.msg-row .message-content').last.text
    DB[:messages].where(id: message[:id]).update(response: resp_text, responded_at: resp_date)
  end

  def parse_msg_date(str)
    DateTime.strptime(str, "%m/%d/%Y %H:%M:%S %p").strftime("%F %T")
  end
end
