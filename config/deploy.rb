sh 'ssh-add'

set :application, 'tiger-backend'
set :repo_url, 'git@gitlab.com:fooyostudio/tiger-backend.git'
set :pty, false

append :linked_files, 'config/database.yml', 'config/master.key'
# namespace :deploy do
#   namespace :check do
#     before :linked_files, :set_database_and_master_key do
#       on roles(:app), in: :sequence, wait: 10 do
#         unless test("[ -f #{shared_path}/config/database.yml]")
#           upload! 'config/database.yml', "#{shared_path}/config/database.yml"
#         end
#         unless test("[ -f #{shared_path}/config/master.key]")
#           upload! 'config/master.key', "#{shared_path}/config/master.key"
#         end
#       end
#     end
#   end
# end

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for keep_releases is 5
set :keep_releases, 3
set :conditionally_migrate, true
set :keep_assets, 2
