class Profile < Sequel::Model(:profiles)

  def self.messagable
    #FIXME: we are currently grabbing 100 profiles... it is possible that none
    #of these will be messagable so we should have a smarter way to fetch
    #profiles... possibly fetch, parse and check for messagability here?
    #
    #FIXME: this subquery is inefficent - change to a join
    Profile.where("NOT EXISTS (SELECT * FROM messages WHERE messages.profile_id = profiles.id)").limit(100).order('RAND()')
  end


  #TODO: these should all be readonly, but are read/write for easier testing
  attr_writer :bio, :name, :interests

  [:bio, :name, :interests].each do |property|
    define_method(property) do
      parse_page_contents
      instance_variable_get("@#{property}")
    end
  end

  def has_interest_matching?(*regexs)
    regexs.detect do |regex|
      if interests.detect {|i| i =~ regex}
        return true
      end
    end
  end

  #FIXME: this is a hack that is used in the profile factory...
  def skip_parsing_page_content
    @parse_page_contents_done = true
  end

private

  def parse_page_contents
    return if @parse_page_contents_done
    @parse_page_contents_done = true

    profile_page_parser = ProfilePageParser.new(page_content: page_content)
    bio_parser = BioParser.new(bio: profile_page_parser.bio, interest_matchers: Topics::Base.all_interest_matchers)

    @bio ||= profile_page_parser.bio
    @name ||= profile_page_parser.name
    @interests ||= profile_page_parser.interests + bio_parser.interests
  end
end
