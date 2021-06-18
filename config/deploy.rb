# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "qna"
set :repo_url, "git@github.com:NazarovSV/qna.git"

# Default deploy_to directory is /var/www/my_app_name
#
set :deploy_to, "/home/deploy/qna"
set :deploy_user, 'deploy'
set :rbenv_ruby, '2.7.2'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'storage'

set :init_system, :systemd
set :service_unit_name, "sidekiq"

after 'deploy:publishing', 'unicorn:restart'