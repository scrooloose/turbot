class MessageSender
  attr_reader :message, :profile

  def initialize(message: nil, profile: nil)
    @message = message
    @profile = profile
  end

  def run
    Log.debug "Sending message to #{profile.username}"
    login
    send_message
    log_message
  end

private
  def agent
    @agent ||= Mechanize.new
  end

  def login
    Log.debug "Logging in"
    login_page = agent.get('http://www.pof.com')
    login_form = login_page.form('frmLogin')
    login_form.username = Config['pof_username']
    login_form.password = Config['pof_password']
    login_form.submit
  end

  def send_message
    profile_page = agent.get("http://www.pof.com/viewprofile.aspx?sld=1&profile_id=#{profile.pof_key}")
    msgform = profile_page.form('sendmessage')
    msgform.message = message
    msgform.submit
  end

  def log_message
    MessageRepository.instance.save(profile: profile, message: message)
  end
end
