class Interest < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true
  validates :matchers, presence: true

  has_many :template_messages

  def matches?(bio_fragment)
    interest_matchers.any? do |regex|
      bio_fragment.match(regex)
    end
  end

  def self.matching(bio_fragment)
    all.select {|t| t.matches?(bio_fragment)}
  end

private

  def interest_matchers
    @interest_matchers ||= matchers.split(/[\r\n]+/).map {|s| Regexp.new(s, Regexp::IGNORECASE)}
  end
end
