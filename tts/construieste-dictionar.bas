1 REM Dictionarul o sa arate: =EEGAAL_;PUUNCT SHII VIIRGULEA_
2 REM L_ si A_ este de fapt caracterul L si respectiv A cu bitul 7 setat, adica 0xCC, 0xC0
5 LET ADDR= ... : LET A=ADDR
10 INPUT "Introduceti caracterul";a$
20 INPUT """"; (a$);""" Se pronunta ";b$
30 LET a$=a$+b$
40 LET a$=a$(TOLEN a$-1)+CHR$(CODE a$(LEN a$)+128)
50 FOR I=A to A + LEN a$ - 1
60 POKE I, CODE a$(I-A+1)
70 NEXT I
80 POKE I,0
90 LET A=I : INPUT "Cont?";a$ : IF a$ = "" THEN GOTO 10
