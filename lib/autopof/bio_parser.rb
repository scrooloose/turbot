class BioParser
  attr_reader :bio

  def initialize(bio)
    @bio = bio
  end

  def likes
    list = []
    bio.scan(/I (?:like|love to|love|enjoy).*?(?:[.!]|:\)|$|\Z)/mi) do |like_list|
      next_list = like_list.sub(/I (like|love to|love|enjoy)/mi, '').split(',')
      if next_list[-1].match(/and/i)
        next_list[-1] = next_list[-1].split(/and/i)
      end

      list += next_list.flatten
    end

    cleanup_list(list)
  end

  def dislikes
    []
  end

private
  def cleanup_list(list)
    list.map do |item|
      item.strip.sub(/[[:punct:]]*$/, '')
    end
  end


  #filter out joining commas:
  #I enjoy going for walks with my springer spaniel on dartmoor, and would love someone to keep me company
  #We only want the first conjunct


  #I enjoy spontaneous trips and adventures which would be more fun with an
  #accomplice. I enjoy climbing, music,gigs, festivals and being outside and
  #meeting new people. I enjoy water sports and I am up for trying new things.
  #I have travelled to Spain, France, Thailand and Malaysia and I recently
  #spent 6 months in Australia and would love to find someone to share new
  #experiences and future adventures with.

  #I enjoy discovering new places, going for walks, gym, swimming, although I
  #do like to spoil myself at the spa every now and again! I like to cook and
  #entertain friends and family on a weekend, with the odd glass of wine (or
  #two!) On a Saturday night, you could find me on the dance floor with
  #friends, or equally I could be curled up on the sofa with a takeaway and a
  #good film

  #Originally from Philippines. I love to travel.. I love to learn about new
  #places, people and culture. I am very active in my catholic-charismatic
  #community. I like to be in harmony with the world around me. Wow, that
  #sounds new age, but I’m very down to earth I like to read a lot and keep up
  #with many things– politics, social issues, culture, travels, people.
  #I especially value humor, being able to laugh at yourself, being able to
  #communicate, culture in general, social issues, staying healthy, and the
  #freedom to think out of the box. I also like hiking, mountain climbing, I
  #like the beach, hearing people’s stories, and simply talking with people.

  #I like to think I'm pretty funny, loyal, sarcastic, brave, loving &
  #affectionate, tactile, sassy, creative, hardworking, independent, cheeky,
  #kind, open, generous, witty, playful & know what's important in life. 

  #I'm 27 years old; I love the countryside, animals, doing anything in the
  #outdoors! I am close to my family and enjoy spending time with them, so
  #would like to meet someone that has similar family values. I'm easy going,
  #open minded, friendly, ambitious,love travelling.
  #
  #Well a bit about me. I'm really into films, anything from a chick flick to a
  #shoot um up or really gory horror, the only thing I'm not really into is
  #sci-fi. Music wise, love a bit of The Beatles, Johnny Cash, Fleetwood Mac,
  #Black Keys, Kasabian, Oasis, Jake Bugg. Really enjoy watching live bands
  #(get lost in watching someone play the guitar) so any guitar players are
  #half way there! Have never been to a festival so that's on my to do list for
  #this year...maybe I'll find a festival buddy on here!
  #
  #I like watching most sport, but especially football (yes I know the offside rule!) and tennis
  #
  #
  #Likes:
  #Movies (esp marvel)
  #Cooking
  #Holidays
  #2p machines
  #Lazy Sundays
  #Rugby (wales and ospreys)
  #
  #
  #I enjoy going to the cinema, to theme parks & the zoo, ice skating,
  #socialising, checking out vintage fairs, being creative & baking but also
  #like a cosy day/night in watching movies or reading! :) I'm not a big
  #drinker but do enjoy the odd night out. I've got into photography over the
  #last few years & my camera is like another limb! 
  #
  #
  #I am witty, have a good sense of humour, down to earth and hard working. In
  #terms of hobbies, I enjoy sport and until recently played in a ladies darts
  #team. I like films, socialising with friends (who doesn't) - including both
  #nights in and out. I love music too - varied tastes from rock to cheesy pop
  #haha and attending concerts.
  #
  #I'm fun, genuine, smart, kind, relaxed, don't take myself too seriously, super organised, loyal, house proud, romantic, active, independent, chatty and love the simple pleasures in life. 
  #
  #I love early summer mornings and warm evenings. Lazy Sunday's. Hugs. Apple crumble and custard. Game of Thrones. Earl grey tea. Random encounters/nights out. Animals. Time with family. The beach. Fair-weather camping. Gin. Cosy nights in. Custard creams. Live music/theatre. Hiking. More hugs. The countryside. Gentlemanly traits. Dancing.

end
