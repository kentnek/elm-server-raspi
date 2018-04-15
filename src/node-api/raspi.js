const raspi = require('raspi');
const { SoftPWM } = require('raspi-soft-pwm');
const { DigitalInput, LOW, HIGH } = require('raspi-gpio');

const PIN = {
    LED: {
        r: 'GPIO17',
        g: 'GPIO27',
        b: 'GPIO22'
    },
    BUTTONS: {
        push: 'GPIO10',
        rotaryA: 'GPIO9',
        rotaryB: 'GPIO11'
    }
};


let LED = null;

function init(cb) {
    raspi.init(() => {
        console.log("Raspi lib initialized.");
        LED = mapObject(PIN.LED, (_, pin) => new SoftPWM(pin));
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

function listen(callback) {
    const pushButton = new DigitalInput(PIN.BUTTONS.push);
    const rotaryA = new DigitalInput(PIN.BUTTONS.rotaryA);
    const rotaryB = new DigitalInput(PIN.BUTTONS.rotaryB);

    pushButton.on("change", value => {
        if (value === HIGH) callback("push_button");
    });

    let currentA = -1;
    let prevA = -1;

    return setInterval(() => {
        currentA = rotaryA.read(); // Reads the "current" state of outputA

        // If the previous and the current state of outputA are different, 
        // a Pulse has occurred
        if (prevA === -1 || currentA != prevA) {
            if (rotaryB.read() != currentA) {
                callback("rotary_decrease");
            } else {
                callback("rotary_increase");
            }
        }

        prevA = currentA;
    }, 1);
}

module.exports = {
    init, updateColor, listen
}