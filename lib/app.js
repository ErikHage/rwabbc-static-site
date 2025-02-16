'use strict';

const express = require('express');
const path = require('path');
const favicon = require('serve-favicon');
const bodyParser = require('body-parser');

global.appRoot = path.resolve(__dirname);

const app = express();

// view engine setup
app.set('views', path.join(global.appRoot, 'views'));
app.set('view engine', 'ejs');

app.use(favicon(path.join(global.appRoot, 'public/images', 'favicon.ico')));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(express.static(path.join(global.appRoot, 'public')));

app.get('/', (req, res, next) => {
  res.render('index');
});

module.exports = app;
