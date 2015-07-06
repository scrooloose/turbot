class ProfileFactory
  def self.build(params = {})
    defaults = { bio: "The bio", interests: [] }
    Profile.new(defaults.merge(params))
  end

  def self.build_messagable(params = {})
    defaults = { bio: "The bio", interests: ['biking'] }
    Profile.new(defaults.merge(params))
  end
end
