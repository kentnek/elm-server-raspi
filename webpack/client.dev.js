const path = require('path');
const merge = require('webpack-merge');

const common = require('./client.common.js');

module.exports = merge(common, {
    mode: "development",

    module: {
        rules: [
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                // This is what you need in your own work
                use: [{
                    loader: "elm-webpack-loader",
                    options: {
                        verbose: true,
                        warn: true,
                        debug: true
                    }
                }]
            },

            {
                test: /\.sc?ss$/,
                use: ['style-loader', 'css-loader', 'sass-loader']
            }
        ]
    },

    devServer: {
        contentBase: path.join(__dirname, '../src'),
        inline: true,
        hot: true,
        port: 2000,
        host: '0.0.0.0'
    },

    watchOptions: {
        ignored: [
            /node_modules/,
            /elm-stuff/
        ]
    }
});