#!/bin/bash

#TODO Include subscriber's prefix to able to identify the statistic
#TODO somehow check that sql insertion was successful


AGGREGATE_QUERY=`cat ./aggregate_counters.js`
COUNTERS=`mongo --quiet --authenticationDatabase admin \
                -u $MONGO_INITDB_ROOT_USERNAME \
                -p $MONGO_INITDB_ROOT_PASSWORD \
                access_log \
                --eval "$AGGREGATE_QUERY"`

OPERATION_TIMESTAMP="`date +'%Y-%m-%d %H:%M:%S %z'`";

echo
printf "Counting at: \033[32m$OPERATION_TIMESTAMP"
echo

#Pretty pritn the resulting JSON
jq . <<< $COUNTERS

echo "---------------------"
echo
echo "$OPERATION_TIMESTAMP Inserting Statistic:"
jq . <<< $STATISTIC_PAYLOAD

INSERTION_SQL=`COUNTERS_JSON=${COUNTERS:-'{}'} \
               OP_TIME=$OPERATION_TIMESTAMP \
               envsubst < ./insert_request_counters.sql`

INSERTION_OUTPUT=`mysql -v -h "$TARGET_DB_HOST" \
                 -u "$TARGET_DB_USER" \
                 "-p$TARGET_DB_PASS" \
                 "$TARGET_DB_NAME" \
                 -e "$INSERTION_SQL"`

echo
echo $INSERTION_OUTPUT
echo
