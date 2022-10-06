const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const jquery = require('./plugins/jquery')

environment.plugins.prepend('jquery', jquery)
module.exports = environment
