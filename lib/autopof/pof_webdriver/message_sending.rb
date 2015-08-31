module PofWebdriver::MessageSending
  def send_message(message: nil, profile: nil)
    Log.debug "Sending message to #{profile.username}"
    login

    profile_page = visit("viewprofile.aspx?sld=1&profile_id=#{profile.pof_key}")
    msgform = profile_page.form('sendmessage')
    msgform.message = message
    msgform.submit

    MessageRepository.instance.save(profile: profile, message: message)
  end
end
