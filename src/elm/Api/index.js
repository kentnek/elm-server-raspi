const Ews = require("elm-web-server");
const Ws = require("ws");

const PORT = process.env.PORT || 2002;
const WebsocketServer = new Ws.Server({ port: PORT });

const Raspi = require("./raspi");

const App = require("./Main");
const worker = App.Api.Main.worker();

Ews.attachMessageListener(worker, WebsocketServer);
Raspi.attachMessageListener(worker);

console.log(`Socket listening at :${PORT}`);