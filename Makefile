# Make sure that this variable points the compiler/linker to the modified LZFX library
LZFX_FLAGS = -I ../lzfx -L ../lzfx -llzfx


all: bootsec

# assemble payload
payload.bin: payload.asm
	nasm -f bin -o $@ $<
	
# compile compression tool
lzfx-raw: lzfx-raw.c
	gcc -o $@ $< $(LZFX_FLAGS)

# compress payload
payload.lzf: payload.bin lzfx-raw
	./lzfx-raw $< $@
	@echo "Uncompressed size: $$(stat --printf=%s $<) bytes"
	@echo "Compressed size: $$(stat --printf=%s $@) bytes"

# assemble boot sector
bootsec: bootsec.asm payload.lzf
	nasm -f bin -l bootsec.lst -o $@ $<


# delete output and temporary files
clean:
	$(RM) bootsec bootsec.lst payload.bin payload.lzf lzfx-raw

