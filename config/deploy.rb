# config valid only for current version of Capistrano
lock "3.8.2"

set :application, "QnA"
set :repo_url, 'https://github.com/CaptainPhilipp/QnA.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/qna/'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/secrets.yml', '.env'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads'

set :rvm_ruby_version, '2.4.0@qna'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :deploy, 'thinking_sphinx:restart'
end
