; Draw Circle 1.1                (C) Mircea Vutcovici, 4 Dec 1994, Feb 1995, 14 Feb 2006, 17 Feb 2013
; Bresenham's Algorithm for drawing circles in Zilog Z80 assembler
; Grafica pe calculator in limbaj PASCAL si "C" Editora Tehnica 1992

Xc      EQU 50                  ; Xc - the horizontal position of the center
Yc      EQU 70                  ; YC - the vertical position of the center
Rc      EQU 40                  ; Rc - circle radius

MAIN:
        ORG     30000           ; 0x7530
        DI                      ; Disable the interrupts because we are using the alternative registers
        PUSH    AF              ; Save all registers on stack
        PUSH    BC
        PUSH    DE
        PUSH    HL
        EXX
        EX      AF, AF'
        PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL
        LD      H, Xc           ; Prepare the input for the circle function
        LD      L, Yc
        LD      A, Rc
        CALL    CIRCLE          ; Call the circle function
        ;CALL   PLOT1
        POP     HL              ; Restore registers
        POP     DE
        POP     BC
        POP     AF
        EXX
        EX      AF, AF'
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        EI                      ; Enable the interupts
        RET

CIRCLE:
        ; Input: L = Yc, H = Xc, A = R
        ; Output: HL=(X1, Y1), DE=(X2,Y2)
        ; Internal: B'C'=u, H'L'=s, D'E'=v used in CIRCLE
        ;           BC used in PLOT1
        ;           AF, A'F' used everywhere
        EX      AF, AF'
        LD      A, 175          ; Yc <-- 175 - Yc
        SUB     L
        RET     C               ; if Yc > 175 return. (throw exception)
        LD      L, A
        EX      AF, AF'

PAS1:
        LD      C, A            ; saving A(R) to C
        SUB     H               ; X2 <-- Xc - R
        NEG
        LD      D, A

        LD      A, C            ; reloading A

        ADD     A, H            ; X1 <-- Xc + R
        LD      H, A

        LD      A, C            ; reloading A

        LD      E, L            ; Y1 <-- Yc     Y2 <-- Yc

        EXX
        CALL    PLOT

        LD      C, A            ;   .
        SLA     C               ;   .  u <-- 2*R
        LD      B, 0    ; B <-- Cy  .
        RL      B       ;           .

        LD      DE, 0           ; v <-- 0

        NEG                     ; s <-- 1 - R
        INC     A
        LD      L, A
        LD      H, 0    ; H <-- Cy
        RL      H       ;

PAS2:
        EXX
        INC     L               ; Y1 <-- Y1 + 1
        DEC     E               ; Y2 <-- Y2 - 1
        EXX
        INC     DE              ; v <-- v + 2
        INC     DE
        LD      A, E            ; if u = v jump to PAS9
        CP      C
        JR      NZ, PAS3
        LD      A, D
        CP      B
        JR      Z, PAS9

PAS3:
        CALL    PLOT
        SCF                     ; s <-- s + v + 1
        ADC     HL, DE
        LD      A, H            ; if s < 0 goto PAS2
        RLCA
        JR      C, PAS2

PAS4:
        EXX
        DEC     H               ; X1 <-- X1 - 1
        INC     L               ; Y1 <-- Y1 + 1
        INC     D               ; X2 <-- X2 + 1
        DEC     E               ; Y2 <-- Y2 - 1
        EXX

        DEC     BC              ; u <-- u - 2
        DEC     BC

        INC     DE              ; v <-- v + 2
        INC     DE

        SCF                     ; s <-- s - u
        CCF
        SBC     HL, BC

        LD      A, D            ; if u > v goto PAS3
        CP      B
        JR      C, PAS3         ; if Cary flag set, this means that u > v
        JR      NZ, PAS5        ; if Zero flag set, this means that u < v
        LD      A, E
        CP      C
        JR      C, PAS3         ; if Cary flag set, this means that u > v

PAS5:
        LD      A, B            ; if u = v goto PAS8
        CP      D
        JR      NZ, LOOP1
        LD      A, C
        CP      E
        JR      Z, PAS8

LOOP1:
        INC     HL              ; s <-- s + 1
        JR      PAS8            ; goto PAS8

PAS6:
        EXX
        DEC     H               ; X1 <-- X1 - 1
        INC     L               ; Y1 <-- Y1 + 1
        INC     D               ; X2 <-- X2 + 1
        DEC     E               ; Y2 <-- Y2 - 1
        EXX
        DEC     BC              ; u <-- u - 2
        DEC     BC
        INC     DE              ; v <-- v+2
        INC     DE
        ADD     HL, DE          ; s <-- s + v

PAS7:
        SCF                     ; s <-- s - u
        CCF
        SBC     HL, BC

PAS8:
        CALL    PLOT

PAS9:
        INC     HL              ; s <-- s + 1
        LD      A, H            ; if s < 0 goto PAS6
        RLCA
        JR      C, PAS6

PAS10:
        EXX
        DEC     H               ; X1 <-- X1 - 1
        INC     D               ; X2 <-- x2 + 1
        EXX
        DEC     BC              ; u <-- u - 2
        DEC     BC
        LD      A, B            ; if u <> 0 goto PAS7
        OR      C
        JR      NZ, PAS7

PAS11:
        CALL    PLOT
        DEC     HL              ; s <-- 1 - s
        LD      A, H
        NEG
        LD      H, A
        LD      A, L
        NEG
        LD      L, A

PAS12:
        EXX
        DEC     H               ; X1 <-- X1 - 1
        INC     D               ; X2 <-- X2 + 1
        EXX
        INC     BC              ; u <-- u + 2
        INC     BC
        LD      A, E            ; if u = v goto PAS19
        CP      C
        JR      NZ, PAS13
        LD      A, D
        CP      B
        JR      Z, PAS19

PAS13:
        CALL    PLOT
        SCF                     ; s <-- s + u + 1
        ADC     HL, BC
        LD      A, H            ; if s < 0 goto PAS12
        RLCA
        JR      C, PAS12

PAS14:
        EXX
        DEC     H               ; X1 <-- X1 - 1
        DEC     L               ; Y1 <-- Y1 - 1
        INC     D               ; X2 <-- X2 + 1
        INC     E               ; Y2 <-- Y2 + 1
        EXX
        INC     BC              ; u <-- u + 2
        INC     BC
        DEC     DE              ; v <-- v - 2
        DEC     DE
        SCF                     ; s <-- s - v
        CCF
        SBC     HL, DE
        LD      A, B            ; if u < v goto PAS13
        CP      D
        JR      C, PAS13
        JR      NZ, PAS15
        LD      A, C
        CP      E
        JR      C, PAS13

PAS15:
        LD      A, E            ; if u = v goto PAS18
        CP      C
        JR      NZ, LOOP2
        LD      A, D
        CP      B
        JR      Z, PAS18

LOOP2:
        INC     HL              ; s <-- s + 1
        JR      PAS18           ; goto PAS18

PAS16:
        EXX
        DEC     H               ; X1 <-- X1 - 1
        DEC     L               ; Y1 <-- Y1 - 1
        INC     D               ; X2 <-- X2 + 1
        INC     E               ; Y2 <-- Y2 + 1
        EXX
        INC     BC              ; u <-- u + 2
        INC     BC
        DEC     DE              ; v <-- v - 2
        DEC     DE
        ADD     HL, BC          ; s <-- s + u

PAS17:
        SCF                     ; s <-- s - v
        CCF
        SBC     HL, DE

PAS18:
        CALL    PLOT

PAS19:
        INC     HL              ; s <-- s + 1
        LD      A, H            ; if s < 0 goto PAS16
        RLCA
        JR      C, PAS16

PAS20:
        EXX
        DEC     L               ; Y1 <-- Y1 - 1
        INC     E               ; Y2 <-- Y2 + 1
        EXX
        DEC     DE              ; v <-- v - 2
        DEC     DE
        LD      A, D            ; if v <> 0 goto PAS17
        OR      E
        JR      NZ, PAS17

PAS21:
        RET                     ; return


; -------- PLOT two points -----------
PLOT:
        EXX
        CALL    PLOT1           ; plot(x1, y1)
        EX      DE, HL
        CALL    PLOT1
        EX      DE, HL          ; plot(x2, y2)
        EXX
        RET
; -------- PLOT end ------------------

; -------- PLOT1 - plots one point ---
PLOT1:
; y: 00 000 000 = page, subpage, displacement
; x: 00000 000   = page, displacement
; 010 00 000 000 00000 = 010 Ypage Ydisplacement Ysubpage Xpage
; Input: H <- X; L <- Y [0 - 175];
        LD      A, 175          ; Check if 0 <= Y <= 175
        CP      L
        RET     C               ; If Y bigger, then return
        LD      A, L            ; Calculate the memory address of the point. First B
        AND     0xC0            ;%11000000  ;Ypage
        RRCA
        RRCA
        RRCA
        OR      0x40            ;%01000000  ; Ydisplacement
        LD      B, A
        LD      A, L
        AND     0x07            ;%00000111  ; Ysubpage
        OR      B
        LD      B, A            ; B is calculated
        LD      A, L
        AND     0x38            ;%00111000  ; Xpage
        RLCA
        RLCA
        LD      C, A
        LD      A, H
        AND     0xF8            ;%11111000  ; Xdisplacement
        RRCA
        RRCA
        RRCA
        OR      C
        LD      C, A            ; C is calculated
        LD      A, H            ; Calculating the bit to set at (BC) address.
        CPL
        RLCA
        RLCA
        SLA     A
        OR      0xC7            ;%11000111
        LD      (MODIF+1), A
        LD      A, (BC)
MODIF:  SET     1, A
        LD      (BC),A          ; Draw the pixel.
        RET
; -------- PLOT1 end -----------------

; vim:et:ts=8:sts=8:sw=8:
