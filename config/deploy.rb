# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'QnA'
set :repo_url,    'https://github.com/breaknenter/qna.git'
set :deploy_to,   'home/deployer/qna'
set :deploy_user, 'deployer'

set :linked_files, %w[config/database.yml config/master.key]
set :linked_dirs,  %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system storage]
