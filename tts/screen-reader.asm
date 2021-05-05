; Este apăsat ENTER?
;    DA { STKBOT-WORKSP != 0 ?
;        DA { scrie de la WORKSP la STKBOT }
;        NU { scrie E-Line --> WORKSP }
; ELINE - adresa comenzii introduse

        ; Variabilele EEPROM-ului sunt descrise la: https://skoolkid.github.io/rom/buffers/sysvars.html
        DEFW    STKBOT, 0x5C63  ; Address of bottom of calculator stack
        DEFW    WORKSP, 0x5C61  ; Address of temporary work space
        DEFW    ELINE, 0x5C59   ; Address of command being typed in

VOICE:  EQU   ????              ; TODO: Aici trebuie sa fie adresa spre TTS


SUBRUTINA:
        LD      A, %10111111
        IN      A, (254)
        CP      0
        RET     NZ
        LD      DE, (STKBOT)
        LD      HL, (WORKSP)
        PUSH    HL
        OR      A
        SBC     HL,DE
        LD      A, H
        OR      L
        CP      0
        POP     HL
        JR      NZ, SALTUL
        LD      HL, (ELINE)
        LD      DE, (WORKSP)

SALTUL:
        LD      BC, (TEXT)

SALT:
        LD      A, (HL)
        CP      14
        JR      NZ, CHAR
        INC     HL
        INC     HL
        INC     HL
        INC     HL
        INC     HL
        JP      SFR

CHAR:
        CP      32
        JP      C, SFR          ; cary flag set - număr negativ
        CP      97
        JP      C, LMARI        ; cary flag set - număr negativ
        CP      123
        JP      NC, TAB         ; cary flag not set - număr pozitiv
        RES     5, A
        LD      (BC), A
        INC     BC
        JP      SFR

LMARI:
        ; Daca caracterul A nu este o litera mare, sari la TAB
        CP      65
        JP      C, TAB          ; negativ
        CP      91
        JP      NC, TAB         ; pozitiv

        ; Caracterul curent este o litera mare
        LD (BC), A
        INC     BC
        JP      SFR

TAB:
        PUSH    HL
        PUSH    DE
        LD      DE, TABEL
        LD      H, A

LOOP:
        LD      A, (DE)
        CP      0
        JP      Z, END
        CP      H
        JP      Z, SCRIE

NEXT:
        LD      A, (DE)
        PUSH    AF
        INC     DE
        AND     %10000000
        CP      0
        POP     AF
        JR      NZ, LOOP
        CP      0
        JR      Z, END
        JR      NEXT

SCRIE:
        INC     DE
        LD      A, (DE)
        PUSH    AF
        AND     %01111111
        LD      (BC), A
        INC     BC
        POP     AF
        AND     %10000000
        CP      0
        JR      Z, SCRIE

END:
        POP     DE
        POP     HL

SFR:
        INC     HL
        LD      A, H
        SUB     D
        CP      0
        JP      NZ, SALT
        LD      A, L
        SUB     E
        CP      0
        JP      NZ, SALT
        LD      A, 0
        LD      (BC), A
        CALL    VOICE
        RET

TEXT:   EQU     $                ; Adresa dicționarului cu pronunție în română

; vim:et:ts=8:sts=8:sw=8:
