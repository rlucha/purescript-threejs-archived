const webpack = require("webpack");
const path = require("path");

module.exports = {
  entry: './index.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, '..', 'dist')
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
  watchOptions: {
    aggregateTimeout: 300,
    poll: 1000,
    ignored: /node_modules/
  },  
  plugins: [
    new webpack.HotModuleReplacementPlugin()
  ],
  mode: "development"
}