# lzfx-boot
This project demonstrates the decompression algorithm for the [modified LZFX-based compression library](https://github.com/janding/lzfx).

## Goal
The goal of these two projects is to explore whether a compression algorithm can be built where the code for decompression is so small that it justifies the overhead even in a restricted environment such as a boot sector. In a boot sector there are usually less than 512 bytes available for code and data. 

## Approach
* The LZFX compression library was chosen because of the simplicity of the algorithm
* Code for decompression was written in 32-bit x86 assembly language and optimized for size by hand
    * A implementation in 32-bit assembly allowed testing on the development system (unlike the 16-bit code in this repository, which requires an emulator)
* The LZFX compression library was modified to reduce the number of assembly instructions required for decompression
    * The encoding of literal runs and backreferences was modified so that the `AAM` instruction could be used to perform decoding of the bit field and a comparison with zero in one instruction
    * The encoding of lengths was modified so that the decoder does not have to add constant values, resulting in fewer instructions at the cost of slightly worse compression
* The modified 32-bit assembly code was ported to 16-bit resulting in this project

## An "encoding that requires fewer and simpler instructions in the decoder"
The size of the code for decompression is 46 bytes (16-bit x86 assembly) if one disregards initialization of the source and destination pointers. That is the number of bytes between the label "decompress:" and ".done:" in the listing bootsec.lst that is generated by NASM when building the final binary.

If you consider all code in bootsec.asm as overhead, the size required for decompression increases to 63 bytes or 12% of the available space in the boot sector. That means the compressed data has to be smaller than 88% of the uncompressed data to justify this approach. The (modified) LZFX algorithm not rarely performs worse.

## How to compile and run

### Requirements
NASM, GCC, Make, Autoconf, QEMU

### Compiling
1. Clone the [LZFX](https://github.com/janding/lzfx) repository into a directory next to this repository
    * You will have to modify the [Makefile](Makefile#L2) to tell GCC where the modified LZFX-based compression library and headers are, unless the lzfx and lzfx-boot repositories are in the same directory!
2. Build LZFX (in the directory with the LZFX repository)
```
autoconf
./configure
make
```
3. Build this project (in the directory with this repository)
```
make
```

### Testing
```
qemu-system-i386 -fda bootsec
```

## Acknowledgements
The [fork](https://github.com/janding/lzfx) of LZFX is based on the LZFX compression library by Andrew Collette
(http://lzfx.googlecode.com).

LZFX is based on the LZF code base by Marc Lehmann.