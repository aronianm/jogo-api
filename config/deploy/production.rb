server '18.188.182.174', user: 'ec2-user'
set :ssh_options, {
forward_agent: true,
auth_methods: %w[publickey]
}