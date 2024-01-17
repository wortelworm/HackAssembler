
// this file will convert 24-bit rgb color into
// 15-bit rgb color used by the cpu

// in hex like 0xRrGgBb
const input = [0x38e299, 0xfe1313];

let result = input.map(color => {
    // extract colors
    let r = (color >> 16) & 0xFF;
    let g = (color >>  8) & 0xFF;
    let b = (color >>  0) & 0xFF;

    // turn 8-bit into 5-bit per channel
    r >>= 3;
    g >>= 3;
    b >>= 3;

    // combine them
    return (r << 0) | (g << 5) | (b << 10);
});

console.log(result);