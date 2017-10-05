require "rails_helper"

RSpec.describe Messager do
  def messager(profiles: nil, **args)
    opts = {
      dry_run: false,
      webdriver: object_double(PofWebdriver::Base.new),
      sleep_strategy: SleepStrategy.no_sleep,
      profile_repo: ProfileFactory.create,
      sender: UserFactory.create
    }.merge(args)

    opts.merge!(message_count: profiles.count) if profiles

    Messager.new(opts)
  end


  context "when dry_run is true" do
    it "doesn't send messages" do
      wd = object_double(PofWebdriver::Base.new)
      expect(wd).to_not receive(:send_message)
      messager(dry_run: true, profiles: [ProfileFactory.create_messagable], webdriver: wd).go
    end
  end

  context "when dry_run is false" do
    it "sends messages" do
      wd = object_double(PofWebdriver::Base.new)
      expect(wd).to receive(:send_message).and_return(true)

      messager(profiles: [ProfileFactory.create_messagable], webdriver: wd).go
    end
  end

  it "messages the given profiles" do
    profiles = [ProfileFactory.create_messagable, ProfileFactory.create_messagable]

    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).twice.and_return(true)

    messager(profiles: profiles, webdriver: wd, message_count: 2).go
  end

  it "retries when messaging fails" do
    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).twice.and_raise(PofWebdriver::MessageSendError)
    messager(webdriver: wd, profiles: [ProfileFactory.create_messagable], attempts: 1).go
  end

  it "marks the profile as unavailable when messaging fails" do
    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).at_least(:once).and_raise(PofWebdriver::MessageSendError)

    p = ProfileFactory.create_messagable
    messager(webdriver: wd, profiles: [p]).go

    p.reload
    expect(p.unavailable).to be
  end
end
