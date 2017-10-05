require "rails_helper"

RSpec.describe PofMessageInfoExtractor do
  let(:extractor) {
    described_class.new(
      Nokogiri::XML::Document.parse(test_file_content("received_message_files/normal_message.html")),
      nil
    )
  }

  describe "#username" do
    it "extracts the username" do
      expect(extractor.username).to eq("handsome_guy")
    end
  end

  describe "#sent_at" do
    it "extracts the date" do
      expect(extractor.sent_at).to eq("2017-10-04 20:04:10")
    end
  end
end
