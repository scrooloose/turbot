class MessageSender
  attr_reader :message, :profile

  def initialize(message: nil, profile: nil)
    @message = message
    @profile = profile
  end

  def run
    login
    send_message
    log_message
  end

private
  def agent
    @agent ||= Mechanize.new
  end

  def login
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
    #TODO: make this not suck
    profile_id = ProfileRecord[pof_key: profile.pof_key].id

    MessageRecord.create(content: message, profile_id: profile_id)
  end
end
