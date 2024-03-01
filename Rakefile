# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

# Build docker image
task :compose_up do
  sh "docker-compose up --build"
end

task :compose_down do
  sh "docker-compose down"
end

task :compose_down_volumes do
  sh "docker-compose down --volumes"
end

task :compose_db_create_and_migrate do
  sh "docker-compose run web bundle exec rails db:create db:migrate"
end

task :compose_rails_console do
  sh "docker-compose run --rm web bundle exec rails console"
end

task :list_docker_containers do
  sh "docker ps"
end

task :bash_into_db do
  sh "docker-compose run db bash"
end

task :bash_into_web do
  sh "docker-compose run web bash"
end
