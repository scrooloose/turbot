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

  has_many :profile_interests
  has_many :interests, through: :profile_interests

  has_one :user

  #FIXME: this can now be rewritten MUCH more efficiently using ProfileInterests
  def messagable(number:, interests:)
    rv = []
    self.class.unmessaged(id).excluding(self.id).order('RAND()').find_in_batches(batch_size: 500) do |batch|
      batch.each do |profile|
        rv << profile if (profile.interests.to_a & interests.to_a).any?
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

  def has_interest_matching?(regexs)
    regexs.detect do |regex|
      if pof_interests.detect {|i| i =~ regex}
        return true
      end
    end
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

  def parse_page_contents!
    profile_page_parser = ProfilePageParser.new(page_content: page_content)
    bio_parser = BioParser.new(bio: profile_page_parser.bio)

    self.bio = profile_page_parser.bio
    self.name = profile_page_parser.name
    self.interests = (interests_for_pof_interests(profile_page_parser.interests) + bio_parser.matching_interests).uniq
    self
  end

private

  def interests_for_pof_interests(pof_interests)
    pof_interests.map {|i| Interest.matching(i)}.compact.flatten.uniq
  end
end
