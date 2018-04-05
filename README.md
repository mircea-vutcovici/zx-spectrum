# zx-spectrum
Small programs written for Sinclair ZX Spectrum
Some of them are in Z80 Assembly. Other in BASIC.

## DrawCircle.asm
Install assembler:
```
sudo apt install pasmo    # Ubuntu, Debian
```

Assemble instructions:

```
pasmo --tzx  DrawCircle.asm DrawCircle.tzx
```

Loader, written in ZX Spectrum Basic:

```
10 CLEAR 30000
20 LOAD "DrawCircle" CODE 30000
30 RANDOMIZE USR 30000
SAVE "DrawCircle" LINE 10
RUN
```
