# Octomerge Rails
Rails server for Octomerge Chrome extension which lets you automatic merge when build succeeds on Github

Learn more about [Octomerge](https://github.com/tennisonchan/octomerge)

## Get Start for Local Development
Copy both the `.env` and `.docker-env` files
```
cp .env-example .env
cp .docker-env-example .docker-env

# Install all gems
bundle install

# Run redis and postgres by docker-compose
docker-compose up -d

# Run Rails server
rails server
```

## Build Docker Image
Build docker image based on the file `Dockfile`. Rails and the gems are all built inside the image. The folder `docker/freeze` is to cache the installed gems to speed up the building process [***](https://github.com/pinglamb/docker-rails).
```
docker build -t tennisonchan/octomerge-rails .
```

## Push Docker Image to Docker Hub
Push it to docker hub repo [tennisonchan/octomerge-rails](https://hub.docker.com/r/tennisonchan/octomerge-rails/)
```
docker push tennisonchan/octomerge-rails
```

## Pull and Run the Docker Image on Server
ssh and pull the docker image from docker hub
```
docker pull tennisonchan/octomerge-rails
```

Copy and paste the `docker-compose-production.yml` and rename it to `docker-compose.yml`. Then run
```
docker-compose up -d
```

## Run Database Migration on Server
ssh to server and run `docker exec` against the contain `octomerge_web` with migration
```
docker exec -it octomerge_web bundle exec rails db:migrate
```

## See Logs on Server
ssh to server and run `docker exec` against the contain `octomerge_web` with `bash` and then tail the log file
```
docker exec -it octomerge_web bash
tail -n 200 log/production.log
```
