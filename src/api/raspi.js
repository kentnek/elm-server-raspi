const raspi = require('raspi');
const { SoftPWM } = require('raspi-soft-pwm');
const { DigitalInput, LOW, HIGH } = require('raspi-gpio');

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

function listenButtons(callback) {
    const pushButton = new DigitalInput('GPIO4');
    const rotaryA = new DigitalInput('GPIO23');
    const rotaryB = new DigitalInput('GPIO24');

    pushButton.on("change", value => {
        if (value === HIGH) callback("push_button");
    });

    let currentA = -1;
    let prevA = -1;

    return setInterval(() => {
        currentA = rotaryA.read(); // Reads the "current" state of outputA

        // If the previous and the current state of outputA are different, 
        // a Pulse has occurred
        if (currentA != prevA) {
            if (rotaryB.read() != currentA) {
                callback("rotary-increase");
            } else {
                callback("rotary-decrease");
            }
        }

        prevA = currentA;
    }, 10);
}

module.exports = {
    init, updateColor, listenButtons
}