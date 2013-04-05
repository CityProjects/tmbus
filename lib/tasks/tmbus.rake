


namespace :heroku do

  task :start_queue_workers => :environment do
    Process.spawn(ENV, 'bundle exec rake resque:work INTERVAL=2 COUNT=2 QUEUE=*')
    Process.spawn(ENV, 'bundle exec rake resque:work INTERVAL=2 QUEUE=nexmo_send_sms')
    Process.waitall
  end

end


namespace :cron do

  task :every_10_minutes => :environment do
    CampaignsPeriodicWorker.enqueue
  end



  task :every_hour => :environment do
    BusinessesPeriodicWorker.enqueue
  end




  task :every_day => :environment do
    SystemMailer.daily_report().deliver
  end

end
