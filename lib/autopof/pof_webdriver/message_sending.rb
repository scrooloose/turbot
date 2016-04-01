module PofWebdriver::MessageSending
  def send_message(message: nil, profile: nil, dry_run: false)
    Log.info "Sending message to #{profile.username}"
    login

    profile_page = visit("viewprofile.aspx?sld=1&profile_id=#{profile.pof_key}")
    msgform = profile_page.form('sendmessage')

    #FIXME: this will fail with
    #  Failed to send message to 1happysmiler
    #  undefined method `message=' for nil:NilClass
    #  /home/marty/projects/autopof/lib/autopof/pof_webdriver/message_sending.rb:8:in `send_message'
    #  /home/marty/projects/autopof/lib/autopof/messager.rb:26:in `attempt_to_send'
    #  /home/marty/projects/autopof/lib/autopof/messager.rb:16:in `block in go'
    #  /home/marty/projects/autopof/lib/autopof/messager.rb:13:in `each'
    #  /home/marty/projects/autopof/lib/autopof/messager.rb:13:in `go'
    #  ./bin/pof_session_runner.rb:37:in `send_some_messages'
    #  ./bin/pof_session_runner.rb:13:in `run'
    #  ./bin/pof_session_runner.rb:45:in `<main>'
    #
    #if the profile has been deleted from pof
    msgform.message = message

    unless dry_run
      msgform.submit
      Message.create_sent_message(recipient: profile, content: message)
    end
  end
end
