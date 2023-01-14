server '62.113.96.111', user: 'deployer', roles: %w[app web db], primary: true

set :rails_env, :production

set :ssh_options, { auth_methods:  ['publickey', 'password'],
                    keys:          ['/home/sergey/.ssh/id_rsa'],
                    port:          2222,
                    forward_agent: true }
