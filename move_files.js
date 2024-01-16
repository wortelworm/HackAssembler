const {outputPrefix, outputSuffix, CPUCircuitsPath} = require('./constants');

const fs = require('fs');
fs.readdirSync('./')
    .filter((name) => name.startsWith(outputPrefix) && name.endsWith(outputSuffix))
    .forEach((name) => {
        fs.copyFileSync(name, CPUCircuitsPath + name);
    });

