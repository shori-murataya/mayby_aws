# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "mayby_aws"
set :repo_url, "git@github.com:shori-murataya/mayby_aws.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/rails/mayby_aws"

# シンボリックリンクをはるファイル
set :linked_files, fetch(:linked_files, []).push('config/settings.yml')

# シンボリックリンクをはるフォルダ
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# shared/config/master.keyの読み込み
set :linked_files, fetch(:linked_files, []).push("config/master.key")

# 保持するバージョンの個数(※後述)
set :keep_releases, 5

# rubyのバージョン
set :rbenv_ruby, '2.7.1'

#出力するログのレベル。
set :log_level, :debug

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end

  desc 'Run seed'
  task :seed do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end
