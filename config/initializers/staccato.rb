if ENV['GOOGLE_ANALYTICS_ID'].present?
  puts "Initialing Google analytics with ID '#{ENV['GOOGLE_ANALYTICS_ID']}'"
  GoogleTracker = Staccato.tracker(ENV['GOOGLE_ANALYTICS_ID'], nil, ssl: true)
end
