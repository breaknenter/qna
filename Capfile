# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Other tasks
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/passenger'
require 'capistrano/sidekiq'
require 'thinking_sphinx/capistrano'
require 'whenever/capistrano'

install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

set :rbenv_type, :user
set :rbenv_ruby, '2.7.4'
