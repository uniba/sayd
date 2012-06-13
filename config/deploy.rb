set :ident, "sayd"
set :user, "circuitlab"
set :application, "#{ident}"
set :repository, "https://github.com/uniba/#{ident}.git"
set :scm, :git
set :branch, "master"
set :scm_verbose, true
set :deploy_to, "/Users/#{user}/apps/#{application}"
set :deploy_via, :copy
set :git_shallow_clone, 1
set :node_env, 'production'
set :use_sudo, false
set :node_port, 3001

set :default_environment, {
  'PATH' => "/Users/#{user}/.brew/bin:$PATH",
}

default_run_options[:pty] = true

role :web, "a307.cct.la"
role :app, "a307.cct.la"

namespace :deploy do
  task :start, :roles => :app do
    run "NODE_ENV=#{node_env} PORT=#{node_port} forever start #{current_path}/app.js"
  end
  task :stop, :roles => :app do
    run "forever stop #{current_path}/app.js"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "NODE_ENV=#{node_env} PORT=#{node_port} forever restart #{current_path}/app.js"
  end
end

after "deploy:create_symlink", :roles => :app do
  run "ln -svf #{shared_path}/node_modules #{current_path}/node_modules"
  run "cd #{current_path} && npm install"
end

after "deploy:setup", :roles => :app do
  run "mkdir -p #{shared_path}/node_modules"
end