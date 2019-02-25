#!/bin/bash

#TODO somehow check that sql insertion was successful
#TODO handle initial table setup - probably check somehow whether the table exists and create it if not

echo
printf "\033[0m---------------------\033[0m"
echo
printf "\033[32mOPERATION STARTED\033[0m"
echo

COUNTERS=`mongo --host "$STATISTIC_DB_HOST" \
                -u $MONGO_INITDB_ROOT_USERNAME \
                -p $MONGO_INITDB_ROOT_PASSWORD \
                --quiet --authenticationDatabase admin \
                access_log \
                 < /scripts/aggregate_counters.js`


OPERATION_TIMESTAMP="`date +'%Y-%m-%d %H:%M:%S %z'`";

echo
echo "Counting at:"
printf "\033[32m$OPERATION_TIMESTAMP\033[0m"
echo
echo

# Pretty pritn the counters JSON
jq . <<< $COUNTERS

echo
echo "Inserting Statistic:"
echo

# Iterate through counters JSON and insert each count as
# separate record
for row in $(echo "${COUNTERS}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

   INSERTION_SQL=`SERVICE=$(_jq '._id') \
               COUNT=$(_jq '.total') \
               OP_TIME=$OPERATION_TIMESTAMP \
               envsubst < /scripts/insert_request_counters.sql`

   INSERTION_OUTPUT=`mysql -v -h "$TARGET_DB_HOST" \
                 -u "$TARGET_DB_USER" \
                 "-p$TARGET_DB_PASS" \
                 "$TARGET_DB_NAME" \
                 -e "$INSERTION_SQL"`
   echo
   echo $INSERTION_OUTPUT
   echo
done



echo
printf "\033[32mOPERATION FINISHED\033[0m"
echo
echo "---------------------"
echo
