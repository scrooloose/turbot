require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe Profile do
  def test_parser(file: 'profile.html')
    ProfileParser.new(page_content: File.read(test_file_path(file)))
  end

  describe "#profile" do
    it "populates the interests - all downcased" do
      expected = ['the outdoors', 'wine', 'cheese', 'laughter', 'hiking',
                  'camping', 'music', 'log fires', 'adventures', 'ale']

      expect(test_parser.profile.interests.to_set).to eq(expected.to_set)
    end

    it "populates the bio" do
      desc = test_parser.profile.bio
      expected = <<-STR
        I'm adventurous and like to be spontaneous when I can be. I like to
        travel and spend time outdoors. However, I also like to get home and
        have a glass of wine or pint of ale in the evening afterwards.

        I spend a lot of time with my friends whether its eating in or out, or
        going to watch live music.

        I like to laugh and people that can make me laugh.
      STR

      #strip out all the white space to make things easier
      expect(desc.gsub(/\s/, '')).to eq(expected.gsub(/\s/, ''))
    end

    it "populates name if present on profile" do
      expect(test_parser(file: 'profile2.html').profile.name).to eq('Emma')
    end

    it "returns nil for name if not present on profile" do
      expect(test_parser(file: 'profile.html').profile.name).to be_nil
    end

    it "populates 'pof_key'" do
      expect(test_parser(file: 'profile.html').profile.pof_key).to eq("95213413")
    end

    it "populates 'username'" do
      expect(test_parser(file: 'profile.html').profile.username).to eq("misshubble2")
    end
  end
end
