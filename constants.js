
const outputPrefix = '-ROM ';
const outputSuffix = '.bool';

const RAMCapacity = 64;

const DefaultSymbols = new Map();
{
    // I/O pointers
    DefaultSymbols.set('SCREEN', 0x4000);
    DefaultSymbols.set('KBD', 0x6000);
    DefaultSymbols.set('RANDOM', 0x7000);
}

module.exports = {
    outputPrefix,
    outputSuffix,
    RAMCapacity,
    DefaultSymbols
}