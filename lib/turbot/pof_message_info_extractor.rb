class PofMessageInfoExtractor
  PofAdminUsernames = ["markus"]

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
    @username ||= message_link.search('.inbox-message-user-name, .inbox-message-user-name-upgraded').text.strip.split.first
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
