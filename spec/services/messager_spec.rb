require "rails_helper"

RSpec.describe Messager do
  def messager(profiles: nil, **args)
    opts = {
      dry_run: false,
      webdriver: object_double(PofWebdriver::Base.new),
      sleep_strategy: SleepStrategy.no_sleep,
      profile_repo: create(:profile),
      sender: create(:user)
    }.merge(args)

    opts.merge!(message_count: profiles.count) if profiles

    Messager.new(opts)
  end

  before do
    create(:topic, :likes_biking)
  end

  def messagable_profile
    create(:profile, interests: ['biking'])
  end

  context "when dry_run is true" do
    it "doesn't send messages" do
      wd = object_double(PofWebdriver::Base.new)
      expect(wd).to_not receive(:send_message)
      messager(dry_run: true, profiles: [messagable_profile], webdriver: wd).go
    end
  end

  context "when dry_run is false" do
    it "sends messages" do
      wd = object_double(PofWebdriver::Base.new)
      expect(wd).to receive(:send_message).and_return(true)

      messager(profiles: [messagable_profile], webdriver: wd).go
    end
  end

  it "messages the given profiles" do
    profiles = [messagable_profile, messagable_profile]

    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).twice.and_return(true)

    messager(profiles: profiles, webdriver: wd, message_count: 2).go
  end

  it "retries when messaging fails" do
    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).twice.and_raise(PofWebdriver::MessageSendError)
    messager(webdriver: wd, profiles: [messagable_profile], attempts: 1).go
  end

  it "marks the profile as unavailable when messaging fails" do
    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).at_least(:once).and_raise(PofWebdriver::MessageSendError)

    p = messagable_profile
    messager(webdriver: wd, profiles: [p]).go

    p.reload
    expect(p.unavailable).to be
  end
end
