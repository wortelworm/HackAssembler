# Quickstart
Make sure you have [The Bool Tool](https://git.science.uu.nl/0069795/digitallogicsimulator) installed
on your computer. TODOs more instructions on how to do stuff


# About
This project is a recreation of the [hack computer](https://en.wikipedia.org/wiki/Hack_computer)
inside [The Bool Tool](https://git.science.uu.nl/0069795/digitallogicsimulator). It includes a bunch
of circuits that create the cpu, an assembler that can convert .hack files into .bool files and some
programs to show off what this cpu can do. By default, the snake ROM is used in the cpu.

# Notes
The files in the tmp folder can be used to debug the program,
as every line corresponds exactly with one instruction.

There are some slight differences from the reference, namely:

To use user defined symbols like @i, a command is required to reserve this global variable:
    $ name: NumberOf16BitValues

The default registers (R0 to R15) are not used and therefore not defined.

The screen is only 16x16 pixels in size and the ram holds only 64 addresses,
as more was not needed to create snake.

There is a new default symbol: @RANDOM.
This points to a memory address with a random value very cpu tick.

The KBD (keyboard) has also been configured differently.
KBD can have the values 0, 1, 2, 3 or 4 representing none, left, right, up and down respectivly.
