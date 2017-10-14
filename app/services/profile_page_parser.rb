class ProfilePageParser
  attr_reader :page_content

  def initialize(page_content:)
    @page_content = page_content
  end

  def interests
    Rails.logger.debug "#{self.class.name}: parsing interests"
    page.css('#profile-interests-wrapper a')
        .map(&:inner_html)
        .map(&:downcase)
  end

  def bio
    Rails.logger.debug "#{self.class.name}: parsing bio"
    #preserve newlines - since <br>s are stripped out
    page.css('.profile-description br').each {|br| br.replace("\n")}
    page.css('.profile-description').inner_text.strip
  end

  def name
    Rails.logger.debug "#{self.class.name}: parsing name"
    name = page.css('.AboutMe').inner_text.gsub(/About\s*/, '').strip
    (name == 'Me') ? nil : name
  end

  def pof_key
    Rails.logger.debug "#{self.class.name}: parsing pof_key"
    page.css('input[name="p_id"]').first.attr('value')
  end

  def username
    Rails.logger.debug "#{self.class.name}: parsing username"
    page.css('input[name="sendto"]').first.attr('value')
  end

private

  def page
    @page ||= Nokogiri.HTML(page_content)
  end
end
