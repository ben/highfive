require 'resque/tasks'
task 'resque:setup' => :environment

task restart_workers: :environment do
  pids = []
  Resque.workers.each do |worker|
    pids << worker.to_s.split(/:/).second
  end

  system("kill -QUIT #{pids.join(' ')}") if pids.size.positive?
end
