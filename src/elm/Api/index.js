const ElmServer = require("elm-web-server");
const ElmRaspi = require("./Lib/elm-raspi");
const Ws = require("ws");

const PORT = process.env.PORT || 2002;
const WebsocketServer = new Ws.Server({ port: PORT });

const worker = require("./Main").Api.Main.worker();

ElmServer.attachMessageListener(worker, WebsocketServer);
ElmRaspi.attachMessageListener(worker);

console.log(`Socket listening at :${PORT}`);