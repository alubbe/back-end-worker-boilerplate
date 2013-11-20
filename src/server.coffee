"use strict"

Promise = require 'bluebird'

###
    YOUR CODE GOES BELOW. BELOW ARE SOME FUN FUNCTIONS THAT YOU CAN
    READ FOR YOUR OWN ENJOYMENT AND THEN REMOVE THEM TO GET STARTED
###

# simple rewrite of setTimeout to be easier to use with CoffeeScript
exports.delay = (ms, func, args) ->
  setTimeout func, ms, args

# a timeout that returns a promise
exports.delayP = (ms) ->
  new Promise (f) ->
    setTimeout f, ms

# tryUpToNTimes will execute a given promise up to n times until it is resolved. If the promise is rejected n times, tryUpToNTimes will also reject.
# Takes three arguments. The promise function, the arguments to be passed in as an array and the number of iterations
exports.tryUpToNTimes = (promise, args, n, i, deferred) ->
  i ?= 0
  deferred ?= Promise.pending()

  promise.apply(this, args).then (a) ->
    deferred.fulfill(a)
  , (err) ->
    i++

    if i is n
      return deferred.reject err
    exports.tryUpToNTimes promise, args, n, i, deferred

  deferred.promise

http = require 'http'

server = http.createServer (req, res) ->
  res.writeHead 200,
    'Content-Type': 'text/plain'

  console.log "received a request"

  exports.delayP(1000).then ->
    res.end 'Hello Node.js Meetup\n'

server.listen 1337, '127.0.0.1'

console.log 'Server running at http://127.0.0.1:1337/'
