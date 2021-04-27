"use strict";

var express = require('express');

var port = 4000;
var app = express();
app.listen(port);
console.log("Server running at http://localhost: ".concat(port));
app.get('/', function (req, res) {
  var name = process.env.NAME || 'Proof of Modification by Eric Gip';
  res.send("Hello ".concat(name, "! Proof of Modification by Eric Gip"));
});