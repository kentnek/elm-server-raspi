// pull in desired CSS/SASS files
require('./styles/main.scss');

// inject bundled Elm app into div#main
var Elm = require('../elm/ui/Main');

// console.log("Websocket Url = " + WEBSOCKET_URL);

Elm.Ui.Main.embed(
    document.getElementById('main'),
    {
        hostname: location.host + location.pathname,
        wsUrl: WEBSOCKET_URL
    }
);
