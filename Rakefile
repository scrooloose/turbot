require File.dirname(__FILE__) + '/lib/turbot'

namespace :db do
  desc "Migrate the database. Required: ENV['TURBOT_ENV']"
  task :migrate do
    ActiveRecord::Migrator.migrate("./db/migrations/")
  end
end

desc 'Output a bunch of stats'
task stats: :environment do
  puts "Total profiles cached: #{Profile.count}"
  puts "Total messages sent: #{Message.count}"
  puts "Total responses received: #{Message.with_response.count}"

  messagable_count = 0
  Profile.unmessaged.each_page(100) do |page|
    page.each do |profile|
      messagable_count += 1 if profile.matches_any_topic?
    end
  end
  puts "Messagable profiles remaining: #{messagable_count}"
end

namespace :bootstrap do
  desc 'Setup Profile. Required: ENV["TURBOT_ENV"], ENV["pof_profile_id"]'
  task :setup_profile do
    pof_profile_id = ENV['pof_profile_id'] || raise("ENV['pof_profile_id'] required")

    require 'net/http'
    page = Net::HTTP.get('www.pof.com', "/viewprofile.aspx?profile_id=#{pof_profile_id}")
    profile = ProfileCacher.new(page).cache
    puts "Update config.yml now. Set 'user_profile_id' to #{profile.id}"
  end
end
