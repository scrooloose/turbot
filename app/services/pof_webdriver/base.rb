module PofWebdriver
  class Error < StandardError; end
  class MessageSendError < Error; end
end

module_dir = File.dirname(__FILE__)
require "#{module_dir}/profile_fetching"
require "#{module_dir}/message_fetching"
require "#{module_dir}/message_sending"

class PofWebdriver::Base
  include PofWebdriver::ProfileFetching
  include PofWebdriver::MessageFetching
  include PofWebdriver::MessageSending

  attr_reader :message_processor, :sleep_strategy, :profile_cacher, :agent, :user

  def initialize(message_processor: ReceivedMessageProcessor, profile_cacher: ProfileCacher, sleep_strategy: SleepStrategy.new, agent: Mechanize.new, user: nil)
    @message_processor = message_processor
    @sleep_strategy = sleep_strategy
    @profile_cacher = profile_cacher
    @agent = agent
    @user = user
  end

protected

  def login
    return visit('') if @logged_in
    @logged_in ||= true

    Rails.logger.info "#{self.class.name}: Logging in"
    login_page = visit('')
    login_form = login_page.form('frmLogin')
    login_form.username = user.pof_username
    login_form.password = user.pof_password
    login_form.submit
  end

  def visit(path)
    agent.get("http://www.pof.com/#{path}")
  end

  def wait_between_actions
    sleep_strategy.sleep
  end
end
