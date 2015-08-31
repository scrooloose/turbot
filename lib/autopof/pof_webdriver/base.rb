module PofWebdriver; end

module_dir = File.dirname(__FILE__)
require "#{module_dir}/profile_fetching"
require "#{module_dir}/response_fetching"
require "#{module_dir}/message_sending"

class PofWebdriver::Base
  include PofWebdriver::ProfileFetching
  include PofWebdriver::ResponseFetching
  include PofWebdriver::MessageSending

protected

  def login
    Log.debug "#{self.class.name}: Logging in"
    login_page = agent.get('http://www.pof.com')
    login_form = login_page.form('frmLogin')
    login_form.username = Config['pof_username']
    login_form.password = Config['pof_password']
    login_form.submit
  end

  def agent
    @agent ||= Mechanize.new
  end

  def visit(path)
    agent.get("http://www.pof.com/#{path}")
  end

end
