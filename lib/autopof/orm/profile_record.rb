class ProfileRecord < Sequel::Model(:profiles)
  def self.messagable_profiles
    records = where("NOT EXISTS (SELECT * FROM messages WHERE messages.profile_id = profiles.id)")
    records.map do |record|
      ProfileParser.new(page_content: record.page_content).profile
    end
  end
end
