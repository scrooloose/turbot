class ProfileFactory
  def self.build(params = {})
    defaults = { bio: "The bio", interests: [] }
    p = Profile.new(defaults.merge(params))
    p.skip_parsing_page_content
    p
  end

  def self.build_messagable(params = {})
    defaults = { bio: "The bio", interests: ['biking'] }
    p = Profile.new(defaults.merge(params))
    p.skip_parsing_page_content
    p
  end
end
