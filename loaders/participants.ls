require! {
    \../load.ls
    \prelude-ls : { map, obj-to-pairs, filter }
}


load-holders = ([pair, ...rest], cb)->
    [name, address] = pair
    err, holders <- load "holders #{address}"
    return cb err if err?
    result = { name, address, holders }
    err, rest <- load-holders rest
    return cb err if err?
    all = [result] ++ rest
    cb null, all

apply-filter = (params, [name, address])-->
    return no if not address? or not name?
    return yes if not params?0?
    return yes if params.0.index-of(\0x) is 0 and address is params.0
    return yes if name is params.0
    no

module.exports = (params, cb)->
    err, coins <- load \coins
    return cb err if err?
    coin-pairs =
        coins |> obj-to-pairs 
              |> filter apply-filter params
    err, data <- load-holders coin-pairs
    return cb err if err?
    cb null, data