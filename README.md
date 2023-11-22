# selenium-issue
Selenium concurrency issue step to reproduce

# To reproduce this issue  you need to run the docker-compose file
````
docker-compose up -d
````
It runs a robot script with three tests 10 times
- Open browser with chrome
- Open browser with edge
- Open browser with firefox

to view the tests result run the following command
````
docker logs -f python
````

If the issue doesn't occur the first time. Access to the python container and run the tests manually
````
docker exec -it python bash
````

then run ```` bash run-tests.sh ````

# Testing with build jar
### Build and put your selenium-server.jar file in [build-images](build-images) folder
### Change all the docker files under build-images  to use this jar

Example using selenium-server-4.16.0-SNAPSHOT.jar in [Dockerfile](build-images/hub/Dockerfile)
````
ARG SELENIUM_TAG
FROM selenium/hub:$SELENIUM_TAG
RUN rm /opt/selenium/selenium-server.jar
ADD ["../selenium-server-4.16.0-SNAPSHOT.jar","/opt/selenium/selenium-server.jar"]
````

### Build your new tag with this [script](build-images/build-images.sh) 

````
#!/bin/bash
#This is the official selenium images
SELENIUM_TAG=4.15.0-20231110

images=("standalone-chrome" "standalone-edge" "standalone-firefox" "node-docker" "hub")
for image in "${images[@]}"; do
  echo "Building image for:" "$image"
  #This is the tag that we will use in dev testing
  TAG="selenium/$image:new-tag"
  docker build --no-cache -f ./"$image"/Dockerfile --build-arg SELENIUM_TAG=$SELENIUM_TAG -t "$TAG" .
  echo "Built image tag:" "$TAG"
done
````

change the new tag in [.env](.env)  file

````
SELENIUM_DOCKER_TAG=new-tag
SESSION_REQUEST_TIMEOUT=900
````

Change also the [config.toml](config.toml) image tags

````
[docker]
# Configs have a mapping between the Docker image to use and the capabilities that need to be matched to
# start a container with the given image.
configs = [
    "selenium/standalone-firefox:new-tag", '{"browserName": "firefox"}',
    "selenium/standalone-chrome:new-tag", '{"browserName": "chrome"}',
    "selenium/standalone-edge:new-tag", '{"browserName": "MicrosoftEdge"}'
]

# URL for connecting to the docker daemon
# Most simple approach, leave it as http://127.0.0.1:2375, and mount /var/run/docker.sock.
# 127.0.0.1 is used because internally the container uses socat when /var/run/docker.sock is mounted
# If var/run/docker.sock is not mounted:
# Windows: make sure Docker Desktop exposes the daemon via tcp, and use http://host.docker.internal:2375.
# macOS: install socat and run the following command, socat -4 TCP-LISTEN:2375,fork UNIX-CONNECT:/var/run/docker.sock,
# then use http://host.docker.internal:2375.
# Linux: varies from machine to machine, please mount /var/run/docker.sock. If this does not work, please create an issue.
url = "http://127.0.0.1:2375"
# Docker image used for video recording
video-image = "selenium/video:ffmpeg-6.0-20231110"

# Uncomment the following section if you are running the node on a separate VM
# Fill out the placeholders with appropriate values
#[server]
#host = <ip-from-node-machine>
#port = <port-from-node-machine>
````



## Extract the logs of the running containers (Optional)
Run the following script [log.sh](logs.sh). 
It gets the logs off all containers running on port 5900  and redirect the logs with  ````Failed to run````  into error file (container-id-error.log)