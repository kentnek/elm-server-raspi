const raspi = require('raspi');
const { SoftPWM } = require('raspi-soft-pwm');

const PIN = {
    r: 'GPIO17',
    g: 'GPIO27',
    b: 'GPIO22',
};

let LED = null;

function init(cb) {
    raspi.init(() => {
        console.log("Raspi lib initialized.");
        LED = mapObject(PIN, (_, pin) => new SoftPWM(pin));
        cb();
    });
}

function mapObject(domain, fn) {
    const ret = {};
    for (let key of Object.keys(domain)) {
        ret[key] = fn(key, domain[key]);
    }
    return ret;
}

function writeLed(led, byte) {
    if (byte < 0 || byte > 255) return;
    led.write(1 - byte / 255);
}

function updateColor(rgb) {
    mapObject(LED, (color, led) => writeLed(led, rgb[color]));
}

module.exports = {
    init, updateColor
}