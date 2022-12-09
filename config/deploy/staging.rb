set :deploy_to, '/home/deploy/apps/tiger-backend-staging'
set :branch, 'test'
set :rails_env, 'staging'
set :puma_threads, [1, 5]
set :puma_workers, 1
set :puma_preload_app, true
set :whenever_environment, -> { fetch(:stage, 'staging') }
server '119.23.237.209', user: 'deploy', roles: %w[app db web], my_property: :my_value
