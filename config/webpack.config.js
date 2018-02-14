const webpack = require("webpack");
const path = require("path");

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist')
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
  devServer: {
    contentBase: "./dist",
    port: 8080,
  },
  watch: true,
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