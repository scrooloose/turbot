require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe Messager do
  context "when dry_run is true" do
    it "doesn't send messages" do
      wd = object_double(PofWebdriver::Base.new)
      expect(wd).to_not receive(:send_message)
      Messager.new(dry_run: true, profiles: [ProfileFactory.build_messagable], sleep_between_msgs: false, webdriver: wd).go
    end
  end

  context "when dry_run is false" do
    it "sends messages" do
      wd = object_double(PofWebdriver::Base.new)
      expect(wd).to receive(:send_message).and_return(true)

      Messager.new(dry_run: false, profiles: [ProfileFactory.build_messagable], webdriver: wd, sleep_between_msgs: false).go
    end
  end

  it "messages the given profiles" do
    profiles = [
      ProfileFactory.create_messagable,
      ProfileFactory.create_messagable
    ]

    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).twice.and_return(true)

    Messager.new(dry_run: false, webdriver: wd, profiles: profiles, sleep_between_msgs: false).go
  end

  it "retries when messaging fails" do
    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).twice.and_raise(StandardError)
    Messager.new(dry_run: false, webdriver: wd, profiles: [ProfileFactory.create_messagable], sleep_between_msgs: false, retries: 1).go
  end

  it "marks the profile as unavailable when messaging fails" do
    wd = object_double(PofWebdriver::Base.new)
    expect(wd).to receive(:send_message).at_least(:once).and_raise(NoMethodError)

    p = ProfileFactory.create_messagable
    Messager.new(dry_run: false, webdriver: wd, profiles: [p], sleep_between_msgs: false).go

    p.reload
    expect(p.unavailable).to be
  end
end
