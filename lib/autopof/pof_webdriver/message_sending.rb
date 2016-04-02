module PofWebdriver::MessageSending
  def send_message(message: nil, profile: nil)
    raise("Block real sending of messages in test. Should never see this.") if AUTOPOF_ENV == "test"

    Log.info "Sending message to #{profile.username}"
    login

    profile_page = visit("viewprofile.aspx?sld=1&profile_id=#{profile.pof_key}")

    msgform = profile_page.form('sendmessage')

    begin
      #We know this one line is where it fails (msgform is nil) if the profile
      #page no longer exists, so rescue just this. Not sure if this is best
      #practise... so might be refactored later.
      msgform.message = message
    rescue => e
      raise PofWebdriver::MessageSendError.new(e.message)
    end

    msgform.submit
  end
end
