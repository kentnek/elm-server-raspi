let LED = null;

function init(cb) {
    console.log("Mock: Init");
    cb();
}

function updateColor(rgb) {
    console.log("Set color to " + JSON.stringify(rgb));
}

module.exports = {
    init, updateColor
}