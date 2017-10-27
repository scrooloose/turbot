require "rails_helper"

RSpec.describe Messager do
  def messager(profiles:, sender:, **args)
    opts = {
      dry_run: false,
      webdriver: object_double(PofWebdriver::Base.new),
      sleep_strategy: SleepStrategy.no_sleep,
      profile_repo: create(:profile),
      sender: sender
    }.merge(args)

    opts.merge!(message_count: profiles.count) if profiles

    Messager.new(opts)
  end

  before do
    @sender = create(:user)
    @biking = create(:interest, :biking)
    @sender.template_messages << create(:template_message, interest: @biking)
    @messagable_profile = create(:profile, interests: [@biking])
    @messagable_profile2 = create(:profile, interests: [@biking])
  end

  context "when dry_run is true" do
    it "doesn't send messages" do
      wd = object_double(PofWebdriver::Base.new)
      expect(wd).to_not receive(:send_message)
      messager(dry_run: true, profiles: [@messagable_profile], sender: @sender, webdriver: wd).perform
    end
  end

  context "when dry_run is false" do
    it "sends messages" do
      wd = object_double(PofWebdriver::Base.new)
      expect(wd).to receive(:send_message).and_return(true)

      messager(profiles: [@messagable_profile], sender: @sender, webdriver: wd).perform
    end
  end

  it "messages the given profiles" do
    profiles = [@messagable_profile, @messagable_profile2]

    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).twice.and_return(true)

    messager(profiles: profiles, sender: @sender, webdriver: wd, message_count: 2).perform
  end

  it "retries when messaging fails" do
    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).twice.and_raise(PofWebdriver::MessageSendError)
    messager(webdriver: wd, profiles: [@messagable_profile], sender: @sender, attempts: 1).perform
  end

  it "marks the profile as unavailable when messaging fails" do
    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).at_least(:once).and_raise(PofWebdriver::MessageSendError)

    messager(webdriver: wd, profiles: [@messagable_profile], sender: @sender).perform

    expect(@messagable_profile.reload.unavailable).to be
  end
end
