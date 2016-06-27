class Profile < ActiveRecord::Base
  class NotEnoughMessagableProfiles < StandardError; end

  scope :unmessaged,  -> { where("NOT EXISTS (SELECT * FROM messages WHERE messages.recipient_profile_id = profiles.id)") }
  scope :messaged, -> { where("EXISTS (SELECT * FROM messages WHERE messages.recipient_profile_id = profiles.id)") }
  scope :excluding_me, -> { where("profiles.id != #{Config['user_profile_id']}") }
  scope :available, -> { where("profiles.unavailable IS NULL OR profiles.unavailable = 0") }

  has_many :messages

  def self.messagable(number)
    rv = []
    unmessaged.excluding_me.order('RAND()').find_in_batches(batch_size: 500) do |batch|
      batch.each do |profile|
        rv << profile if profile.matches_any_topic?
        return rv if rv.size == number
      end
    end

    raise(NotEnoughMessagableProfiles, "Couldn't find #{number} messagable profiles")
  end

  def self.me
    @me ||= find(Config['user_profile_id'])
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

  def reload
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
    a = attributes.clone
    a["page_content"] = a["page_content"].first(20) + " ..."
    "#<#{self.class.name} @attributes=#{a}>"
  end

private

  def clear_derived_fields
    DerivedFields.each do |f|
      vname = "@#{f}".to_sym
      remove_instance_variable(vname) if instance_variable_defined?(vname)
    end
    @parse_page_contents_done = false
  end

  def parse_page_contents
    return if @parse_page_contents_done
    @parse_page_contents_done = true

    profile_page_parser = ProfilePageParser.new(page_content: page_content)
    bio_parser = BioParser.new(bio: profile_page_parser.bio)

    @bio ||= profile_page_parser.bio
    @name ||= profile_page_parser.name
    @interests ||= profile_page_parser.interests
    @topics ||= topics_for_interests(@interests) + bio_parser.topics
  end

  def topics_for_interests(interests)
    interests.map {|i| TopicRegistryInstance.matching(i)}.compact.flatten.to_set
  end
end
