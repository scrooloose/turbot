module PofWebdriver; end

module_dir = File.dirname(__FILE__)
require "#{module_dir}/profile_fetching"
require "#{module_dir}/response_fetching"
require "#{module_dir}/message_sending"

class PofWebdriver::Base
  include PofWebdriver::ProfileFetching
  include PofWebdriver::ResponseFetching
  include PofWebdriver::MessageSending

  MinWaitTime=60       #wait at least 1 min
  WaitRandVariance=180 #and up to 3 mins after that

protected

  def login
    return visit('') if @logged_in
    @logged_in ||= true

    Log.info "#{self.class.name}: Logging in"
    login_page = visit('')
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

  def wait_between_actions
    sleep(MinWaitTime + rand(WaitRandVariance))
  end

end
