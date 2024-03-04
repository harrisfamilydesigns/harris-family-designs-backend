desc 'build web and db containers, and start the app'
task :compose_up do
  sh "docker compose up --build"
end

desc 'stop and remove containers, networks, images, and volumes'
task :compose_down do
  sh "docker compose down"
end

desc 'list all docker containers'
task :list_docker_containers do
  sh "docker ps"
end

desc 'ssh into the db container'
task :bash_into_db do
  sh "docker-compose run db bash"
end

desc 'ssh into the web container'
task :bash_into_web do
  sh "docker-compose run web bash"
end
