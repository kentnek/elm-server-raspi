const raspi = require('raspi');
const { SoftPWM } = require('raspi-soft-pwm');
const { DigitalInput, LOW, HIGH } = require('raspi-gpio');

const OutputDeviceMap = new Map();

function attachMessageListener(worker) {
    if (!worker || !worker.ports) {
        throw Error("worker must be an Elm worker.")
    }

    if (!worker.ports.toRaspi || !worker.ports.fromRaspi) {
        throw Error("The provided Elm worker does not expose fromRaspi and toRaspi ports.")
    }

    raspi.init(() => {
        console.log("Raspi lib initialized from Elm.");
        initialize(worker.ports);
    });
}

function initialize({ fromRaspi, toRaspi }) {
    toRaspi.subscribe(({ command, ...rest }) => {
        try {
            if (command === "declare") declare(fromRaspi, rest);
            else if (command === "write") write(fromRaspi, rest);
            else console.error("Unknown command: " + command);
        } catch (err) {
            console.error(err);
            fromRaspi.send({ error: err.message });
        }

    });
}

function declare(fromRaspi, { type, name, ...params }) {
    if (type === "pwm") {
        if (OutputDeviceMap.has(name)) return fromRaspi.send({ error: `Device name '${name}' already exists.` });
        OutputDeviceMap.set(name, new SoftPWM(params.pin));

    } else if (type === "button") {
        const pushButton = new DigitalInput(params.pin);

        let prevTime = Date.now();

        pushButton.on("change", value => {
            const currentTime = Date.now();
            // Software debounce: 100ms
            if (currentTime - prevTime > 100) {
                fromRaspi.send({ button: name, value: pushButton.read() === HIGH });
            }
            prevTime = currentTime;
        });

    } else if (type === "rotary") {
        const { pinA, pinB } = params;

        const rotaryA = new DigitalInput(pinA);
        const rotaryB = new DigitalInput(pinB);

        let currentA = -1;
        let prevA = -1;

        setInterval(() => {
            currentA = rotaryA.read(); // Reads the "current" state of outputA

            // If the previous and the current state of outputA are different, 
            // a Pulse has occurred
            if (prevA !== -1 && currentA != prevA) {
                if (rotaryB.read() != currentA) {
                    fromRaspi.send({ rotary: name, action: "decrement" });
                } else {
                    fromRaspi.send({ rotary: name, action: "increment" });
                }
            }

            prevA = currentA;
        }, 1);

    }
}

function write(fromRaspi, { type, name, ...params }) {
    const device = OutputDeviceMap.get(name);

    if (!device) return fromRaspi.send({ error: `Output device name '${name}' does not exist.` });

    if (type === "pwm") {
        device.write(params.dutyCycle);
    }
}


module.exports = {
    attachMessageListener
}