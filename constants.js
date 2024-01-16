
const outputPrefix = '-ROM ';
const outputSuffix = '.bool';

const RAMCapacity = 64;

const DefaultSymbols = new Map();
{
    // Virtual registers
    for (let i = 0; i < 16; i++) {
        DefaultSymbols.set('R' + i, i);
    }

    // Predefined pointers are not used (yet)

    // I/O pointers
    DefaultSymbols.set('SCREEN', 0x4000);
    DefaultSymbols.set('KBD', 0x6000);
}

const CPUCircuitsPath = '../DigitalLogicSimulator/DigitalLogicSimulator/data/CPUcircuits/'

module.exports = {
    outputPrefix,
    outputSuffix,
    RAMCapacity,
    DefaultSymbols,
    CPUCircuitsPath
}