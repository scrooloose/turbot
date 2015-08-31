module PofWebdriver::ProfileFetching
  def cache_profiles_from_search_page(num_pages: 1)
    cache_search_pages(to_search_page, num_pages: num_pages)
  end

private
  def to_search_page
    post_login_page = login
    post_login_page.link_with(text: 'search').click
  end

  def cache_search_pages(page_one, num_pages: num_pages)
    current_page = page_one

    1.upto(num_pages) do |p_num|
      cache_profiles(current_page)

      next_page_num = p_num + 1
      current_page = current_page.link_with(id: "basicsearch_pager_#{next_page_num}").click
    end
  end

  def cache_profiles(page)
    Log.debug "#{self.class.name} - caching for: #{page.uri.to_s}"
    profile_links = page.links_with(href: /^viewprofile.*/, class: 'link')
    profile_links.each do |link|
      cache_profile(link.click)
      sleep(rand(5))
    end
  end

  def cache_profile(page)
    Log.debug "#{self.class.name} - caching: #{page.uri.to_s}"

    profile = parse_profile_for(page)
    return unless profile #if the page is screwed somehow

    ProfileRepository.instance.save(profile: profile, page_content: page.body)
  end

  def parse_profile_for(page)
    ProfileParser.new(page_content: page.body).profile
  rescue
    nil
  end

end
