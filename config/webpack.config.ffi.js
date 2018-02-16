const webpack = require("webpack");
const path = require("path");

module.exports = {
  entry: './src/ffi/three_.js',
  output: {
    filename: 'three.js',
    path: path.resolve(__dirname,'..', './src/ffi/'),
    library: 'fii',
    libraryTarget: 'commonjs'
  },
  module: {
    rules: [
      {test: /\.(js|jsx)$/, use: "babel-loader"},
    ]
  },
  resolve: {
    modules: ["node_modules", "output"],
    extensions: [".js", ".json", ".re", ".ml"]
  },  
  mode: "development"
}