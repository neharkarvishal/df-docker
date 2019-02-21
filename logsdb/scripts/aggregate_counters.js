printjson(
    db.access.aggregate([
        {
            $match: {
                uri: {
                    $regex: "^/api/v2*",
                    $nin: [
                        /api\/v2\/system/,
                        "/api/v2",
                        /^\/api\/v2\/user*/
                    ]
                }
            },
        },

        {
            $group: {
                _id: "$uri",
                total: { $sum:1 }
            }
        }
    ]).toArray()
)
