module.exports = {
  module: {
    rules: [
      {test: /\.(js|jsx)$/, use: "babel-loader"},
    ]
  },
  resolve: {
    modules: ["node_modules", "output"],
    extensions: [".js", ".json", ".re", ".ml"]
  },  
}