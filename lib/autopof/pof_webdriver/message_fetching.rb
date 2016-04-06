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

      message_processor.process_message(
        username: extract_username(message),
        sent_at: extract_sent_at(message),
        content: extract_message_content(message),
        profile_page: extract_profile_page(message)
      )

      wait_between_actions
    end

    if next_page_link = inbox_page.search('#inbox-message-footer-pagination a').first
      next_page = visit(next_page_link['href'])
      wait_between_actions
      check_for_responses(next_page)
    end
  end

  def extract_profile_page(message)
    link = message.search("a[href*='viewprofile']").first
    visit(link['href']).body
  end

  def extract_username(message)
    message_link(message).search('.inbox-message-user-name, .inbox-message-user-name-upgraded').text.strip.split.first
  end

  def extract_sent_at(message)
    date_str = message_link(message).search('.inbox-message-recieved-date').text
    parse_msg_date(date_str)
  end

  def message_link(message)
    message.search("a[id*='inbox-readmessage-link-']").first
  end

  def extract_message_content(message)
    message_page = visit(message_link(message)['href'])
    message_page.search('.msg-row .message-content').last.text
  end

  def parse_msg_date(str)
    DateTime.strptime(str, "%m/%d/%Y %H:%M:%S %p").strftime("%F %T")
  end
end
