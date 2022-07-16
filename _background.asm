#importonce

.macro SetupRasterIrq(line, irq) {
    // Disattiva gli interrupt che possono arrivare dalla CIA-1
    lda #%01111111
    sta $dc0d

    // Azzera il bit 7 del registro raster del Vic-II
    and $d011
    sta $d011

    // Conferma per gli interrupt generati da CIA-1 e CIA-2
    lda $dc0d
    lda $dd0d

    // Abilita gli interrupt del Vic-II
    lda #%00000001
    sta $d01a

    lda #<Irq0
    sta $fffe
    lda #>Irq0
    sta $ffff
    lda #0
    sta c64lib.RASTER
}

.macro ManyNop(nopCount) {
    .for (var i = 0; i < nopCount; i++) {
      nop
    }
}

Irq0: { // 50
    lda #$ff
    sta $d019

    lda #CYAN
    sta $d020
    sta $d021

    lda #<Irq1
    sta $fffe
    lda #>Irq1
    sta $ffff
    lda #52
    sta c64lib.RASTER

    rti
}

Irq1: { // 52
    lda #$ff
    sta $d019

    ManyNop(20)

    lda #LIGHT_GRAY
    sta $d020
    sta $d021

    lda #<Irq2
    sta $fffe
    lda #>Irq2
    sta $ffff
    lda #54
    sta c64lib.RASTER

    rti
}

Irq2: { // 54
    lda #$ff
    sta $d019

    ManyNop(20)

    lda #CYAN
    sta $d020
    sta $d021

    lda #<Irq3
    sta $fffe
    lda #>Irq3
    sta $ffff
    lda #56
    sta c64lib.RASTER

    rti
}

Irq3: { // 56
    lda #$ff
    sta $d019

    ManyNop(20)

    lda #LIGHT_GRAY
    sta $d020
    sta $d021

    lda #<Irq4
    sta $fffe
    lda #>Irq4
    sta $ffff
    lda #59
    sta c64lib.RASTER

    rti
}

Irq4: { // 59
    lda #$ff
    sta $d019

    ManyNop(30)

    lda #CYAN
    sta $d020
    sta $d021

    lda #<Irq5
    sta $fffe
    lda #>Irq5
    sta $ffff
    lda #61
    sta c64lib.RASTER

    rti
}

Irq5: { // 61
    lda #$ff
    sta $d019

    ManyNop(8)

    lda #LIGHT_GRAY
    sta $d020
    sta $d021

    lda #<RasterLandscapeStart
    sta $fffe
    lda #>RasterLandscapeStart
    sta $ffff
    lda #64
    sta c64lib.RASTER

    rti
}

* = * "RasterLandscapeStart"
/* Raster line for landscape */
RasterLandscapeStart: {
    sta ModA + 1
    stx ModX + 1
    sty ModY + 1

    // Landscape
    lda MapPositionLandscape + 0
    ora #%00010000
    sta c64lib.CONTROL_2

    lda #<RasterForegroundStart
    sta $fffe
    lda #>RasterForegroundStart
    sta $ffff
    lda #144
    sta c64lib.RASTER
  ModA:
    lda #$00
  ModX:
    ldx #$00
  ModY:
    ldy #$00
    asl c64lib.IRR               // Interrupt status register
    rti
}

* = * "RasterForegroundStart"
/* Raster line for foreground */
RasterForegroundStart: {
    sta ModA + 1
    stx ModX + 1
    sty ModY + 1

    // Foreground
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    lda MapPositionBottom + 0
    ora #%00010000
    sta c64lib.CONTROL_2

    lda #<RasterLowerForegroundStart
    sta $fffe
    lda #>RasterLowerForegroundStart
    sta $ffff
    lda #200
    sta c64lib.RASTER

  ModA:
    lda #$00
  ModX:
    ldx #$00
  ModY:
    ldy #$00
    asl c64lib.IRR
    rti
}

* = * "RasterLowerForegroundStart"
/* Raster line for lower foreground */
RasterLowerForegroundStart: {
    sta ModA + 1
    stx ModX + 1
    sty ModY + 1

    // Foreground
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    lda MapPositionLowerForeground + 0
    ora #%00010000
    sta c64lib.CONTROL_2

    lda #<Irq0
    sta $fffe
    lda #>Irq0
    sta $ffff
    lda #0
    sta c64lib.RASTER

  ModA:
    lda #$00
  ModX:
    ldx #$00
  ModY:
    ldy #$00
    asl c64lib.IRR
    rti
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

ScrollLowerForeground: {
    lda Direction
    beq !NoShift+
    bpl !Forward+

  !Backward:
    //Increment map-position
    lda MapPositionLowerForeground + 0
    clc
    adc MapSpeed + 1
    sta MapPositionLowerForeground + 0
    cmp #$08
    bcc !NoShift+

    //Shift map
    sbc #$08
    sta MapPositionLowerForeground + 0
    dec MapPositionLowerForeground + 1
    ldx MapPositionLowerForeground + 1
    jsr ShiftMapLowerForegroundBack
  !NoShift:
    rts

  !Forward:
    //Increment map-position
    lda MapPositionLowerForeground + 0
    sec
    sbc MapSpeed + 1
    sta MapPositionLowerForeground + 0
    bcs !NoShift+
    //Shift map
    adc #$08
    sta MapPositionLowerForeground + 0
    inc MapPositionLowerForeground + 1
    ldx MapPositionLowerForeground + 1
    jsr ShiftMapLowerForeground
  !NoShift:
    rts
}

.label ScreenPart1LowerRow = 0
.label ScreenPart2LowerRow = 9
.label ScreenPart3HigherRow = 20

* = * "ShiftMapLandscape"
ShiftMapLandscape: {
    txa
    clc
    adc #$26
    tax

    .for (var i=ScreenPart1LowerRow; i < ScreenPart2LowerRow; i++) {
      .for (var j=0; j<38; j++) {
        ldy SCREEN_RAM + $28 * i + j + 1
        sty SCREEN_RAM + $28 * i + j + 0
        lda COLOR_MAP, y
        sta c64lib.COLOR_RAM + $28 * i + j + 0
      }
      ldy MAP + $100 * i, x
      sty SCREEN_RAM + $28 * i + $26
      lda COLOR_MAP, y
      sta c64lib.COLOR_RAM + $28 * i + $26
    }

    rts
}

* = * "ShiftMapLowerForeground"
ShiftMapLowerForeground: {
    .for (var i=ScreenPart3HigherRow; i < 25; i++) {
      .for (var j=0; j<38; j++) {
        ldy SCREEN_RAM + $28 * i + j + 1
        sty SCREEN_RAM + $28 * i + j + 0
        lda COLOR_MAP, y
        sta c64lib.COLOR_RAM + $28 * i + j + 0
      }
      ldy MAP + $100 * i, x
      sty SCREEN_RAM + $28 * i + $26
      lda COLOR_MAP, y
      sta c64lib.COLOR_RAM + $28 * i + $26
    }

    rts
}

* = * "ShiftMapLandscapeBack"
ShiftMapLandscapeBack: {
    .for (var i=ScreenPart1LowerRow; i < ScreenPart2LowerRow; i++) {
      .for (var j=37; j>=0; j--) {
        ldy SCREEN_RAM + $28 * i + j + 0
        sty SCREEN_RAM + $28 * i + j + 1
        lda COLOR_MAP, y
        sta c64lib.COLOR_RAM + $28 * i + j + 1
      }
      ldy MAP + $100 * i, x
      sty SCREEN_RAM + $28 * i
      lda COLOR_MAP, y
      sta c64lib.COLOR_RAM + $28 * i
    }
    rts
}

* = * "ShiftMapLowerForegroundBack"
ShiftMapLowerForegroundBack: {
    .for (var i=ScreenPart3HigherRow; i < 25; i++) {
      .for (var j=37; j>=0; j--) {
        ldy SCREEN_RAM + $28 * i + j + 0
        sty SCREEN_RAM + $28 * i + j + 1
        lda COLOR_MAP, y
        sta c64lib.COLOR_RAM + $28 * i + j + 1
      }
      ldy MAP + $100 * i, x
      sty SCREEN_RAM + $28 * i
      lda COLOR_MAP, y
      sta c64lib.COLOR_RAM + $28 * i
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

MapPositionLandscape:
    .byte $07, $00  //Frac/Full
MapPositionBottom:
    .byte $07, $00  //Frac/Full
MapPositionLowerForeground:
    .byte $07, $00  //Frac/Full


Direction:          // Actual game direction
    .byte $01       // $00 - no move, $01 - right, $ff - left
MapSpeed:
    .byte $00,$01

FrameFlag: .byte $00

#import "_label.asm"
