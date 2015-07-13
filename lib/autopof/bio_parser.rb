class BioParser
  attr_reader :bio, :interest_matchers

  def initialize(bio: [], interest_matchers: [])
    @bio = bio
    @interest_matchers = interest_matchers
  end

  def interests
    return @interests if @interests

    @interests = []

    like_sentences.each do |sentence|
      interest_matchers.each do |regex|
        if match_data = sentence.match(regex)
          @interests.push(match_data[0])
        end
      end
    end

    @interests
  end

private

  def like_sentences
    @sentences ||= bio.split(/[\n.]/).select do |s|
      s.match(/I (like|love|enjoy|am happiest|am happy)/im)
    end
  end
end
