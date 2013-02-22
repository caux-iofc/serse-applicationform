set :application, "serse-application"
set :domain,      "application"
set :deploy_to,   "/var/www/application.caux.iofc.org"
role :web, "application"
role :app, "application"
role :db, "application", :primary=>true
set :scm,         :git
set :repository,  "ssh://git@git.jhvc.com:2222/serse-applicationform.git"
set :branch, "master"
set :rails_env,   "production"
set :config_files, ['database.yml']
set :rake, 'bundle exec rake'

ssh_options[:forward_agent] = true
ssh_options[:user] = 'root'

desc "Clean up old releases"
set :keep_releases, 5
before("deploy:cleanup") { set :use_sudo, false }

load "deploy/assets"
before "deploy:assets:precompile", "deploy:copy_files", :roles => :app
after "deploy:copy_files", "deploy:bundle_install", :roles => :app
after "deploy:update", "deploy:migrate", :roles => :db
after :deploy, 'deploy:cleanup', :roles => :app

namespace :deploy do
  desc "Put a few files in place, ensure correct file ownership"
  task :copy_files, :roles => :app,  :except => { :no_release => true } do
    # Copy a few files/make a few symlinks
    run "cp /home/passenger/database.yml-production #{release_path}/config/database.yml"
    run "cp /home/passenger/secret_token.rb-production #{release_path}/config/initializers/secret_token.rb"
    run "cp /home/passenger/hoptoad.rb-production #{release_path}/config/initializers/hoptoad.rb"
    run "cp /home/passenger/production.rb-production #{release_path}/config/environments/production.rb"
    # Ensure correct ownership of a few files
    run "chown www-data:www-data #{release_path}/config/environment.rb"
    run "chown www-data:www-data #{release_path}/config.ru"

    # make sure to symlink the tmp_script directory.
    run "cd #{release_path}; ln -s #{shared_path}/tmp_script #{release_path}/tmp_script"

    # make sure to symlink the vendor bundle. Cf. http://gembundler.com/rationale.html
    run "cd #{release_path}; ln -s #{shared_path}/vendor_bundle #{release_path}/vendor/bundle"
  end

  desc "Install new gems if necessary"
  task :bundle_install, :roles => :app,  :except => { :no_release => true } do
    run "cd #{release_path} && bundle install --deployment"
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    # Tell passenger to restart.
    run "touch #{current_path}/tmp/restart.txt"
  end 
  [:start, :stop].each do |t| 
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end 
  end 
end
