require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe MessageBuilder do
  describe "#topics" do
    def test_likes(bio: nil, topics: nil, all_topics: topics)
      bp = BioParser.new(bio: bio, topics: all_topics)
      expect(bp.matching_topics).to eq(topics)
    end

    let :biking_topic do
      biking_topic = TopicFactory.build(name: "biking", interest_matchers: ['biking', 'cycling'], message: "foo")
    end

    let :control_topic do
      control_topic = TopicFactory.build(name: "xxx", interest_matchers: ['yyy'], message: "zzz")
    end

    it "recognizes interest matchers in 'like sentences'" do
      args = { topics: [biking_topic], all_topics: [biking_topic, control_topic]  }

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
      bp = BioParser.new(bio: "I hate biking and football", topics: [biking_topic])
      expect(bp.matching_topics).to be_empty

      bp = BioParser.new(bio: "I don't really like biking and football", topics: [biking_topic])
      expect(bp.matching_topics).to be_empty
    end

    it "only checks 5 words into a sentence" do
      bp = BioParser.new(bio: "one two three four five I like to do the usual watch films and biking", topics: [biking_topic])
      expect(bp.matching_topics).to be_empty
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
      bp = BioParser.new(bio: bio, topics: [biking_topic])

      if should_match
        expect(bp.matching_topics).to include(biking_topic)
      else
        expect(bp.matching_topics).not_to include(biking_topic)
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
      horse_topic = TopicFactory.build(name: "horse topic", interest_matchers: ['horses'], message: "foo")
      bp = BioParser.new(bio: bio, topics: [biking_topic, horse_topic])

      expect(bp.matching_topics).to match_array([biking_topic, horse_topic])
    end

    it "accepts up to 2 new lines after the list intro" do
      test_like_list(list_intro: "I like:\n\n\n")
    end

  end
end
