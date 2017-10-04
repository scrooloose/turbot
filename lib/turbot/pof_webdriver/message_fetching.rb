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

      begin
        message_processor.process_message(
          username: extractor.username,
          sent_at: extractor.sent_at,
          content: extractor.message_content,
          profile_page: extractor.profile_page_content,
          recipient: user.profile
        )
      rescue StandardError => e
        Log.info(".process_message failed for message content: #{message}", stdout: true)
        Log.info(e.message, stdout: true)
        Log.info(e.backtrace, stdout: true)
        next
      end

      wait_between_actions
    end

    if next_page_link = inbox_page.search('#inbox-message-footer-pagination a').first
      next_page = visit(next_page_link['href'])
      wait_between_actions
      check_for_responses(next_page)
    end
  end
end
