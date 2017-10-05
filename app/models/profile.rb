class Profile < ApplicationRecord
  class NotEnoughMessagableProfiles < StandardError; end

  scope :unmessaged, -> (id) { where("NOT EXISTS (SELECT *
                                                  FROM messages
                                                  WHERE messages.sender_profile_id = #{id} AND
                                                        messages.recipient_profile_id = profiles.id)") }

  scope :available, -> { where("profiles.unavailable IS NULL OR profiles.unavailable = 0") }
  scope :excluding, -> (id) { where.not(id: id) }

  has_many :sent_messages, class_name: "Message", foreign_key: "sender_profile_id"
  has_many :received_messages, class_name: "Message", foreign_key: "recipient_profile_id"

  has_one :user

  def messagable(number)
    rv = []
    self.class.unmessaged(id).excluding(self.id).order('RAND()').find_in_batches(batch_size: 500) do |batch|
      batch.each do |profile|
        rv << profile if profile.matches_any_topic?
        return rv if rv.size == number
      end
    end

    raise(NotEnoughMessagableProfiles, "Couldn't find #{number} messagable profiles")
  end

  def responses
    received_messages.
    where("EXISTS (SELECT *
                   FROM messages as sent_msgs
                   WHERE sent_msgs.sender_profile_id = #{self.id} AND
                         sent_msgs.recipient_profile_id = messages.sender_profile_id AND
                         sent_msgs.sent_at < messages.sent_at)")
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

  def sent_message(recipient: nil, content: nil, sent_at: Time.now)
    Message.create!(recipient_profile_id: recipient.id, content: content, sender_profile_id: self.id, sent_at: sent_at)
  end

  def received_message(sender: nil, content: nil, sent_at: nil)
    received_messages.create(recipient_profile_id: self.id, content: content, sender_profile_id: sender.id, sent_at: sent_at)
  end

  def received?(username: nil, sent_at: nil)
    received_messages.joins(:sender_profile).where("profiles.username = ?", username).where("messages.sent_at" => sent_at).any?
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
    interests.map {|i| Topic.matching(i)}.compact.flatten.to_set
  end
end
