require "rails_helper"

RSpec.describe BioParser do
  describe "#interests" do
    def test_likes(bio: nil, interests: nil, all_interests: interests)
      bp = BioParser.new(bio: bio, interests: all_interests)
      expect(bp.matching_interests).to eq(interests)
    end

    let :biking_interest do
      biking_interest = build(:interest, name: "biking", matchers: "biking\ncycling")
    end

    let :control_interest do
      control_interest = build(:interest, name: "xxx", matchers: 'yyy')
    end

    it "recognizes interest matchers in 'like sentences'" do
      args = { interests: [biking_interest], all_interests: [biking_interest, control_interest]  }

      test_likes(args.merge(bio: "I like biking and football"))
      test_likes(args.merge(bio: "Love cycling and try to get away for weekends as often as possible."))
      test_likes(args.merge(bio: "My passion in life is my biking"))
      test_likes(args.merge(bio: "I'm 27; I love biking, animals, doing anything in the barn."))
      test_likes(args.merge(bio: "I'm really into biking, anything from a chick flick to a"))
      test_likes(args.merge(bio: "Really enjoy watching live biking and making pancakes."))
      test_likes(args.merge(bio: "In terms of hobbies, I enjoy biking and until recently played in a ladies darts team."))
      test_likes(args.merge(bio: "This girl loves positivity, biking, cheekiness, kisses, theatre and live performance. "))
      test_likes(args.merge(bio: "In my spare time I like to do the usual watch films and biking"))
      test_likes(args.merge(bio: "I am into biking"))
      test_likes(args.merge(bio: "I'm into biking"))
    end

    pending "doesn't recognize anti-interests" do
      bp = BioParser.new(bio: "I hate biking and football", interests: [biking_interest])
      expect(bp.matching_interests).to be_empty

      bp = BioParser.new(bio: "I don't really like biking and football", interests: [biking_interest])
      expect(bp.matching_interests).to be_empty
    end

    it "only checks 5 words into a sentence" do
      bp = BioParser.new(bio: "one two three four five I like to do the usual watch films and biking", interests: [biking_interest])
      expect(bp.matching_interests).to be_empty
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
      bp = BioParser.new(bio: bio, interests: [biking_interest])

      if should_match
        expect(bp.matching_interests).to include(biking_interest)
      else
        expect(bp.matching_interests).not_to include(biking_interest)
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
      horse_interest = build(:interest, name: "horse interest", matchers: 'horses')
      bp = BioParser.new(bio: bio, interests: [biking_interest, horse_interest])

      expect(bp.matching_interests).to match_array([biking_interest, horse_interest])
    end

    it "accepts up to 2 new lines after the list intro" do
      test_like_list(list_intro: "I like:\n\n\n")
    end

  end
end
