class Profile < Sequel::Model(:profiles)
  class NotEnoughMessagableProfiles < StandardError; end

  def_dataset_method(:unmessaged) do
    where("NOT EXISTS (SELECT * FROM messages WHERE messages.recipient_profile_id = profiles.id)")
  end

  def_dataset_method(:messaged) do
    where("EXISTS (SELECT * FROM messages WHERE messages.recipient_profile_id = profiles.id)")
  end

  def_dataset_method(:excluding_me) do
    where("profiles.id != #{Config['user_profile_id']}")
  end

  def self.messagable(number)
    rv = []
    unmessaged.excluding_me.order(Sequel.lit('RAND()')).each_page(100) do |page|
      page.each do |profile|
        rv << profile if profile.matches_any_topic?
        return rv if rv.size == number
      end
    end

    raise(NotEnoughMessagableProfiles, "Couldn't find #{number} messagable profiles")
  end

  def self.me
    @me ||= find(id: Config['user_profile_id'])
  end

  #TODO: these should all be readonly, but are read/write for easier testing
  attr_writer :bio, :name, :topics

  DerivedFields=[:bio, :name, :topics, :interests]

  DerivedFields.each do |property|
    define_method(property) do
      parse_page_contents
      instance_variable_get("@#{property}")
    end
  end

  def has_interest_matching?(regexs)
    regexs.detect do |regex|
      if interests.detect {|i| i =~ regex}
        return true
      end
    end
  end

  def matches_any_topic?
    topics_for_interests(interests).any?
  end

  def refresh
    super
    clear_derived_fields
    parse_page_contents
    self
  end

  def make_unavailable!
    self.unavailable = true
    save(raise_on_failure: true)
  end

  def inspect
    v = values.clone
    v[:page_content] = v[:page_content].first(20) + " ..."
    "#<#{model.name} @values=#{v}>"
  end

private

  def clear_derived_fields
    DerivedFields.each do |f|
      remove_instance_variable("@#{f}".to_sym)
    end
    remove_instance_variable("@parse_page_contents_done".to_sym)
  end

  def parse_page_contents
    return if @parse_page_contents_done
    @parse_page_contents_done = true

    profile_page_parser = ProfilePageParser.new(page_content: page_content)
    bio_parser = BioParser.new(bio: profile_page_parser.bio, topics: TopicRegistryInstance.topics)

    @bio ||= profile_page_parser.bio
    @name ||= profile_page_parser.name
    @interests ||= profile_page_parser.interests
    @topics ||= topics_for_interests(@interests) + bio_parser.topics
  end

  def topics_for_interests(interests)
    interests.map {|i| TopicRegistryInstance.matching(i)}.compact.flatten.to_set
  end
end
