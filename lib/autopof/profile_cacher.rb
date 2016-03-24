class ProfileCacher
  attr_reader :profile_page_body

  def initialize(profile_page_body)
    @profile_page_body = profile_page_body
  end

  def cache
    parser = ProfilePageParser.new(page_content: profile_page_body)
    profile = if Profile.where(pof_key: parser.pof_key).any?
                Profile.find(pof_key: parser.pof_key)
              else
                Profile.new(username: parser.username, pof_key: parser.pof_key)
              end
    profile.page_content = profile_page_body
    profile.save
    profile
  end
end
