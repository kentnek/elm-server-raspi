const { rgb, hsl } = require('color-convert');

const STORE = {
    color: { h: 100, s: 60, l: 100 }
};

const LightValues = [0, 30, 60, 100];

function getColorAsHsl() {
    return STORE.color;
}

function getColorAsRgb() {
    const { color: { h, s, l } } = STORE;
    const [r, g, b] = hsl.rgb(h, s, l);
    return { r, g, b }
}

function setColor(color) {
    STORE.color = color;
}

function setHue(hue) {
    STORE.color.h = hue;
}

function rotateLight() {
    let index = LightValues.indexOf(STORE.color.l);
    STORE.color.l = LightValues[(l + 1) % LightValues.length];
}

module.exports = {
    getColorAsHsl, getColorAsRgb, setColor, setHue, rotateLight
}