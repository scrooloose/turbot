namespace :bootstrapper do
  desc 'Setup Profile. Required: ENV["TURBOT_ENV"], ENV["pof_profile_id"]'
  task setup_profile: [:environment] do
    pof_profile_id = ENV['pof_profile_id'] || raise("ENV['pof_profile_id'] required")
    user_id = ENV['user_id'] || raise("ENV['user_id'] required")

    require 'net/http'
    page = Net::HTTP.get('www.pof.com', "/viewprofile.aspx?profile_id=#{pof_profile_id}")
    profile = ProfileCacher.new(page).cache
    User.find(user_id).update(profile_id: profile.id)
  end
end
