const path = require('path');

const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");

const merge = require('webpack-merge');
const common = require('./client.common.js');


module.exports = merge(common, {
    mode: "production",

    module: {
        rules: [
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                // This is what you need in your own work
                use: "elm-webpack-loader"
            },
            {
                test: /\.sc?ss$/,
                use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader']
            }
        ]
    },

    plugins: [
        new MiniCssExtractPlugin({
            filename: "static/css/[name].css",
            chunkFilename: "[id].css"
        })
    ],

    optimization: {
        minimizer: [
            new UglifyJsPlugin({
                cache: true,
                parallel: true,
                sourceMap: false // set to true if you want JS source maps
            }),

            new OptimizeCSSAssetsPlugin({})
        ]
    }
});