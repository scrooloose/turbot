class Topic < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :matchers, presence: true
  validates :message, presence: true

  belongs_to :user

  def matches?(bio_fragment)
    interest_matchers.any? do |regex|
      bio_fragment.match(regex)
    end
  end

  def self.matching(bio_fragment)
    all.select {|t| t.matches?(bio_fragment)}
  end

  #NOTE: temp function to read topics in from the old config.yml setup
  def self.add_from_file(fname)
    yml = YAML.load_file(fname)
    yml['topics'].each do |topic_hash|
      Topic.create!(name: topic_hash['name'],
                    matchers: topic_hash['interest_matchers'].join("\r\n"),
                    message: topic_hash['message'])
    end
  end

private

  def interest_matchers
    @interest_matchers ||= matchers.split(/[\r\n]+/).map {|s| Regexp.new(s, Regexp::IGNORECASE)}
  end
end
