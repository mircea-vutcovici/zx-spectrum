.PHONY = all clean

all: DrawCircle.tzx

Z80ASSEMBLER = pasmo-0.5.5/pasmo
#Z80ASSEMBLER_OPTIONS = --tzxbas --tzx
Z80ASSEMBLER_OPTIONS = -d --tzx

DrawCircle.tzx: DrawCircle.asm
	${Z80ASSEMBLER} ${Z80ASSEMBLER_OPTIONS}  DrawCircle.asm DrawCircle.tzx

clean:
	rm DrawCircle.tzx
