const {outputPrefix, outputSuffix, CPUCircuitsPath} = require('./constants');

const fs = require('fs');

function moveFiles() {
    fs.readdirSync('./target/')
        .filter((name) => name.startsWith(outputPrefix) && name.endsWith(outputSuffix))
        .forEach((name) => {
            fs.copyFileSync('./target/' + name, CPUCircuitsPath + name);
        });
}

module.exports = {moveFiles};

