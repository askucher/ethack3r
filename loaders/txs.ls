require! {
    \qs
    \prelude-ls : { filter, each, map, foldl, join }
    \superagent : { get, post }
}

load = (addresses, cb)->
    address = addresses.0
    get-params  =  (page)->
        module : \account
        page : page
        offset : 3000
        action : \txlist
        address : address
        startblock : "0"
        endblock : "99999999"
        sort : \asc
        apikey : \4TNDAGS373T78YJDYBFH32ADXPVRMXZEIG

    load = (page, cb)->
        query = qs.stringify get-params page
        err, resp <- get "http://api.etherscan.io/api?#{query}" .timeout(deadline: 5000).end
        return cb err if err?
        result = JSON.parse resp.text
        return cb null, [] if result.result.length is 0 or result.message isnt \OK
        transactions =
            result.result |> filter (-> parse-int(it.confirmations) > 3)
                          |> filter (.isError is \0)
                          |> filter (.txreceipt_status is \1)
        err, rest-transactions <- load page + 1
        return cb err if err?
        all = transactions ++ rest-transactions
        cb null, all
    load 0, cb
    
module.exports = load