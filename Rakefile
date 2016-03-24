namespace :db do
  desc 'Migrate database'
  task :migrate do
    env = ENV['AUTOPOF_ENV'] || raise("AUTOPOF_ENV must be set")
    system("sequel -m db/migrations -e #{env} ./config/db.yml")
  end

  desc 'Rollback to revision ENV["rev"]'
  task :rollback do
    env = ENV['AUTOPOF_ENV'] || raise("AUTOPOF_ENV must be set")
    rev = ENV['REV'] || raise("ENV['REV'] must be set")
    system("sequel -m db/migrations -M #{rev} -e #{env} ./config/db.yml")
  end
end

desc 'Output a bunch of stats'
task :stats do
  require File.dirname(__FILE__) + '/lib/autopof'
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
