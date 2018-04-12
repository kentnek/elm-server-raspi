const Koa = require('koa');
const Router = require('koa-router');
const websockify = require('koa-websocket');

const app = websockify(new Koa());
const ws = new Router();

const isProduction = process.env.NODE_ENV === "production";

const raspi = require(isProduction ? './raspi' : './raspi-mock');
const store = require("./store");

const EventEmitter = require('events');
const buttonEventEmitter = new EventEmitter();

ws.get('/', (ctx, next) => {
    ctx.websocket.send(JSON.stringify(store.getColorAsHsl()));

    ctx.websocket.on('close', function (hue) {
        store.setHue(parseInt(hue));
        raspi.updateColor(store.getColorAsRgb());
    });

    buttonEventEmitter.on('button', (event) => {
        console.log(event);
    });
});

ws.get('/hue', (ctx, next) => {
    ctx.websocket.on('message', function (hue) {
        store.setHue(parseInt(hue));
        raspi.updateColor(store.getColorAsRgb());
    });
});

app.ws.use(ws.routes()).use(ws.allowedMethods());

raspi.init(() => {
    app.listen(2001);
    raspi.updateColor(store.getColorAsRgb());

    raspi.listen(event => {
        if (event === "push_button") {
            store.rotateLight();
        } else if (event === "rotary_increase") {

        } else if (event === "rotary_decrease") {

        }

        raspi.updateColor(store.getColorAsRgb());
        buttonEventEmitter("button", event);
    });

    console.log("Listening at :2001");
});


