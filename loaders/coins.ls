require! {
    \fs 
    \superagent : { post, get }
    \prelude-ls : { map, filter }
}


search = (term, cb)->
    url = "https://etherscan.io/searchHandler?t=t&term=#{term}"
    err, data <- get url .timeout(deadline: 50000).end
    return cb err if err?
    pack = (it)->
        [ it.split('\t').1, (it.index-of 'color:green;') >= 0 ]
    data = data.text |> JSON.parse |> map pack
    if !data.length then return cb null, []
    list = data |> filter (.1) |> map (.0)
    if list.length > 1 then list = [list.0]
    if !list.length then list = [data.0.0]
    cb null, list


scanerall = ([head, ...list], cb)->
    return cb null, {} if !head?
    #console.log list.length
    err, tokens <- search head.symbol
    return cb err if err?
    err, list <- scanerall list
    return cb err if err?
    list[head.symbol] = tokens?0
    cb null, list


parser = (params, cb)->
    url = "http://crowddd.flyber.net/vadim/tokens"
    err, data <- get url .timeout(deadline: 5000).end
    return cb err if err?
    model = JSON.parse data.text
    
    scanerall model, cb

module.exports = parser


#err, data <- parser
#console.log err if err?
#fs.write-file-sync "./etherscan/tokens.json", (JSON.stringify data, null, 2)
