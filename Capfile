# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Load the SCM plugin appropriate to your project:
#
# require 'capistrano/scm/hg'
# install_plugin Capistrano::SCM::Hg
# or
# require 'capistrano/scm/svn'
# install_plugin Capistrano::SCM::Svn
# or
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
require 'capistrano/bundler'
require 'capistrano/rails'
# require 'capistrano/rails/assets'
# require 'capistrano/rails/migrations'
# require 'capistrano/passenger'

set :default_env, { rvm_bin_path: '~/.rvm/bin' }

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

set :rvm_ruby_version, '2.5.0'

# set :bundle_gemfile, -> { release_path.join('Gemfile') }
# set :bundle_dir, -> { shared_path.join('bundle') }
# set :bundle_flags, '--deployment'
# set :bundle_without, %w(test development).join(' ')
# set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_roles, :all
set :assets_roles, :app
set :migration_role, :app
