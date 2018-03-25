require! {
    \require-ls
    \./load.ls
}

[_, _, command, length] = process.argv

#return console.log command, length
#err, icos <- load \icos
#console.log icos

err, items <- load \participants
console.log items