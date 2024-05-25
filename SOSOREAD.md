install docker, install Npm, Optionally* install docker for vscode
if you have node installed, you can run this locally.

$ npm install
$ node server.js 

# now open localhost:80 in your browser
   localhost:80

But since this is a docker course, we will see how to build these docs to an image.

So now that we have the idea, let delete the 'node_modules' folders that were created while we ran node locally and proceed with our Docker processes.

NOTE: before creating my DOCKERFILE, I had these files list: SOSOREAD.md, server.js, package.json, package-lock.json, public folder


after writing our Dockerfile, lets build the image and then to a container... and run it

## BUILD THE IMAGE
$ docker build .
# It will build an image. copy the generated ID that it built.

## RUN THE IMAGE
$ docker run -p 4000:80 45777577adbgse
# this command has -p to specify the port: Port 4000 can be any # we add, but 80 shoud be the number we defined in the dockerfile.

$ docker ps -a 

NOW: Go the the url and type : localhost:3000


UNDERSTANDING ATTACHED OR DETACHER MODE
EX:
$ docker run -p 4000:80 45777577adbgse     //attached mode
$ docker run -p 4000:80 -d 45777577adbgse  //detached mode
---
SOME OTHER DOCKER COMMANDS
$ docker attach [container-id]
$ docker detach [container-id]
$ docker start [container-id]
$ docker stop [container-id]
$ docker logs [container-id]
$ docker start -a -i [container-id]   //interactive mode

COPY FILES TO AN EXISTING RUNNING CONTAINER
USE CASE: copy files to container without stopping container or rebuilding the image# you can add a file or folder in your working directore anc eopy to an existing docker container like so:
$ docker cp collins.txt [container-id]    //copying a file
$ docker cp kumba/collins.txt [container-id]    //copying a file and folder
$ docker cp kumba/. [container-id]    //copying all the file in the kumba folder

EXAMPLE:
$ docker cp collins.txt first-container    //copying a file to container called first-container 

$ docker cp collins.txt first-container:/test    //copying a file to container's new path called first-container:/test









## .gitlab ci
Build and push Docker image: This step uses the extracted version number as the image tag when building and pushing the Docker image to Amazon ECR.

Extract version from package.json: This step uses jq to parse the version number from package.json and set it as an environment variable (VERSION).  Here is the step on the pipeline: Extract version from package.json
