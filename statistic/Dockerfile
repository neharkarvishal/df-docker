FROM ubuntu:xenial

# Install tools
RUN apt-get update && \
    #Needed to send statistic to external server
    apt-get install -y curl && \
    #For pretty printing json
    apt-get install -y jq && \
    apt-get install -y mysql-client && \
    apt-get install -y gettext &&\
    apt-get install -y apt-transport-https

# Install mongo shell
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list && \
    apt-get update && \
    apt-get install -y mongodb-org-shell

COPY scripts/ /scripts
