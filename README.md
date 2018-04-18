# elm-server-raspi

A demo of an Internet-of-Things application, where both the frontend and backend are written in Elm.

The server, to be installed on a Raspberry Pi, controls a SparkFun RGB Rotary Encoder.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a Raspberry Pi.

### Prerequisites

- Node.js (latest version)
- Yarn (as a dependency manager, rather than NPM)

### Installing

1. Clone this project to a folder on your local machine, e.g. `~/elm-server-raspi`
2. Inside the folder, do `yarn install --ignore-optional` to install necessary dependencies
(except for those specific to Raspberry Pi).
3. Update the server's Websocket url in `/webpack/client.dev.js`.
4. To run the client locally with `webpack-dev-server`, do `yarn ui:start`. The client will be available at `localhost:2000`.
5. To build a live compressed version of the client, do `yarn ui:build`. The built client can be found in `dist/ui`.
6. To compile the Elm server to JavaScript, do `yarn api:build`. The build server can be found in `dist/api/elm-server.js`.

## Deployment
1. The scripts in `package.json` assumes that the Raspberry Pi is available in the same network at `pi@raspi`.
2. Do `yarn ui:deploy` to build the client and deploy it in `/var/www/html` on the Raspberry Pi.
3. Do `yarn api:deploy` to build the Elm server into `elm-server.js` and deploy to the Raspberry Pi.
4. On the Raspberry Pi, run `sudo node elm-server.js` (`sudo` is required) to start the server.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments
- [elm-collage](https://github.com/timjs/elm-collage/) - Elm vector graphics library
- [elm-web-server](https://github.com/opvasger/elm-web-server/) - An API with Node.js-bindings for Elm WebSocket/HTTP-servers
- [elm-webpack-loader](https://github.com/elm-community/elm-webpack-loader) - Webpack loader for the Elm language

