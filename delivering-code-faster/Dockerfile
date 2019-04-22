# base image and its version, from dockerhub - https://hub.docker.com/_/postgres
FROM postgres:9.6

# make sure all files needed from scripts are inside of the container
ENV DEST /var/app
COPY . $DEST

# argument to define the script to create the sample database as a build flag
ARG SCRIPT

# copy the desired script to postgres entrypoint (explained on the dockerhub image)
RUN cp $DEST/$SCRIPT /docker-entrypoint-initdb.d/
