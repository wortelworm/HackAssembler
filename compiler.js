const {RAMCapacity, DefaultSymbols} = require('./constants');


function MapDestination(word) {
    if (word == 'null') {
        return 0b000;
    }

    let result = 0b000;
    for (let i = 0; i < word.length; i++) {
        let newly;
        switch (word[i]) {
            case 'M':
                newly = 0b001;
                break;
            case 'D':
                newly = 0b010;
                break;
            case 'A':
                newly = 0b100;
                break;
            default:
                return null;
        }

        if ((newly & result) != 0) {
            return null;
        }
        result |= newly;
    }

    return result;
}

function MapJumpination(word) {
    switch(word) {
        case 'null':
            return 0b000;
        case 'JGT':
            return 0b001;
        case 'JEQ':
            return 0b010;
        case 'JGE':
            return 0b011;
        case 'JLT':
            return 0b100;
        case 'JNE':
            return 0b101;
        case 'JLE':
            return 0b110;
        case 'JMP':
            return 0b111;
        default:
            return null;
    }
}

function MapComputation(word) {
    // A, ZD, ND, ZA, NA, f, NO
    switch (word) {
        case '0':
            return 0b0101010;
        case '1':
            return 0b0111111;
        case '-1':
            return 0b0111010;
        case 'D':
            return 0b0001100;
        case 'A':
            return 0b0110000;
        case '!D':
            return 0b0001101;
        case '!A':
            return 0b0110001;
        case '-D':
            return 0b0001111;
        case '-A':
            return 0b0110011;
        case 'D+1':
            return 0b0011111;
        case 'A+1':
            return 0b0110111;
        case 'D-1':
            return 0b0001110;
        case 'A-1':
            return 0b0110010;
        case 'D+A':
        case 'A+D':
            return 0b0000010;
        case 'D-A':
            return 0b0010011;
        case 'A-D':
            return 0b0000111;
        case 'D&A':
        case 'A&D':
            return 0b0000000;
        case 'A|D':
            return 0b0010101;

        case 'M':
            return 0b1110000;
        case '!M':
            return 0b1110001;
        case '-M':
            return 0b1110011;
        case 'M+1':
            return 0b1110111;
        case 'M-1':
            return 0b1110010;
        case 'D+M':
        case 'M+D':
            return 0b1000010;
        case 'D-M':
            return 0b1010011;
        case 'M-D':
            return 0b1000111;
        case 'D&M':
        case 'M&D':
            return 0b1000000;
        case 'M|D':
            return 0b1010101;


        default:
            return null;
    }
}



/**
 * Converts the hack file binary code
 * @param {String} input
 * @returns {number[]}
 */
function compile(input, fileName) {
    input = input.toString();

    let binary = [];
    /**
     * name -> pointer
     */
    let Pointers = new Map(DefaultSymbols);

    let RAMFreePointer = 16;

    /**
     * 
     * @param {String} line 
     * @param {Number} lineNumber 
     * @returns 
     */
    function handleLine(line, lineNumber, fileName) {
        function error(msg) {
            throw `Error in ${fileName} at line ${lineNumber}: ${msg}`;
        }

        if (line[0] == '@') {
            let expression = line.substring(1);
            let number = Number.parseInt(expression);
            if (isNaN(number)) {
                // literal
                if (!Pointers.has(expression)) {
                    // delay to later
                    binary.push(expression);
                    return;
                }
                number = Pointers.get(expression);
            }
            if (number >= 2**15) {
                error(`The number ${number} is to large, it can be at most ${2**15 -1}`);
            }
            if (number < 0) {
                error(`Numbers in A instructions cannot be negative`);
            }
            binary.push(number);
            return;
        }

        if (line[0] == '(') {
            if (line.at(-1) != ')') {
                error('Expected a ) and the end of this line');
            }

            let name = line.substring(1, line.length-1);
            if (Pointers.has(name)) {
                error(`The name ${name} has already been defined`);
            }
            if (name[0] >= '0' && name[0] <= '9') {
                error(`Names cannot start with a number`);
            }

            // misschien moet deze +1 of -1
            let location = binary.length;
            Pointers.set(name, location);
            return;
        }

        if (line[0] == '$') {
            let split = line.substring(1).split(':');
            if (split.length != 2) {
                error(`Expected exactly 1 ':' in this line`)
            }
            let name = split[0];
            let count = Number.parseInt(split[1]);
            if (name[0] >= '0' && name[0] <= '9') {
                error(`Names cannot start with a number`);
            }
            if (isNaN(count) || count <= 0) {
                error(`Expected a number larger than 0 after the ':'`)
            }
            let location = RAMFreePointer;
            Pointers.set(name, location);

            RAMFreePointer += count;
            if (RAMFreePointer > RAMCapacity) {
                error('Ran out of RAM ...');
            }
            return;
        }


        // normal thing:
        // dest=comp;jump
        {
            let split = line.split('=');
            if (split.length > 2) {
                error(`At most one '=' is allowed`);
            }

            let dest;
            if (split.length == 1) {
                dest = 'null';
            } else {
                dest = split[0];
                line = split[1];
            }

            split = line.split(';');
            if (split.length > 2) {
                error(`At most one ';' is allowed`);
            }

            let comp = split[0];
            let jump = split[1] ?? 'null';
            

            let destination = MapDestination(dest);
            let computation = MapComputation(comp);
            let jumpination = MapJumpination(jump);

            if (destination == null) {
                error(`Unknown destination '${dest}'!`)
            }
            if (computation == null) {
                error(`Unknown computation '${comp}'!`)
            }
            if (jumpination == null) {
                error(`Unknown jumpination '${jump}'!`)
            }

            let code = 0b1110000000000000;
            code |= computation << 6;
            code |= destination << 3;
            code |= jumpination << 0;
            
            binary.push(code);
        }
    }

    // normalize line endings
    input = input.replaceAll('\r\n', '\n');
    input = input.replaceAll('\r', '\n');

    let tmps = '';

    let lines = input.split('\n');
    for (let lineNumber = 0; lineNumber < lines.length; lineNumber++) {
        let line = lines[lineNumber];
        line = line.replaceAll(' ', '');
        line = line.replaceAll('\t', '');

        let commentPos = line.indexOf('//');
        if (commentPos >= 0) {
            line = line.substring(0, commentPos);
        }

        if (line == '') {
            continue;
        }

        if (line[0] != '$' && line[0] != '(')
            tmps += line + '\r\n';

        handleLine(line, lineNumber, fileName);
    }

    require('fs').writeFileSync(`./tmp/${fileName.split('.')[0]}.tmp`, tmps);

    for (let i = 0; i < binary.length; i++) {
        if (isNaN(binary[i])) {
            let name = binary[i];
            if (! Pointers.has(name)) {
                throw `Unknown literal name: ${name}`;
            }
            binary[i] = Pointers.get(name);
        }
    }

    return binary;
}

module.exports = { compile }