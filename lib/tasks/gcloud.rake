# Usage: rake gcloud_build_push_update

desc 'Build the Docker image'
task gcloud_build: :environment do
  sh "docker build -t gcr.io/hfdbe-416102/harris-family-designs-backend:v1 ."
end

desc 'Push the Docker image to the Google Cloud Container Registry'
task gcloud_push: :environment do
  sh "docker push gcr.io/hfdbe-416102/harris-family-designs-backend:v1"
end

desc 'Update the Google Cloud Run service with the new image'
task gcloud_update: :environment do
  sh "gcloud run services update harris-family-designs-backend --image=gcr.io/hfdbe-416102/harris-family-designs-backend:v1 --region=us-central1 --platform=managed"
end

desc 'Build, push, and update the Google Cloud Run service'
task :deploy => [:gcloud_build, :gcloud_push, :gcloud_update]

