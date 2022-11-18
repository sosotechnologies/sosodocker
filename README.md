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
