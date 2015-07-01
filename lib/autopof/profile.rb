class Profile
  attr_reader :bio, :interests, :name, :likes, :dislikes

  def initialize(bio: nil, interests: nil, name: nil, likes: nil, dislikes: nil)
    @bio = bio
    @interests = interests
    @name = name
    @likes = likes
    @dislikes = dislikes
  end
end
