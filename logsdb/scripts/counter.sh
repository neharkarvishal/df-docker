#!/bin/bash

#TODO Inclide subscriber's prefix to able to identify the statistic
#TODO somehow check that sql insertion was successful

AGGREGATE_QUERY=`cat ./aggregate_counters.js`
COUNTERS=`mongo --quiet --authenticationDatabase admin \
                -u $MONGO_INITDB_ROOT_USERNAME \
                -p $MONGO_INITDB_ROOT_PASSWORD \
                access_log \
                --eval "$AGGREGATE_QUERY"`

OPERATION_TIMESTAMP="`date +'%Y-%m-%d %H:%M:%S %z'`";

echo
echo $COUNTERS
echo

#Pretty pritn the resulting JSON
jq . <<< $COUNTERS

echo "---------------------"
echo
echo "$OPERATION_TIMESTAMP Inserting Statistic:"
jq . <<< $STATISTIC_PAYLOAD

INSERTION_SQL=`COUNTERS_JSON=${COUNTERS:-'{}'} OP_TIME=$OPERATION_TIMESTAMP envsubst < ./insert_request_counters.sql`
INSERTION_OUTPUT=`mysql -v -h "dreamfactory-saas-statistic.cmz2vpny0neq.us-east-1.rds.amazonaws.com" \
                 -u "root" \
                 "-p ... " \
                 "statistic" \
                 -e "$INSERTION_SQL"`

echo
echo $INSERTION_OUTPUT
echo
