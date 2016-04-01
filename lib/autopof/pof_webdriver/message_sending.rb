module PofWebdriver::MessageSending
  def send_message(message: nil, profile: nil)
    Log.info "Sending message to #{profile.username}"
    login

    profile_page = visit("viewprofile.aspx?sld=1&profile_id=#{profile.pof_key}")
    msgform = profile_page.form('sendmessage')
    msgform.message = message
    raise("Should never see this. Block real sending of messages in test.") if AUTOPOF_ENV == "test"
    msgform.submit
  end
end
