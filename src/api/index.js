const Koa = require('koa');
const Router = require('koa-router');
const websockify = require('koa-websocket');

const app = websockify(new Koa());
const ws = new Router();

const isProduction = process.env.NODE_ENV === "production";

const raspi = require(isProduction ? './raspi' : './raspi-mock');
const store = require("./store");

ws.get('/', (ctx, next) => {
    console.log("Client connected, sending color...");
    ctx.websocket.send(JSON.stringify(store.getColorAsHsl()));
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
    console.log("Listening at :2001");
});


