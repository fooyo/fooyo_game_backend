set :deploy_to, '/home/deploy/apps/tiger-backend'
set :branch, 'main'
set :rails_env, 'production'
set :puma_threads, [1, 5]
set :puma_workers, 2
set :puma_preload_app, true
set :whenever_environment, -> { fetch(:stage, 'production') }
server '119.23.237.209', user: 'deploy', roles: %w[app db web], my_property: :my_value
