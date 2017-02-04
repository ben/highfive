# namespace :foreman do
#   desc "Export the Procfile to Ubuntu's upstart scripts"
#   task :export do
#     on primary roles :app do
#       run "cd #{current_path} && #{sudo} foreman export upstart /etc/init -a #{application} -l /var/#{application}/log"
#     end
#   end
#
#   desc 'Start the application services'
#   task :start do
#     on primary roles :app do
#       run "#{sudo} service #{application} start"
#     end
#   end
#
#   desc 'Stop the application services'
#   task :stop do
#     on primary roles :app do
#       run "#{sudo} service #{application} stop"
#     end
#   end
#
#   desc 'Restart the application services'
#   task :restart do
#     on primary roles :app do
#       run "#{sudo} service #{application} start || #{sudo} service #{application} restart"
#     end
#   end
#
#   task :restart do
#     on primary roles :app do
#       foreman.export
#
#       # on OS X the equivalent pid-finding command is `ps | grep '/puma' | head -n 1 | awk {'print $1'}`
#       run "(kill -s SIGUSR1 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})) || #{sudo} service #{app_name} restart"
#
#       # foreman.restart # uncomment this (and comment line above) if we need to read changes to the procfile
#     end
#   end
# end

set :foreman_export_path, '/etc/init'
