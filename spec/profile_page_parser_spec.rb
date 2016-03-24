require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe ProfilePageParser do
  def test_parser(file: 'profile.html')
    ProfilePageParser.new(page_content: File.read(test_file_path(file)))
  end

  it "parses the interests - all downcased" do
    expected = ['the outdoors', 'wine', 'cheese', 'laughter', 'hiking',
                'camping', 'music', 'log fires', 'adventures', 'ale']

    expect(test_parser.interests.to_set).to eq(expected.to_set)
  end

  it "parses the bio" do
    desc = test_parser.bio
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

  it "parses name if present on profile" do
    expect(test_parser(file: 'emma.html').name).to eq('Emma')
  end

  it "returns nil for name if not present on profile" do
    expect(test_parser(file: 'profile.html').name).to be_nil
  end

  it "parses 'pof_key'" do
    expect(test_parser(file: 'profile.html').pof_key).to eq("95213413")
  end

  it "parses 'username'" do
    expect(test_parser(file: 'profile.html').username).to eq("misshubble2")
  end
end
