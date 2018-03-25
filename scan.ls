require! {
    \require-ls
    \./load.ls
    \prelude-ls : { map, concat, group-by, obj-to-pairs, map, sort-by, take, reverse }
}

[_, _, command, length] = process.argv

#return console.log command, length
#err, icos <- load \icos
#console.log icos
err, items <- load \participants

rating = 
    items |> map (.holders) 
          |> concat 
          |> group-by (.1) 
          |> obj-to-pairs 
          |> map (-> [it.0, it.1.length])
          |> sort-by (.1)
          |> reverse
          |> take length
transform = ([address, index])->
    "#{index} | #{address}"
console.log rating.map(transform).join(\\n)
          
