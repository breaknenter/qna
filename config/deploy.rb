# config valid only for current version of Capistrano
lock '3.17.1'

set :application, 'QnA'
set :repo_url,    'git@github.com:breaknenter/qna.git'
set :branch,      'main'
set :deploy_to,   '/home/deployer/qna'
set :deploy_user, 'deployer'

set :linked_files, %w[config/database.yml config/master.key]
set :linked_dirs,  %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system storage]
