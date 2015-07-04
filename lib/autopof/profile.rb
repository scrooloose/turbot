class Profile
  attr_reader :pof_key, :username, :bio, :interests, :name, :likes, :dislikes

  def initialize(pof_key: nil, username: nil, bio: nil, interests: nil,
                 name: nil, likes: nil, dislikes: nil)
    @pof_key = pof_key
    @username = username
    @bio = bio
    @interests = interests
    @name = name
    @likes = likes
    @dislikes = dislikes
  end
end
