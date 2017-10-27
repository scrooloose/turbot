require "rails_helper"

RSpec.describe ProfileCacher do
  it "forwards .perform onto #perform" do
    cacher_double = instance_double(ProfileCacher)
    expect(cacher_double).to receive(:perform)

    expect(ProfileCacher).to receive(:new).with("body").and_return(cacher_double)
    ProfileCacher.perform("body")
  end

  describe "#perform" do
    it "update existing profiles" do
      profile = create(:profile, :emma)
      new_profile_content = test_file_content("emma_with_different_bio.html")

      expect {
        ProfileCacher.new(new_profile_content).perform
        profile.reload
      }.to change(profile, :bio).to("This is the bio.")

    end

    it "creates new profiles" do
      expect {
        ProfileCacher.new(File.read(test_file_path("emma.html"))).perform
      }.to change(Profile, :count).by(1)

    end
  end
end
