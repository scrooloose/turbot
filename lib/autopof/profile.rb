class Profile
  attr_reader :bio, :interests, :name, :likes, :dislikes

  def initialize(bio: nil, interests: nil, name: nil)
    @bio = bio
    @interests = interests
    @name = name
  end
end
