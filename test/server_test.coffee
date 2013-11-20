"use strict"

server = require '../../lib/server'
Promise = require 'bluebird'
Promise.longStackTraces()

describe 'server.', ->

  describe 'delay()', ->
    this.timeout 50

    it 'should not be faster than setTimeout', (done) ->
      setTimeout_is_done = false

      setTimeout ->
        setTimeout_is_done = true
      , 20

      server.delay 30, ->
        setTimeout_is_done.should.be.true
        done()

    it 'should not be slower than setTimeout', (done) ->
      delay_is_done = false

      server.delay 20, ->
        delay_is_done = true

      setTimeout ->
        delay_is_done.should.be.true
        done()
      , 30

  describe 'delayP()', ->
    this.timeout 50

    it 'should not be faster than delay', (done) ->
      delayP_is_done = false

      server.delayP(20).then ->
        delayP_is_done = true

      server.delay 40, ->
        delayP_is_done.should.be.true
        done()

    it 'should not be slower than delay', ->
      delay_is_done = false

      server.delay 20, ->
        delay_is_done = true

      server.delayP(30).then ->
        delay_is_done.should.be.true

  describe 'tryUpToNTimes()', ->
    this.timeout 100

    # mock promises to test tryUpToNTimes()
    mock_alwaysResolves = ->
      server.delayP(10).then ->
        "promise fulfilled"

    mock_alwaysRejects = ->
      server.delayP(10).then ->
        throw new Error("promise rejected")

    mock_resolvesTheThirdTime = (a, b, c) ->
      server.delayP(10).then ->
        callCount_resolvesTheThirdTime++

        if callCount_resolvesTheThirdTime % 3 is 0
          if a? and b? and c?
            return a + b + c
          else
            return "promise fulfilled"
        else
          return throw new Error("promise rejected")

    callCount_resolvesTheThirdTime = 0

    #testing starts here
    it 'should resolve successful functions immediately', (done) ->
      server.tryUpToNTimes(mock_alwaysResolves, null, 5).should.become "promise fulfilled"

    it 'should reject unsuccessful functions', ->
      server.tryUpToNTimes(mock_alwaysRejects, null, 5).should.be.rejectedWith Error, "promise rejected"

    it 'should execute the iterations sequentially', ->
      thirty_ms_have_passed = false

      server.delay 30, ->
        thirty_ms_have_passed = true

      server.tryUpToNTimes(mock_alwaysRejects, null, 4).catch ->
        thirty_ms_have_passed.should.be.true
        # otherwise executing 4 sequential 10ms delays took less than 30ms

    it 'should reject a promise that only works the third time if n is 2', ->
      callCount_resolvesTheThirdTime = 0

      server.tryUpToNTimes(mock_resolvesTheThirdTime, null, 2).should.be.rejectedWith Error, "promise rejected"

    it 'should resolve a promise that only works the third time if n is 3', ->
      callCount_resolvesTheThirdTime = 0

      server.tryUpToNTimes(mock_resolvesTheThirdTime, null, 3).should.become "promise fulfilled"

    it 'should pass arguments to the promise', ->
      callCount_resolvesTheThirdTime = 0

      server.tryUpToNTimes(mock_resolvesTheThirdTime, "great success here".split(" "), 4).should.become "greatsuccesshere"
