const WebSocket = require('ws');

const isProduction = process.env.NODE_ENV === "production";

const raspi = require(isProduction ? './raspi' : './raspi-mock');
const store = require("./store");

const EventEmitter = require('events');
const buttonEventEmitter = new EventEmitter();

function onSocketConnection(wss, socket) {
    socket.sendColor = () => socket.send(JSON.stringify(store.getColorAsHsv()));

    socket.sendColor();

    const eventCallback = (event) => {
        socket.sendColor();
    };

    socket.on('close', function () {
        buttonEventEmitter.removeListener('button', eventCallback);
    });

    socket.on('message', function (data) {
        store.setHue(parseInt(data));
        raspi.updateColor(store.getColorAsRgb());

        wss.clients.forEach((client) => {
            if (client !== socket && client.readyState === WebSocket.OPEN) {
                client.sendColor();
            }
        });
    });

    buttonEventEmitter.on('button', eventCallback);
}


raspi.init(() => {
    const wss = new WebSocket.Server({ port: 2001 });
    wss.on('connection', socket => onSocketConnection(wss, socket));
    raspi.updateColor(store.getColorAsRgb());

    raspi.listen(event => {
        if (event === "push_button") {
            store.rotateValue();
        } else if (event === "rotary_increase") {
            store.addHue(2);
        } else if (event === "rotary_decrease") {
            store.addHue(-2);
        }

        raspi.updateColor(store.getColorAsRgb());
        buttonEventEmitter.emit("button", event);
    });

    console.log("Socket listening at :2001");
});


