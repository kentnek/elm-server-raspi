const { rgb, hsl } = require('color-convert');

const STORE = {
    color: { h: 100, s: 60, l: 70 }
};

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

module.exports = {
    getColorAsHsl, getColorAsRgb, setColor, setHue
}