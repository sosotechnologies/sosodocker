FROM node                
#1
# build your image from another base image

WORKDIR /app              
#4
# this workdir is what i defined in #2, I am telling Docker that when I install npm, I want you to do in this directory. 
# remember i can still define my WORKDIR as " /app  "

COPY . /app               
#2
# COPY . ./ 
# COPY . .
# tell docker the files on the left it should use. In our case i'm using [. .] meaning select every file
# The first [.] represent the files in the same directory as the dockerfile
# The second [.] represents the path inside the image where those files will be stored.
# Ex: you can copy like so: " COPY . /app " IN this example we are copying the files to /app in the container
# I can also set as a relative path as just [ . ./] because I have defined a workdir with a defined value

RUN npm install            
#3
# if you recall, we did this process as a command earlier

EXPOSE 80                  
#6
# remember we have defined a port # in our server.js, and we have to let docker know that it should listen to this port

CMD ["node", "server.js"]  
#5
# to define a CMD, we open an array [], and also pass 2 strings "", "" to separate our commands
# CMD command​ specifies the instruction that is to be executed when a Docker container starts.
# We are telling docker to use the node command inside the container to run our server.js file
