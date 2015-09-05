class Profile < Sequel::Model(:profiles)
  class NotEnoughMessagableProfiles < StandardError; end

  def self.messagable(number)
    rv = []
    Profile.where("NOT EXISTS (SELECT * FROM messages WHERE messages.profile_id = profiles.id)").order('RAND()').each_page(100) do |page|
      page.each do |profile|
        rv << profile if profile.matches_any_topic?
        return rv if rv.size == number
      end
    end

    raise(NotEnoughMessagableProfiles, "Couldn't find #{number} messagable profiles")
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

  def matches_any_topic?
    MessageBuilder.new(self).message && true
  rescue MessageBuilder::NoMatchingTopicError
    nil
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
