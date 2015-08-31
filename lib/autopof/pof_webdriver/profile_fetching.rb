module PofWebdriver::ProfileFetching
  def cache_profiles_from_search_page(num_pages: 1)
    cache_search_pages(to_search_page, num_pages: num_pages)
  end

private
  def to_search_page
    post_login_page = login
    post_login_page.link_with(text: 'search').click
  end

  def cache_search_pages(page_one, num_pages: nil)
    current_page = page_one

    1.upto(num_pages) do |p_num|
      cache_profiles(current_page)

      next_page_num = p_num + 1
      current_page = current_page.link_with(id: "basicsearch_pager_#{next_page_num}").click
    end
  end

  def cache_profiles(page)
    Log.info "#{self.class.name} - caching for: #{page.uri.to_s}"
    profile_links = page.links_with(href: /^viewprofile.*/, class: 'link')
    profile_links.each do |link|

      #cache half of the profiles on the page so we appear less like a bot
      next if rand(2) == 0

      cache_profile(link.click)
      sleep(rand(5))
    end
  end

  def cache_profile(page)
    Log.info "#{self.class.name} - caching: #{page.uri.to_s}"

    parser = ProfilePageParser.new(page_content: page.body)

    profile = if Profile.where(pof_key: parser.pof_key).any?
                Profile.find(pof_key: parser.pof_key)
              else
                Profile.new(username: parser.username, pof_key: parser.pof_key)
              end
    profile.page_content = page.body
    profile.save
  end

end
