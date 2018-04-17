const path = require('path');

const CleanWebpackPlugin = require('clean-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    entry: {
        app: path.resolve(__dirname, '../src/static/index.js')
    },

    output: {
        path: path.resolve(__dirname, '../dist/ui'),
        filename: `static/js/[name].bundle.js`,
    },

    resolve: {
        extensions: ['.js', '.elm'],
        modules: ['node_modules']
    },

    module: {
        noParse: /\.elm$/,
        rules: [
            {
                test: /\.(eot|ttf|woff|woff2|svg)$/,
                use: 'file-loader?publicPath=../../&name=static/css/[hash].[ext]'
            }
        ]
    },

    plugins: [
        new CleanWebpackPlugin("dist/ui", {
            root: path.join(__dirname, '..'),
        }),

        new HtmlWebpackPlugin({
            favicon: 'src/favicon.ico',
            template: 'src/static/index.html',
            inject: 'body',
            filename: 'index.html'
        })
    ],

    stats: {
        children: false
    }
};