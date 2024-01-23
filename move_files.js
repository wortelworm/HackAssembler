const {outputPrefix, outputSuffix} = require('./constants');

const fs = require('fs');

function moveFiles() {
    fs.readdirSync('./circuits/').forEach(name => {
        if (name.startsWith(outputPrefix) && name.endsWith(outputSuffix)) {
            fs.rmSync('./circuits/' + name);
        }
    });

    fs.readdirSync('./target/').forEach(name => {
        if (name.startsWith(outputPrefix) && name.endsWith(outputSuffix)) {
            fs.copyFileSync('./target/' + name, './circuits/' + name);
        }

    });
}

module.exports = {moveFiles};

