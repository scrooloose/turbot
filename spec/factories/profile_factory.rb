class ProfileFactory
  def self.build(params = {})
    defaults = { bio: "The bio", interests: [] }
    Profile.new(defaults.merge(params))
  end
end
