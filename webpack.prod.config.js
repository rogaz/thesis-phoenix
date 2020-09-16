var path = require('path');
var webpack = require('webpack');
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');

module.exports = {
  entry: path.resolve(__dirname, './assets/js/thesis.js'),
  output: {
    path: path.resolve(__dirname, './priv/static'),
    filename: 'thesis.js'
  },
  module: {
    rules: [{
      test: /\.js$/,
      exclude: [
        path.resolve(__dirname, './node_modules/'),
        path.resolve(__dirname, './assets/vendor'),
      ],
      loader: 'babel-loader',
      query: {
        presets: [
          'react',
          'env',
        ]
      }
    },
    {
      test: /\.css$/,
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: 'css-loader',
      }),
    },
    {
      test: /\.(sass|scss)$/,
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: ['css-loader', 'sass-loader'],
      }),
    }]
  },
  plugins: [
    new ExtractTextPlugin({
      filename: 'thesis.css',
      allChunks: true,
    }),
    new OptimizeCssAssetsPlugin(),
    new webpack.optimize.UglifyJsPlugin(), //minify everything
    new webpack.optimize.AggressiveMergingPlugin()//Merge chunks
  ],
  resolve: {
    alias: {
      'react': 'preact-compat',
      'react-dom': 'preact-compat'
    }
  }
};
