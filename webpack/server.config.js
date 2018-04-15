const path = require('path');
const nodeExternals = require('webpack-node-externals')

const srcRelativePath = "../src/elm/api"
const srcPath = path.resolve(__dirname, srcRelativePath);
const outputPath = path.resolve(__dirname, "../dist");

module.exports = [{
    target: "node",
    mode: "development",
    entry: path.resolve(srcPath, "./index.js"),
    output: { path: outputPath, filename: "server.js" },
    externals: [nodeExternals()], // Prevent webpack from bundling node_modules' code
    resolve: {
        extensions: [".elm", ".js"]
    },
    module: {
        rules: [{
            test: /.elm$/,
            use: [{
                loader: 'elm-webpack-loader',
                options: {
                    verbose: true,
                    warn: true,
                    debug: true
                }
            }]
        }]
    }
}]