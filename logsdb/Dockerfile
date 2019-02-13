FROM mongo:4.0-xenial

RUN apt-get update && \
    #Needed to send statistic to external server
    apt-get install -y curl && \
    #For pretty printing json
    apt-get install -y jq


#COPY counter.sh /
