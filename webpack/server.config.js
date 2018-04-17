const path = require('path');
const nodeExternals = require('webpack-node-externals')

module.exports = [{
    target: "node",
    mode: "development",

    entry: path.resolve(__dirname, "../src/elm/Api/index.js"),

    output: {
        path: path.resolve(__dirname, "../dist"),
        filename: "elm-server.js"
    },

    externals: [
        // Prevent webpack from bundling packages from node_modules
        // and raspi-related modules
        nodeExternalsIncluding("raspi", "raspi-gpio", "raspi-soft-pwm")
    ],

    resolve: {
        extensions: [".elm", ".js"]
    },

    module: {
        rules: [{
            test: /.elm$/,
            use: 'elm-webpack-loader'
        }]
    }
}]

// Patch nodeExternals to include raspi-related modules
// to prevent "Module not found: Error: Can't resolve 'raspi-X'" errors.
function nodeExternalsIncluding(...modules) {
    const extenals = nodeExternals();
    return function (context, request, callback) {
        if (modules.includes(request)) {
            return callback(null, 'commonjs ' + request);
        } else {
            extenals(context, request, callback);
        }
    }
}