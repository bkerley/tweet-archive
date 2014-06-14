namespace :import do
  desc "Import BonzoESC tweets"
  task :mine => :environment do
    Timeline.fetch
  end
end
