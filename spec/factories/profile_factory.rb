module ProfileFactory
  def self.build(params = {})
    _build(default_params.merge(params))
  end

  def self.create(params = {})
    p = build(params)
    p.save
    p
  end

  def self.from_test_fixture(fname)
    content = File.read(test_file_path(fname))
    parser = ProfilePageParser.new(page_content: content)
    Profile.create!(
      username: parser.username,
      pof_key: parser.pof_key,
      page_content: content
    )
  end

  def self.build_messagable(params = {})
    _build(default_params.merge(interests: ['biking']).merge(params))
  end

  def self.create_messagable(params = {})
    p = build_messagable(params)
    p.save
    p
  end

private
  def self.default_params
    { bio: "The bio", interests: [], pof_key: SecureRandom.hex, username: SecureRandom.hex }
  end

  def self._build(params)
    p = params.clone
    p.delete(:interests)
    p.delete(:bio)
    Profile.new(p.merge(page_content: page_content_for(params)))
  end

  def self.page_content_for(params)
    page = Nokogiri.HTML(test_file_content('base.html'))

    params[:interests].each do |interest|
      new_interest = %Q(<li class="text-lg"><a href="/interests/#{interest}">#{interest}</a></li>)
      page.at_css('#profile-interests-wrapper .nav') << new_interest
    end

    page.at_css('.profile-description').content = params[:bio]

    page_content = page.to_html
    page_content.gsub!(/POF_KEY_HERE/, params[:pof_key])
    page_content.gsub!(/POF_USERNAME_HERE/, params[:username])
  end
end
