const fs = require('fs');
const {outputPrefix, outputSuffix} = require('./constants');
const {compile} = require('./compiler');
const {assemble} = require('./assembler');
const {moveFiles} = require('./move_files');



function convertAll() {
    fs.readdirSync('./target/')
        .forEach((fileName) => {
            fs.rmSync('./target/' + fileName);
        });

    let files = fs.readdirSync('./src/');

    files.forEach((fileName) => {
        let contents = fs.readFileSync('./src/' + fileName);

        let compiled = compile(contents, fileName);
        let assembled = assemble(compiled, fileName);
    
        let outputFile = outputPrefix + fileName.split('.')[0] + outputSuffix;
    
        fs.writeFileSync('./target/' + outputFile, assembled);
    });
}

try {
    convertAll();
    moveFiles();
    console.log('Did everything successfully!')
} catch(e) {
    console.error(e);
}


