
.macro SetupRasterIrq(line, irq) {
    sei

    // Disattiva gli interrupt che possono arrivare dalla CIA-1
    lda #%01111111
    sta $dc0d

    // Azzera il bit 7 del registro raster del Vic-II
    and $d011
    sta $d011

    // Conferma per gli interrupt generati da CIA-1 e CIA-2
    lda $dc0d
    lda $dd0d

    ChangeRasterIrq(line, irq)

    // Abilita gli interrupt del Vic-II
    lda #%00000001
    sta $d01a

    // Abilito tutti gli sprite
    lda #%11111111
    sta $d015

    // Riabilito il lancio degli interrupt
    cli
}

.macro ChangeRasterIrq(line, irq) {
// Imposto il primo interrupt alla riga 149
    lda #line
    sta $d012

// Imposto la routine all'indirizzo Irq
    lda #<irq
    sta $0314
    lda #>irq
    sta $0315
}

.macro ManyNop(nopCount) {
    .for (var i = 0; i < nopCount; i++) {
      nop
    }
}

Irq0: {
    lda #$ff
    sta $d019

    lda #CYAN
    sta $d020
    sta $d021

    ChangeRasterIrq(80, Irq1)

    jmp $ea81
}

Irq1: {
    lda #$ff
    sta $d019

    ManyNop(6)

    lda #LIGHT_GRAY
    sta $d020
    sta $d021

    ChangeRasterIrq(82, Irq2)

    jmp $ea81
}

Irq2: {
    lda #$ff
    sta $d019

    ManyNop(15)

    lda #CYAN
    sta $d020
    sta $d021

    ChangeRasterIrq(84, Irq3)

    jmp $ea81
}

Irq3: {
    lda #$ff
    sta $d019

    ManyNop(17)

    lda #LIGHT_GRAY
    sta $d020
    sta $d021

    ChangeRasterIrq(87, Irq4)

    jmp $ea81
}

Irq4: {
    lda #$ff
    sta $d019

    ManyNop(4)

    lda #CYAN
    sta $d020
    sta $d021

    ChangeRasterIrq(89, Irq5)

    jmp $ea81
}

Irq5: {
    lda #$ff
    sta $d019

    ManyNop(6)

    lda #LIGHT_GRAY
    sta $d020
    sta $d021

    ChangeRasterIrq(10, Irq0)

    jmp $ea81
}

* = * "ScrollLandscape"
ScrollLandscape: {
    lda Direction
    beq !NoShift+
    bpl !Forward+

  !Backward:
    //Increment map-position
    lda MapPositionLandscape + 0
    clc
    adc MapSpeed + 1
    sta MapPositionLandscape + 0
    cmp #$08
    bcc !NoShift+

    //Shift map
    sbc #$08
    sta MapPositionLandscape + 0
    dec MapPositionLandscape + 1
    ldx MapPositionLandscape + 1
    jsr ShiftMapLandscapeBack
  !NoShift:
    rts

  !Forward:
    //Increment map-position
    lda MapPositionLandscape + 0
    sec
    sbc MapSpeed + 1
    sta MapPositionLandscape + 0
    bcs !NoShift+
    //Shift map
    adc #$08
    sta MapPositionLandscape + 0
    inc MapPositionLandscape + 1
    ldx MapPositionLandscape + 1
    jsr ShiftMapLandscape
  !NoShift:
    rts
}

.label ScreenPart1LowerRow = 3
.label ScreenPart2LowerRow = 16
.label ScreenPart3HigherRow = 20

* = * "ShiftMapLandscape"
ShiftMapLandscape: {
    txa
    clc
    adc #$26
    tax

    .for (var i=ScreenPart1LowerRow; i < ScreenPart2LowerRow; i++) {
      .for (var j=0; j<38; j++) {
        lda SCREEN_RAM + $28 * i + j + 1
        sta SCREEN_RAM + $28 * i + j + 0
      }
      lda MAP + $100 * i, x
      sta SCREEN_RAM + $28 * i + $26
    }
    rts
}

* = * "ShiftMapLandscapeBack"
ShiftMapLandscapeBack: {
    .for (var i=ScreenPart1LowerRow; i < ScreenPart2LowerRow; i++) {
      .for (var j=37; j>=0; j--) {
        lda SCREEN_RAM + $28 * i + j + 0
        sta SCREEN_RAM + $28 * i + j + 1
      }
      lda MAP + $100 * i, x
      sta SCREEN_RAM + $28 * i
    }
    rts
}

* = * "DrawForeground"
DrawForeground: {
    ldx #0
  !:
    lda MAP + (ScreenPart3HigherRow * 256), x
    sta SCREEN_RAM + (ScreenPart3HigherRow * 40), x
    inx
    cpx #40
    bne !-

    rts
}

.label SCREEN_RAM = $4000

.segment MapData

* = $7000 "CharMemory"
CHAR_MEMORY:
  .import binary "./assets/charset.bin"
* = $7800 "Map"
MAP:
  .import binary "./assets/map.bin"

* = * "ColorMap"
COLOR_MAP:
  .import binary "./assets/colors.bin"


VIC: {
	.label COLOR_RAM			= $d800
}

MapPositionBottom:
    .byte $07, $00  //Frac/Full
MapPositionLandscape:
    .byte $07, $00  //Frac/Full
Direction:          // Actual game direction
    .byte $01       // $00 - no move, $01 - right, $ff - left
MapSpeed:
    .byte $00,$01
