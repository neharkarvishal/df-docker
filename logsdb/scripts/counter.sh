#!/bin/bash

COUNTERS=`mongo --quiet --authenticationDatabase admin -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD access_log --eval 'printjson(db.access.aggregate([{$match: { uri: {"$regex":"^/api/v2*", $nin: [/api\/v2\/system/, "/api/v2", /^\/api\/v2\/user*/]}},  }, { "$group" : {_id:"$uri", total:{$sum:1}} } ]).toArray())'`

OPERATION_TIMESTAMP="`date +'%Y-%m-%d %H:%M:%S %z'`";

STATISTIC_PAYLOAD="
    {
        \"counted_at\": \"$OPERATION_TIMESTAMP\",
        \"counters\": $COUNTERS
    }
"

#Pritn the resulting JSON
jq . <<< $STATISTIC_PAYLOAD

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
