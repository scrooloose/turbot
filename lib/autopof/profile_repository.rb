class ProfileRepository
  def self.instance
    @instance ||= new
  end

  def save(profile: profile, page_content: page_content)
    pof_user = profile.username
    if record = DB[:profiles][pof_key: profile.pof_key]
      Log.debug "ProfileFetcher#cache_profile - updating: #{pof_user}"
      record.update(page_content: page_content)
    else
      Log.debug "ProfileFetcher#cache_profile - creating new: #{pof_user}"
      DB[:profiles].insert(page_content: page_content, pof_key: profile.pof_key, username: pof_user)
    end
  end

  def find(params)
    DB[:profiles][params]
  end

  def messagable_profiles
    records = DB[:profiles].where("NOT EXISTS (SELECT * FROM messages WHERE messages.profile_id = profiles.id)")
    records.map do |record|
      ProfileParser.new(page_content: record[:page_content]).profile rescue nil
    end.compact
  end

private
  def initialize
  end
end
