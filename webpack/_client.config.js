const path = require('path');
const webpack = require('webpack');
const merge = require('webpack-merge');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const prod = 'production';
const dev = 'development';

// determine build env
const TARGET_ENV = process.env.npm_lifecycle_event === 'build-ui' ? prod : dev;
const isDev = TARGET_ENV == dev;
const isProd = TARGET_ENV == prod;

// entry and output path/filename variables
const entryPath = path.join(__dirname, '../src/static/index.js');
const outputPath = path.join(__dirname, '../dist');
const outputFilename = isProd ? '[name]-[hash].js' : '[name].js'

console.log('Building for ' + TARGET_ENV);

// common webpack config (valid for dev and prod)
const commonConfig = {
    output: {
        path: outputPath,
        filename: `static/js/${outputFilename}`,
    },
    resolve: {
        extensions: ['.js', '.elm'],
        modules: ['node_modules']
    },
    module: {
        noParse: /\.elm$/,
        rules: [{
            test: /\.(eot|ttf|woff|woff2|svg)$/,
            use: 'file-loader?publicPath=../../&name=static/css/[hash].[ext]'
        }]
    },
    watchOptions: {
        ignored: [
            /node_modules/,
            /elm-stuff/
        ]
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: 'src/static/index.html',
            inject: 'body',
            filename: 'index.html'
        })
    ]
}

// additional webpack settings for local env (when invoked by 'npm start')
if (isDev === true) {
    module.exports = merge(commonConfig, {
        mode: dev,
        entry: [
            'webpack-dev-server/client?http://localhost:2000',
            entryPath
        ],
        devServer: {
            // serve index.html in place of 404 responses
            historyApiFallback: true,
            contentBase: path.join(__dirname, '../src'),
            hot: true,

            port: 2000,
            host: '0.0.0.0'
        },
        module: {
            rules: [{
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                use: [{
                    loader: 'elm-webpack-loader',
                    options: {
                        // verbose: true,
                        // warn: true,
                        // debug: true
                    }
                }]
            }, {
                test: /\.sc?ss$/,
                use: ['style-loader', 'css-loader', 'sass-loader']
            }]
        }
    });
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if (isProd === true) {
    module.exports = merge(commonConfig, {
        mode: prod,
        entry: entryPath,
        module: {
            rules: [{
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                use: 'elm-webpack-loader'
            }, {
                test: /\.sc?ss$/,
                use: ExtractTextPlugin.extract({
                    fallback: 'style-loader',
                    use: ['css-loader', 'sass-loader']
                })
            }]
        },
        plugins: [
            // extract CSS into a separate file
            new ExtractTextPlugin({
                filename: 'static/css/[name]-[contenthash].css',
                allChunks: true,
            }),

            new CopyWebpackPlugin([{
                from: './src/static/img/',
                to: 'static/img/'
            }, {
                from: '../src/favicon.ico'
            }]),


            // // minify & mangle JS/CSS
            // new webpack.optimize.UglifyJsPlugin({
            //     minimize: true,
            //     compressor: {
            //         warnings: false
            //     }
            //     // mangle:  true
            // })
        ]
    });
}
