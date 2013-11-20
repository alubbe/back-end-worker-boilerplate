A simple boilerplate for a back-end worker
=================

Clone it and run npm install to get going. Run ```npm start``` or ```grunt``` to start your server.

Everything is written in CoffeeScript, but executed in JavaScript thanks to grunt.

# Features

## Automatic restart

Everytime your code is changed, grunt re-compiles your code from CoffeeScript to JavaScript and restarts your server.

## CoffeeLint

Your code will also be checked by CoffeeLint to keep code quality high.

## Debuggin with node-inspector

The node-inspector is included right out of the box, so you can debug more efficiently.

## Super fast Promises

This boilerplates equips you with the fastest promises library on the market - bluebird. Now you really don't have a reason to use vanilla or async anymore.

## Tests and coverage reports

Just type ```npm test``` or ```grunt test``` to compile and run all test as well generate an html coverage report.

## Testing promises with sugar

To test your code, you can write nice code like ```promise.should.become "promise fulfilled"``` and ```promise.should.be.rejectedWith Error, "promise rejected"``` instead of calling

```javascript
promise.then (a) ->
  a.should.equal "promise fulfilled"
  done()
, (err) ->
  done err
```

and

```javascript
promise.then (a) ->
  done new Error "promise was fulfilled. Expected rejection"
, (err) ->
  a.message.should.equal "promise rejected"
  done()
```
