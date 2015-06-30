class ProfileParser
  attr_reader :page_content

  def initialize(page_content: nil)
    @page_content = page_content
  end

  def profile
    Profile.new(
      interests: interests,
      bio: bio,
      name: name
    )
  end

private

  def interests
    page.css('#profile-interests-wrapper a')
        .map(&:inner_html)
        .map(&:downcase)
  end

  def bio
    page.css('.profile-description').inner_text.strip
  end

  def name
    name = page.css('.AboutMe').inner_text.gsub(/About\s*/, '').strip
    (name == 'Me') ? nil : name
  end

  def likes
  end

  def dislikes
  end

  def page
    @page ||= Nokogiri.HTML(page_content)
  end
end
