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

      extractor = PofMessageInfoExtractor.new(message, agent)

      message_processor.process_message(
        username: extractor.username,
        sent_at: extractor.sent_at,
        content: extractor.message_content,
        profile_page: extractor.profile_page_content
      )

      wait_between_actions
    end

    if next_page_link = inbox_page.search('#inbox-message-footer-pagination a').first
      next_page = visit(next_page_link['href'])
      wait_between_actions
      check_for_responses(next_page)
    end
  end
end

class PofMessageInfoExtractor
  attr_reader :msg_elem, :agent

  def initialize(msg_elem, agent)
    @msg_elem = msg_elem
    @agent = agent
  end

  def profile_page_content
    link = msg_elem.search("a[href*='viewprofile']").first
    agent.get(link['href']).body
  end

  def username
    message_link.search('.inbox-message-user-name, .inbox-message-user-name-upgraded').text.strip.split.first
  end

  def sent_at
    date_str = message_link.search('.inbox-message-recieved-date').text
    parse_msg_date(date_str)
  end

  def message_content
    message_page = agent.get(message_link['href'])
    message_page.search('.msg-row .message-content').last.text
  end

private

  def message_link
    @message_link ||= msg_elem.search("a[id*='inbox-readmessage-link-']").first
  end

  def parse_msg_date(str)
    DateTime.strptime(str, "%m/%d/%Y %H:%M:%S %p").strftime("%F %T")
  end

end
