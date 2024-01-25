# About
This project is a recreation of the [hack computer](https://en.wikipedia.org/wiki/Hack_computer)
inside [The Bool Tool](https://git.science.uu.nl/0069795/digitallogicsimulator). It includes a bunch
of circuits that create the cpu, an assembler that can convert .hack files into .bool files and some
programs to show off what this cpu can do. By default, the snake ROM is used in the cpu.

# Quickstart
Make sure you have [The Bool Tool](https://git.science.uu.nl/0069795/digitallogicsimulator) installed on your computer. You need to download this repostory using `git clone` or by downloading and extracting this [zip](https://github.com/wortelworm/HackAssembler/zipball/master). Then you can configure The Bool Tool in the settings to use the [circuit](/circuits/) folder as your custom operator folder. Now you can open the [cpu](/circuits/CPU.bool) in The Bool Tool, set simulation speed to maximum and play snake.

If you want to compile your own programs to run on the cpu, make sure to write it in the [assembly language](https://en.wikipedia.org/wiki/Hack_computer#Assembly_language) compatible with this program. See the [notes](#notes) for the differences from this specification. Also make sure [node.js](https://nodejs.org/) is installed on your computer. You should place your programs in the [src](src/) directory. Running `node ./` in this folder will compile every file from the src directory and place it into the circuits. Open the cpu in The Bool Tool and replace the snake ROM with your newly created ROM. You can now run your program!


# Notes
There are some slight differences from the reference, namely:

To use user defined symbols like @i, a command is required to reserve this global variable:
    `$ name: NumberOf16BitValues`

The default registers (R0 to R15) are not used and therefore not defined.

The screen is only 16x16 pixels in size and the ram holds only 64 addresses,
as more was not needed to create snake.

There is a new default symbol: @RANDOM.
This points to a memory address with a random value very cpu tick.

The KBD (keyboard) has also been configured differently.
KBD can have the values 0, 1, 2, 3 or 4 representing none, left, right, up and down respectivly.
