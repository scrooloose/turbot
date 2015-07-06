require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe Messager do
  context "when dry_run is true" do
    it "doesn't send messages" do
      expect(ProfileRepository.instance).to receive(:messagable_profiles).and_return(
        [ProfileFactory.build_messagable]
      )
      m = Messager.new(dry_run: true)
      expect(MessageSender).to_not receive(:new)
      m.go
    end
  end

  context "when dry_run is false" do
    it "sends messages" do
      expect(ProfileRepository.instance).to receive(:messagable_profiles).and_return(
        [ProfileFactory.build_messagable]
      )
      m = Messager.new(dry_run: false)
      expect(MessageSender).to receive(:new).and_return(double(run: nil))
      m.go
    end
  end

  it "respects the 'message_limit' param" do
    expect(ProfileRepository.instance).to receive(:messagable_profiles).and_return(
      (1..3).map { ProfileFactory.build_messagable }
    )
    m = Messager.new(dry_run: false, message_limit: 2)
    expect(MessageSender).to receive(:new).twice.and_return(double(run: nil))
    m.go
  end

end
