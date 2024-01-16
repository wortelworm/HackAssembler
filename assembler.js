

/**
 * Converts binary code to circuit, todos
 * @param {number[]} binary 
 * @param {string} inputFile
 * @returns 
 */
function assemble(binary, inputFile) {
    let circuit = `
{0,Comment,{11,-7},This ROM circuit is automaticly generated\\, it represents ${inputFile}},
{1,Input,{11,2},{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}},
{2,NOT,{16,20},{{1,0}}},
{3,Split,{21,2},{{1,0}}},
{4,Split,{21,20},{{2,0}}},
{5,OR,{39,-2},{{},{}}},
{6,NOT,{43,-2},{{}}},
`;

    const InputIndex = 1;

    const InstructionsWidth = 10;
    const MaxAdressWidth = Math.ceil(Math.log2(binary.length))+2;

    const NormalSplit = 3;
    const InvertedSplit = 4;

    const FalseValue = 5;
    const TrueValue = 6;

    let nextOperatorIndex = 7;
    let binaryIndex = 0;

    let previousInstructionResult = -1;

    let addressReusable = [];

    function AddInstruction(x, y) {
        let address = binaryIndex;
        binaryIndex++;
        
        // address selection
        let addressResult = null;
        let largest = MaxAdressWidth-1;

        // possibly reuse previous stuff
        if (address > 0)
        {
            let diff = address ^ (address-1);
            let count = Math.log2(diff+1);

            largest = count-1;
            addressResult = addressReusable[count];
        }

        for (let i = largest; i >= 0; i--) {
            let addressBit = (address & (1 << i)) != 0;
            let addressStr = `{${addressBit ? NormalSplit : InvertedSplit},${i}}`;
            if (addressResult == null) {
                addressResult = addressStr;
                continue;
            }

            circuit += `{${nextOperatorIndex},AND,{${x+4},${y-(i+1)*4}},{${addressResult},${addressStr}}},\n`;
            addressResult = `{${nextOperatorIndex},0}`;
            addressReusable[i] = addressResult;
            nextOperatorIndex++;
        }
        
        let str = '';
        let bin = binary[address];

        for (let i = 0; i < 16; i++) {
            let bit = (bin & (1 << i)) != 0;
            if (bit) {
                str += `{${TrueValue},0},`;
            } else {
                str += `{${FalseValue},0},`
            }
        }
        str = str.substring(0, str.length-1);

        circuit += `{${nextOperatorIndex},Join,{${x},${y}},{${str}}},\n`;
        nextOperatorIndex++;

        // the selection stuff
        let instructionResult = nextOperatorIndex;
        circuit += `{${nextOperatorIndex},AND,{${x+4},${y+6}},{{${nextOperatorIndex+1},0},{${nextOperatorIndex-1},0}}},\n`;
        nextOperatorIndex++;
        circuit += `{${nextOperatorIndex},wide16,{${x+4},${y+2}},{${addressResult}}},\n`;
        nextOperatorIndex++;

        // going to the output
        if (previousInstructionResult != -1) {
            // make an OR thingy
            circuit += `{${nextOperatorIndex},OR,{${x+InstructionsWidth},${y+18}},{{${instructionResult},0},{${previousInstructionResult},0}}},\n`
            instructionResult = nextOperatorIndex;
            nextOperatorIndex++;
        }
        previousInstructionResult = instructionResult;
    }

    let currentX = 45;
    let currentY = 50;

    for (let i = 0; i < binary.length; i++) {
        AddInstruction(currentX, currentY);

        currentX += InstructionsWidth;
    }

    // add output
    circuit += `{${nextOperatorIndex},Output,{48,-2},{{${previousInstructionResult},0}}},\n`

    circuit += `{IO,{${InputIndex}},{${nextOperatorIndex}}}`;
    return circuit;
}

module.exports = { assemble }