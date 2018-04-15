const { rgb, hsv } = require('color-convert');

const STORE = {
    color: { h: 100, s: 60, v: 100 }
};

const LightValues = [0, 30, 60, 100];

function getColorAsHsv() {
    return STORE.color;
}

function getColorAsRgb() {
    const { color: { h, s, v } } = STORE;
    const [r, g, b] = hsv.rgb(h, s, v);
    return { r, g, b }
}

function setColor(color) {
    STORE.color = color;
}

function setHue(hue) {
    STORE.color.h = hue;
}

function addHue(hue) {
    const newValue = STORE.color.h + hue;
    STORE.color.h = ((newValue % 360) + 360) % 360; // handle negative mod
}


function rotateValue() {
    let index = LightValues.indexOf(STORE.color.v);
    STORE.color.v = LightValues[(index + 1) % LightValues.length];
}

module.exports = {
    getColorAsHsv, getColorAsRgb, setColor, setHue, rotateValue, addHue
}