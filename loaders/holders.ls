require! {
    \superagent : { get }
    \cheerio : { load }
}

transform-cell = ($)-> (index, cell)->
    $(cell).text!
    #console.log $(cell).text!
    $(cell).text!
transform-row = ($) -> (index, item)->
    return [$(item).find('td').map(transform-cell $).to-array!]
    
download = (address, page, cb)->
    err, data <- get "https://etherscan.io/token/generic-tokenholders2?a=#{address}&s=1.25E%2b26&p=#{page}" .end
    process.stdout.write \.
    return cb err if err?
    $ = load data.text
    return cb null, [] if data.text.index-of('There are no matching entries') > -1
    result = $('#maintable tr').map(transform-row $).to-array!.filter(-> it.length > 0)
    return cb null, [] if result.length is 0
    err, rest <- download address, page + 1
    return cb err if err?
    all = result ++ rest
    cb null, all

module.exports = (address, cb)-> 
    download address, 0, cb