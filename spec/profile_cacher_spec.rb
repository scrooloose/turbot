require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe ProfileCacher do
  it "forwards .cache onto #cache" do
    cacher_double = instance_double(ProfileCacher)
    expect(cacher_double).to receive(:cache)

    expect(ProfileCacher).to receive(:new).with("body").and_return(cacher_double)
    ProfileCacher.cache("body")
  end

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
      }.to change(Profile, :count).by(1)

    end
  end
end
