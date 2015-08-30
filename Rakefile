namespace :db do

  desc 'Migrate database'
  task :migrate do
    system("sequel -m db/migrations -e development ./config/db.yml")
  end
end
