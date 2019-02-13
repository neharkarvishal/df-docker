#!/bin/bash

SYSTEM_REQUESTS=`mongo --quiet --authenticationDatabase admin -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD access_log --eval "printjson(db.access.find({uri: /system/}).count())"`

STATISTIC_PAYLOAD="
    {\"system\": \"$SYSTEM_REQUESTS\"}
"
OPERATION_TIMESTAMP="`date +'%Y-%m-%d %H:%M:%S'`";

echo "---------------------"
echo
echo "$OPERATION_TIMESTAMP Sending Statistic:"
jq . <<< $STATISTIC_PAYLOAD
echo
echo "Target statistic URL - $STATISTIC_TARGET_URL"
echo
echo "Performing CURl request..."
RESP=`curl -s -w "\n{\"responseCode\": \"%{response_code}\"}" --header "Content-Type: application/json" -d "$STATISTIC_PAYLOAD" --request POST $STATISTIC_TARGET_URL`
jq . <<< $RESP
echo
echo "---------------------"
