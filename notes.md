

The files in the tmp folder can be used to debug the program,
as every line corresponds exactly with one instruction.

There are some slight differences from the reference, namely:

To use user defined symbols like @i, a command is required to reserve this global variable:
    $ name: NumberOf16BitValues

The default registers (R0 to R15) are not used and therefore not defined.

The way the keyboard works is different. Only the arrow keys can be read, so
at 

There is a new default symbol: @RANDOM.
This points to a memory address with a random value very cpu tick.

