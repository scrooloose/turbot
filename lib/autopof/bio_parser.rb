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
    @sentences ||= bio.split(/[\n.!]/).select do |s|
      Log.info "like_sentences: processing sentence: #{s}"
      #match up to 4 words, then one of the key "like" indication phrases
      s.match(/(.*?\s){0,4}(like|loves?|enjoy|am happiest|am happy|hobbies|passion|really into|spare time)/im)
    end
  end
end
