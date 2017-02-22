require 'mina/bundler'
require 'mina/rails'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm' #服务器上使用的是rvm
# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

#set :application_name, 'foobar'
#服务器地址,是使用ssh的方式登录服务器
set :domain, 'root@118.89.151.182'
#服务器中项目部署位置
set :deploy_to, '/var/lyp-rails-app/my_blog'
#git代码仓库
set :repository, 'https://github.com/liyouping/my_blog.git'
#git分支
set :branch, 'master'

# For system-wide RVM install.
set :rvm_path, '/usr/local/rvm/bin/rvm'

# 中括号里的文件 会出现在服务器项目附录的shared文件夹中，这里加入了secrets.yml，环境密钥无需跟开发计算机一样
set :shared_paths, ['config/database.yml', 'tmp', 'config/secrets.yml', 'log']

# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# set :shared_dirs, fetch(:shared_dirs, []).push('somedir')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
  invoke :'rvm:use[ruby-2.3.0]'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
# 这个块里面的代码表示运行 mina setup时运行的命令
task :setup => :environment do
  # 在服务器项目目录的shared中创建log文件夹
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  # 在服务器项目目录的shared中创建config文件夹 下同
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/sockets"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  #queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml' and 'secrets.yml'."]

  if repository
    repo_host = repository.split(%r{@|://}).last.split(%r{:|\/}).first
    repo_port = /:([0-9]+)/.match(repository) && /:([0-9]+)/.match(repository)[1] || '22'

    queue %[
      if ! ssh-keygen -H  -F #{repo_host} &>/dev/null; then
        ssh-keyscan -t rsa -p #{repo_port} -H #{repo_host} >> ~/.ssh/known_hosts
      fi
    ]
  end
end

#这个代码块表示运行 mina deploy时执行的命令
desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      #queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      queue "pumactl -F  #{deploy_to}/#{current_path}/config/puma.rb  restart"
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
