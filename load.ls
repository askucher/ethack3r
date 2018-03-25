require! {
    \fs : { write-file-sync, read-file-sync, exists-sync }
    \require-ls
}

read-from-cache = (filename, cb)->
    data = JSON.parse read-file-sync(filename, \utf8)
    cb null, data

get-filename = (name, params)->
    return "#{dirname}/db/#{name}.json" if (params ? []).length is 0
    "#{dirname}/db/#{name}-#{params.join('-')}.json"

parse-params = (input)->
    | typeof! input is \Array => input
    | typeof! input is \String => input.split(' ')
    | typeof! input is \Object => [input.name] ++ (input.params ? [])
    | _ => []
module.exports = (input, cb)->
    [name, ...params] = parse-params input
    return cb "Name is required" if not name?
    filename = get-filename name, params
    return read-from-cache filename, cb if exists-sync filename
    loader = require "./loaders/#{name}.ls"
    err, data <- loader params
    return cb err if err?
    write-file-sync filename , JSON.stringify(data, null, 4)
    cb null, data