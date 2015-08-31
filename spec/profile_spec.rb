require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe Profile do
  describe ".messagable" do
    it "returns profiles that have not been messaged" do
      messaged_profile = ProfileFactory.create
      MessageFactory.create(response: "the response", responded_at: DateTime.now, profile: messaged_profile)
      unmessaged_profile = ProfileFactory.create

      expect(Profile.messagable.to_a).to eq([unmessaged_profile])
    end
  end

  it "#name is parsed out of the profile" do
    p = ProfileFactory.from_test_fixture('profile.html')
    expect(p.username).to eq('misshubble2')
  end

  it "#bio is parsed out of the profile" do
    p = ProfileFactory.from_test_fixture('profile.html')
    expect(p.bio).to match(/\AI'm adventurous.*me laugh\.\Z/m)
  end

  it "#interests are parsed out of the profile" do
    interests = ProfileFactory.from_test_fixture('profile.html').interests

    #there are more, but this will prove the point
    expect(interests).to include('wine')
    expect(interests).to include('cheese')
  end
end
