namespace :db do
  desc 'Migrate database'
  task :migrate do
    env = ENV['AUTOPOF_ENV'] || raise("AUTOPOF_ENV must be set")
    system("sequel -m db/migrations -e #{env} ./config/db.yml")
  end
end
