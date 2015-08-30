module PofWebdriverCommon
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
end
