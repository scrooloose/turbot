require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe ProfileCacher do
  describe "#cache" do
    it "update existing profiles" do
      profile = ProfileFactory.from_test_fixture("emma.html")
      new_profile_content = File.read(test_file_path("emma_with_different_bio.html"))

      expect {
        ProfileCacher.new(new_profile_content).cache
        profile.reload
      }.to change(profile, :bio).to("This is the bio.")

    end

    it "creates new profiles" do
      expect {
        ProfileCacher.new(File.read(test_file_path("emma.html"))).cache
      }.to change(Profile, :count).to(1)

    end
  end
end
