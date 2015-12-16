require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe MessageBuilder do
  describe "#topics" do
    def test_likes(bio: nil, interests: nil, interest_matchers: [/bike|biking|cycle/])
      bp = BioParser.new(bio: bio, interest_matchers: interest_matchers)
      expect(bp.interests).to eq(interests)
    end

    it "recognizes interest matchers in 'like sentences'" do
      test_likes(bio: "I like biking and football", interests: ['biking'])
      test_likes(bio: "Love to cycle and try to get away for weekends as often as possible.", interests: ['cycle'])
      test_likes(bio: "My passion in life is my bike", interests: ['bike'])
      test_likes(bio: "I'm 27; I love biking, animals, doing anything in the barn.", interests: ['biking'])
      test_likes(bio: "I'm really into biking, anything from a chick flick to a", interests: ['biking'])
      test_likes(bio: "Really enjoy watching live biking and making pancakes.", interests: ['biking'])
      test_likes(bio: "In terms of hobbies, I enjoy biking and until recently played in a ladies darts team.", interests: ['biking'])
      test_likes(bio: "This girl loves positivity, biking, cheekiness, kisses, theatre and live performance. ", interests: ['biking'])
      test_likes(bio: "In my spare time I like to do the usual watch films and biking", interests: ['biking'])
    end

    it "doesn't recognize anti-interests" do
      bp = BioParser.new(bio: "I hate biking and football", interest_matchers: [/biking/])
      expect(bp.interests).to be_empty

      bp = BioParser.new(bio: "I don't really like biking and football", interest_matchers: [/biking/])
      expect(bp.interests).to be_empty
    end

    it "only checks 5 words into a sentence" do
      bp = BioParser.new(bio: "one two three four five I like to do the usual watch films and biking", interest_matchers: [/biking/])
      expect(bp.interests).to be_empty
    end

    def test_like_list(list_intro: 'I like:', list_prefix: '', should_match: true)
      bio = <<-EOS
        Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
        tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At

        #{list_intro}
        #{list_prefix}foo
        #{list_prefix}biking
        #{list_prefix}bar

        Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
        no sea takimata sanctus est Lorem ipsum dolor sit amet.
      EOS
      bp = BioParser.new(bio: bio, interest_matchers: [/biking/])

      if should_match
        expect(bp.interests).to include('biking')
      else
        expect(bp.interests).not_to include('biking')
      end
    end

    it "recognizes interest matches in 'list lists'" do
      test_like_list(list_intro: 'I like:')
      test_like_list(list_intro: 'Likes:')
      test_like_list(list_intro: 'Things I like:')
      test_like_list(list_intro: 'Here is a list of more interesting "likes" slash "facts":')
    end

    it "can use either a colon or dash for the list delimiter/indicator" do
      test_like_list(list_intro: 'I like:')
      test_like_list(list_intro: 'I like :')
      test_like_list(list_intro: 'I like - ')
      test_like_list(list_intro: 'I like-')
      test_like_list(list_intro: 'I like -')
    end

    it "doesn't match lists of dislikes" do
      test_like_list(list_intro: 'I dislike:', should_match: false)
    end

    it "recognizes bulletted 'like lists'" do
      test_like_list(list_prefix: "-")
      test_like_list(list_prefix: "*")
      test_like_list(list_prefix: ">")
    end

    it "recognizes 'like lists' which dont start in their own paragraph" do
      test_like_list(list_intro: 'Here is an irrelevant sentence. And one more. And just one more. I fucking love:')
    end

    it "recognizes interest matches in multiple 'list lists'" do
      bio = <<-EOS
        Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
        tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At

        I like:
        foo
        biking
        bar

        Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
        no sea takimata sanctus est Lorem ipsum dolor sit amet.

        I like:
        baz
        horses
        blarg
      EOS
      bp = BioParser.new(bio: bio, interest_matchers: [/biking/, /horses/])

      expect(bp.interests).to match_array(['biking', 'horses'])
    end

  end
end
