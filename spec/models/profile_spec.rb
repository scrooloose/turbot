require "rails_helper"

RSpec.describe Profile do
  let(:me) { create(:profile) }

  describe "#messagable" do
    before do
      create(:topic, :likes_biking)
    end

    it "returns profiles that can be messaged, and haven't been already" do
      messaged_profile = create(:profile, interests: ['biking'])
      messaged_profile.received_message(sender: me, content: "foo")

      unmessagble_profile = create(:profile, interests: ['something-that-doesnt-match-anything'])
      messagable_profile = create(:profile, interests: ['biking'])

      expect(me.messagable(1).to_a).to eq([messagable_profile])
    end

    it "returns the number specified" do
      create_list(:profile, 3, interests: ['biking'])

      expect(me.messagable(2).to_a.size).to eq(2)
    end

    #FIXME: This test is not good and may always pass. #messagable should allow no arg to be given, which would cause all
    #messagable profiles to be returned. This will allow us to grab ALL
    #messagable profiles and make sure no unavailable profiles are returned.
    it "doesn't return unavailable profiles" do
      messagable_profile = create(:profile, interests: ['biking'])
      create(:profile, interests: ['biking'], unavailable: true)

      expect(me.messagable(1).to_a).to eq([messagable_profile])
    end
  end

  describe ".available" do
    it "returns profiles that aren't marked as unavailable" do
      create(:profile, unavailable: true)
      p = create(:profile, unavailable: false)
      expect(Profile.available.to_a).to match_array([p])
    end
  end

  describe "#matches_any_topic?" do
    it "is true if the profile matches a topic" do
      create(:topic, :likes_biking)
      expect(create(:profile, interests: ['biking']).matches_any_topic?).to be
    end

    it "is false if the profile matches no topics" do
      create(:topic, :likes_biking)
      expect(create(:profile, interests: ['nothing']).matches_any_topic?).to_not be
    end
  end

  it "#name is parsed out of the profile" do
    p = Profile.new(page_content: test_file_content('emma.html'))
    expect(p.name).to eq('Emma')
  end

  it "#bio is parsed out of the profile" do
    p = Profile.new(page_content: test_file_content('profile.html'))
    expect(p.bio).to match(/\AI'm adventurous.*me laugh\.\Z/m)
  end

  it "#interests are parsed out of the profile" do
    interests = Profile.new(page_content: test_file_content('profile.html')).interests

    #there are more, but this will prove the point
    expect(interests).to include('wine')
    expect(interests).to include('cheese')
  end

  describe "#sent_message" do
    let(:recipient) { ProfileFactory.create }
    let(:sender) { ProfileFactory.create }
    subject { sender.sent_message(recipient: recipient, content: "foo") }

    it "creates messages from Me" do
      expect(subject.sender_profile).to eq(sender)
    end

    it "uses the given message" do
      expect(subject.content).to eq("foo")
    end

    it "uses the current time for sent_at" do
      t = Time.zone.now
      Timecop.freeze(t) do
        expect(subject.sent_at.to_s).to eq(t.to_s)
      end
    end
  end

  describe "#received_message" do
    let(:sender) { ProfileFactory.create }
    let(:recipient) { ProfileFactory.create }
    let(:time) { Time.zone.now }
    subject { recipient.received_message(sender: sender, content: "foo", sent_at: time) }

    it "creates messages to recipient" do
      expect(subject.recipient_profile).to eq(recipient)
    end

    it "uses the given message" do
      expect(subject.content).to eq("foo")
    end

    it "uses the given time for sent_at" do
      expect(subject.sent_at.to_s).to eq(time.to_s)
    end
  end

  describe "#received?" do
    it "is true if we have received a message from the given username at the given time" do
      me = ProfileFactory.create
      them = ProfileFactory.create(username: "foobar")
      m = me.received_message(sender: them, content: "foo", sent_at: Time.now)

      expect(me.received?(username: "foobar", sent_at: m.sent_at)).to be
    end

    it "is false unless a Message exists for the given username and time" do
      me = ProfileFactory.create
      them = ProfileFactory.create(username: "foobar")
      m = me.received_message(sender: them, content: "foo", sent_at: Time.now)

      expect(me.received?(username: "not-the-same-username", sent_at: m.sent_at)).to_not be
      expect(me.received?(username: m.sender_profile.username, sent_at: m.sent_at - 1000)).to_not be
    end
  end

  describe "#responses" do
    it "gets all messages received by me in response to messages sent by me" do
      them = ProfileFactory.create
      me = ProfileFactory.create
      me.sent_message(recipient: them, sent_at: Time.now - 60, content: "foo")
      response = me.received_message(sender: them, sent_at: Time.now - 30, content: "foo")

      #some controls
      me.sent_message(recipient: ProfileFactory.create, content: "foo")
      me.received_message(sender: ProfileFactory.create, content: "bar")

      expect(me.responses.to_a).to eq([response])
    end
  end
end
