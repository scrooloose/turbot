class ProfileRepository
  def self.instance
    @instance ||= new
  end

  def save(profile: nil, page_content: nil)
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
    #FIXME: we are currently grabbing 100 profiles... it is possible that none
    #of these will be messagable so we should have a smarter way to fetch
    #profiles... possibly fetch, parse and check for messagability here?
    #
    #FIXME: this subquery is inefficent - change to a join
    records = DB[:profiles].where("NOT EXISTS (SELECT * FROM messages WHERE messages.profile_id = profiles.id)").limit(100).order('RAND()')
    records.map do |record|
      ProfileParser.new(page_content: record[:page_content]).profile rescue nil
    end.compact
  end

private
  def initialize
  end
end
