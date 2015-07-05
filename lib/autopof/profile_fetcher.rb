class ProfileFetcher
  attr_reader :num_pages

  def initialize(num_pages: 1)
    @num_pages = num_pages
  end

  def run
    cache_search_pages(to_search_page)
  end

private
  def agent
    @agent ||= Mechanize.new
  end

  def to_search_page
    post_login_page = login
    post_login_page.link_with(text: 'search').click
  end

  def login
    Log.debug "ProfileFetcher#login"
    login_page = agent.get('http://www.pof.com')
    login_form = login_page.form('frmLogin')
    login_form.username = Config['pof_username']
    login_form.password = Config['pof_password']
    login_form.submit
  end

  def cache_search_pages(page_one)
    current_page = page_one

    1.upto(num_pages) do |p_num|
      cache_profiles(current_page)

      next_page_num = p_num + 1
      current_page = current_page.link_with(id: "basicsearch_pager_#{next_page_num}").click
    end
  end

  def cache_profiles(page)
    Log.debug "ProfileFetcher#cache_profiles - caching for: #{page.uri.to_s}"
    profile_links = page.links_with(href: /^viewprofile.*/, class: 'link')
    profile_links.each do |link|
      cache_profile(link.click)
      sleep(rand(5))
    end
  end

  def cache_profile(page)
    Log.debug "ProfileFetcher#cache_profile - caching: #{page.uri.to_s}"

    profile = parse_profile_for(page)
    return unless profile #if the page is screwed somehow

    pof_key = profile.pof_key

    if record = ProfileRecord[pof_key: pof_key]
      Log.debug "ProfileFetcher#cache_profile - updating: #{pof_key}"
      record.update(page_content: page.body)
    else
      Log.debug "ProfileFetcher#cache_profile - creating new: #{pof_key}"
      ProfileRecord.create(page_content: page.body, pof_key: pof_key, username: profile.username)
    end
  end

  def parse_profile_for(page)
    ProfileParser.new(page_content: page.body).profile
  rescue
    nil
  end
end
