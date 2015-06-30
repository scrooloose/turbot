require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe MessageBuilder do
  describe "#likes" do
    def test_likes(bio: nil, likes: nil)
      expect(BioParser.new(bio).likes).to eq(likes)
    end

    it "parses simple comma lists" do
      test_likes(bio: 'I like dogs, cats and ice cream.',
                 likes: ['dogs', 'cats', 'ice cream'])

      test_likes(bio: 'I love to eat cake, pick cherries, walk dogs.',
                 likes: ['eat cake', 'pick cherries', 'walk dogs'])
    end

    it "parses comma lists with an 'and' at the end." do
      test_likes(bio: 'I like dogs, cats and ice cream.',
                 likes: ['dogs', 'cats', 'ice cream'])

      test_likes(bio: 'I love to eat cake, pick cherries and walk dogs.',
                 likes: ['eat cake', 'pick cherries', 'walk dogs'])
    end

    it "handles various list endings" do
      expected = ['dogs', 'cats', 'ice cream']
      test_likes(bio: 'I like dogs, cats and ice cream', likes: expected)
      test_likes(bio: "I like dogs, cats and ice cream!!", likes: expected)
      test_likes(bio: "I like dogs, cats and ice cream\n", likes: expected)
      test_likes(bio: "I like dogs, cats and ice cream?", likes: expected)
    end
  end

end

      #bio = <<-EOS
      #  I enjoy spontaneous trips and adventures which would be more fun with an
      #  accomplice. I enjoy climbing, music,gigs, festivals and being outside and
      #  meeting new people. I enjoy water sports and I am up for trying new things.
      #  I have travelled to Spain, France, Thailand and Malaysia and I recently
      #  spent 6 months in Australia and would love to find someone to share new
      #  experiences and future adventures with.
      #EOS

      #expect(BioParser.new(bio).likes).to eq([
      #  'spontaneous trips and adventures which would be more fun with an accomplice',
      #  'climbing',
      #  'music',
      #  'gigs',
      #  'festivals',
      #  'being outside and meeting new people',
      #  'water sports',
      #  'I am up for trying new things'
      #])

