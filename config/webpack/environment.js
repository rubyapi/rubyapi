const { environment } = require('@rails/webpacker')
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');

environment.plugins.prepend(
  'MonacoWebpackPlugin',
  new MonacoWebpackPlugin()
)

module.exports = environment
