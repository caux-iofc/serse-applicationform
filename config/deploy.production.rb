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

ssh_options[:forward_agent] = true
ssh_options[:user] = 'root'

desc "Clean up old releases"
set :keep_releases, 5
before("deploy:cleanup") { set :use_sudo, false }

after "deploy:create_symlink", "deploy:copy_vendor_bundle_dir", :roles => :app 
after "deploy:copy_vendor_bundle_dir", "deploy:copy_files", :roles => :app
after "deploy:update", "deploy:migrate", :roles => :db
after :deploy, 'deploy:cleanup', :roles => :app

namespace :deploy do
  desc "Copy vendor/bundle to the new directory"
  task :copy_vendor_bundle_dir, :on_error => :continue do
    prev_uploads_dir = "#{previous_release}/vendor/bundle"
    run "[ -d #{prev_uploads_dir} ] && cp -pr #{prev_uploads_dir} #{current_path}/vendor/"
  end 
  desc "Put a few files in place, ensure correct file ownership"
  task :copy_files, :roles => :app,  :except => { :no_release => true } do
    # Copy a few files/make a few symlinks
    run "cp /home/passenger/database.yml-production #{current_path}/config/database.yml"
    run "cp /home/passenger/secret_token.rb-production #{current_path}/config/initializers/secret_token.rb"
    run "cp /home/passenger/hoptoad.rb-production #{current_path}/config/initializers/hoptoad.rb"
    run "cp /home/passenger/production.rb-production #{current_path}/config/environments/production.rb"
    # Ensure correct ownership of a few files
    run "chown www-data:www-data #{current_path}/config/environment.rb"
    run "chown www-data:www-data #{current_path}/config.ru"
    # Do the bundle install thing -- this is ridiculously slow if the :copy_vendor_bundle_dir task
    # was unable to copy the bundle directory
    run "[ ! -d #{current_path}/vendor/bundle ] && mkdir #{current_path}/vendor/bundle || echo 'vendor/bundle exists, good'"
    run "chown www-data:www-data #{current_path}/vendor/bundle"
    run "chown www-data:www-data #{current_path}"
    run "cd #{current_path}; sudo -u www-data bundle --deployment install"
    # Precompile assets -- this is also slow
    run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
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
