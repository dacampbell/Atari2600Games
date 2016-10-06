; Initial start to the pong program based upon the xample provided by the
; atari tutorials
    processor 6502
    include "vcs.h"
    include "macro.h"

;------------------------------------------------------------------------------
PATTERN         = $80                  ; storage location (1st byte in RAM)
TIMETOCHANGE    = 20                   ; speed of "animation" - change as desired
;------------------------------------------------------------------------------
    SEG
    ORG $F000

Reset
; Clear RAM and all TIA registers
    ldx #0
    lda #0

Clear
    sta 0,x
    inx
    bne Clear

; Set the color of the ball we are going to be using throughout the pong Game
    ldx #$0E
    stx COLUPF

; Start of new frame
; Start of vertical blank processing
StartOfFrame
    lda #0
    sta VBLANK
    lda #2
    sta VSYNC
    sta WSYNC
    sta WSYNC
    sta WSYNC               ; 3 scanlines of VSYNC signal
    lda #0
    sta VSYNC

;------------------------------------------------
; 37 scanlines of vertical blank...
    ldx #0
    ldy #1
    lda #100
    sty ENABL

VerticalBlank
    sta WSYNC
    sta RESBL
    inx
    cpx #37
    bne VerticalBlank

;------------------------------------------------
; Do 192 scanlines of color-changing (our picture)
    ldx #$00                ; this counts our scanline number
    stx COLUBK             ; change background color (rainbow effect)

; Zero x and then enter into the picture loop
    ldx #0
Picture
    sta WSYNC              ; wait till end of scanline
    inx
    cpx #192
    bne Picture

;-------------------------------------------------------------------------------

    ;lda #%01000010
    sta VBLANK          ; end of screen - enter blanking

; 30 scanlines of overscan...,
    ldx #0

Overscan
    sta WSYNC
    inx
    cpx #30
    bne Overscan

    jmp StartOfFrame

;-------------------------------------------------------------------------------
; This is the entry point of the progrm for the Pong Game
    ORG $FFFA

InterruptVectors

    .word Reset          ; NMI
    .word Reset          ; RESET
    .word Reset          ; IRQ

    END
