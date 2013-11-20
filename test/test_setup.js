"use strict";

// require and configure chai
var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");

chai.should();
chai.use(chaiAsPromised);
require("mocha-as-promised")();

// create proper error stack traces by pointing to the relevant coffeescript lines
require('source-map-support').install();

// configure blanket to generate the test coverage
require('blanket')({
  pattern: '/lib/',
  "data-cover-never": ["node_modules", "test"]
});
