# zx-spectrum
Small programs written for Sinclair ZX Spectrum
Some of them are in Z80 Assembly. Other in BASIC.

## DrawCircle.asm
Assemble instructions:

```
pasmo --tzx  DrawCircle.asm DrawCircle.tzx
```

```
10 LOAD "DrawCircle" CODE 30000
20 RANDOMIZE USR 30000
SAVE "DrawCircle" LINE 10
RUN
```
