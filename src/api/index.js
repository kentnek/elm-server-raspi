const Koa = require('koa');
const Router = require('koa-router');
const websockify = require('koa-websocket');

const app = websockify(new Koa());
const ws = new Router();

const raspi = require(NODE_ENV === "production" ? './raspi' : './raspi-mock');
const store = require("./store");

ws.get('/', (ctx, next) => {
    ctx.websocket.send(JSON.stringify(store.getColorAsHsl()));
});

ws.get('/hue', (ctx, next) => {
    ctx.websocket.on('message', function (hue) {
        store.setHue(hue);
        raspi.updateColor(store.getColorAsRgb());
    });
});

app.ws.use(ws.routes()).use(ws.allowedMethods());

console.log()

raspi.init(() => {
    app.listen(2001);
    console.log("Listening at :2001");
});


