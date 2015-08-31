require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe Messager do
  context "when dry_run is true" do
    it "doesn't send messages" do
      expect(Profile).to receive(:messagable).and_return(
        [ProfileFactory.build_messagable]
      )
      wd = PofWebdriver::Base.new
      m = Messager.new(dry_run: true)
      expect(wd).to_not receive(:send_message)
      m.go
    end
  end

  context "when dry_run is false" do
    it "sends messages" do
      expect(Profile).to receive(:messagable).and_return(
        [ProfileFactory.build_messagable]
      )
      wd = PofWebdriver::Base.new
      m = Messager.new(dry_run: false, webdriver: wd)
      expect(wd).to receive(:send_message).and_return(true)
      m.go
    end
  end

  it "respects the 'message_limit' param" do
    expect(Profile).to receive(:messagable).and_return(
      (1..3).map { ProfileFactory.build_messagable }
    )
    wd = PofWebdriver::Base.new
    m = Messager.new(dry_run: false, message_limit: 2, webdriver: wd)
    expect(wd).to receive(:send_message).twice.and_return(true)
    m.go
  end
end
