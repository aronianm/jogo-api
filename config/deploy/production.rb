server '18.188.182.174', user: 'ec2-user', roles: %w{web app db}
set :ssh_options, {
forward_agent: true,
auth_methods: %w[publickey],
keys: %w[/home/shreya/server-keys/filterrific-key-pair.pem]
}
