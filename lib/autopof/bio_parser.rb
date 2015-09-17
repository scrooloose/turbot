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

    like_lists.each do |like_list|
      interest_matchers.each do |regex|
        if match_data = like_list.match(regex)
          @interests.push(match_data[0])
        end
      end
    end

    @interests
  end

  def like_lists
    matches = bio.scan(/^\s*[^\n]{0,40}(?:likes?|loves?|enjoy|am happiest|am happy|hobbies|passion|really into|spare time)[^\n]{0,30}:(.*?)(?:\n\n|\Z)/mi)
    if matches.any?
      matches.flatten
    else
      []
    end
  end

private

  def like_sentences
    @sentences ||= bio.split(/[\n.!]/).select do |s|
      Log.debug "like_sentences: processing sentence: #{s}"
      #match up to 4 words, then one of the key "like" indication phrases
      s.match(/^(\S*?\s){0,4}(like|loves?|enjoy|am happiest|am happy|hobbies|passion|really into|spare time)/im)
    end
  end
end
