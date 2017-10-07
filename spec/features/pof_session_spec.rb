require 'rails_helper'

feature 'POF session' do
  scenario 'runs and sends messages and caches profiles', :vcr do
    #some of our actions are randomized, so make sure we start with the same
    #seed everytime, otherwise we will deviate from the recorded session
    srand(1)

    #NOTE: I search/replaced the tape here to remove the real auth
    user = create(:user, pof_username: "my_fake_username", pof_password: "my_fake_password")

    create(:topic,
           matchers: "running",
           message: "I'm also into running. Did you run the Bristol half this year?")

    VCR.use_cassette "pof_session" do
      run_session(user: user)
    end

    #the first 2 messages were already in my account. The final message is the
    #one we just sent to someone
    expect(Message.all.map(&:sender_profile).map(&:username)).to match_array(
      ["markus", "pof_user_1"]
    )

    #the first is from markus (site admin) to us. The final message is the
    #one we just sent
    expect(Message.all.map(&:recipient_profile).map(&:username)).to match_array(
      ["pof_user_1", "Hannie87"]
    )

    expect(Profile.count).to eq(34)
  end

  def run_session(user:)
      sleep_strategy = SleepStrategy.no_sleep
      wd = PofWebdriver::Base.new(sleep_strategy: sleep_strategy, user: user)
      messager = Messager.new(dry_run: false,
                              webdriver: wd, sender: user,
                              profile_repo: user.profile,
                              message_count: 1,
                              sleep_strategy: sleep_strategy)

      PofSession.new(
        search_pages_to_process: 4,
        dry_run: false,
        webdriver: wd,
        messager: messager
      ).run

  end
end

