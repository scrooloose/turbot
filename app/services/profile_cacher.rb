class ProfileCacher
  attr_reader :profile_page_body

  def self.cache(profile_page_body)
    new(profile_page_body).cache
  end

  def initialize(profile_page_body)
    @profile_page_body = profile_page_body
  end

  def cache
    parser = ProfilePageParser.new(page_content: profile_page_body)
    profile = if Profile.exists?(pof_key: parser.pof_key)
                Profile.find_by!(pof_key: parser.pof_key)
              else
                Profile.new(username: parser.username, pof_key: parser.pof_key)
              end
    profile.page_content = profile_page_body
    profile.parse_page_contents!
    profile.save!
    profile
  end
end
