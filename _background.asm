#importonce

.macro SetupRasterIrq(irq) {
    sei

    lda #%00000010
    sta $dd00                // Select Vic Bank #1, $4000-$7fff

    lda #$7f
    sta $dc0d
    sta $dd0d

    lda #%00110101      // Bit 0-2:
    sta $01             // RAM visible at $a000-$bfff and $e000-$ffff
                        // I/O area visible at $d000-$dfff

    lda #%00001100
    sta c64lib.MEMORY_CONTROL // Pointer to char memory $0800-$0fff
                              // Pointer to screen memory $0000-$03ff

    lda c64lib.CONTROL_2
    and #%11101000
    sta c64lib.CONTROL_2

    lda c64lib.CONTROL_1
    and #%01111111
    sta c64lib.CONTROL_1  // Vertical raster scroll
                          // 25 rows
                          // Screen on
                          // Bitmap mode on
                          // Extended background mode on

    lda #<Irq0
    sta $fffe
    lda #>Irq0
    sta $ffff
    lda #0
    sta c64lib.RASTER

    lda #%00000001
    sta c64lib.IMR

    cli
}

Background_Init: {
    lda #0
    sta MapPositionLandscape + 1
    sta MapPositionBottom + 1
    sta MapPositionLowerForeground + 1

    lda #7
    sta MapPositionLandscape
    sta MapPositionBottom
    sta MapPositionLowerForeground

    lda #StartMapSpeedForeground
    sta MapSpeedForeground

    ldx #0
    txa
  !:
    sta SCREEN_RAM, x
    sta SCREEN_RAM + $100, x
    sta SCREEN_RAM + $200, x
    sta SCREEN_RAM + $300, x
    inx
    cpx #0
    bne !-

    rts
}

Irq0: { // 0
    pushStatus()

    lda #$ff
    sta c64lib.IRR

    lda #LIGHT_GRAY
    sta c64lib.BORDER_COL
    sta c64lib.BG_COL_0

    lda #<Irq1
    sta $fffe
    lda #>Irq1
    sta $ffff
    lda #52
    sta c64lib.RASTER

// Disable smooth scrolling and multicolor while showing
// score and hiscore
    lda c64lib.CONTROL_2
    and #%11101000
    sta c64lib.CONTROL_2

    popStatus()

    rti
}

Irq1: { // 52
    pushStatus()

    lda #$ff
    sta c64lib.IRR

    ManyNop(16)

    lda #CYAN
    sta c64lib.BORDER_COL
    sta c64lib.BG_COL_0

    lda #<Irq2
    sta $fffe
    lda #>Irq2
    sta $ffff
    lda #54
    sta c64lib.RASTER

    popStatus()

    rti
}

Irq2: { // 54
    pushStatus()

    lda #$ff
    sta c64lib.IRR

    ManyNop(18)

    lda #LIGHT_GRAY
    sta c64lib.BORDER_COL
    sta c64lib.BG_COL_0

    lda #<Irq3
    sta $fffe
    lda #>Irq3
    sta $ffff
    lda #56
    sta c64lib.RASTER

    popStatus()

    rti
}

Irq3: { // 56
    pushStatus()

    lda #$ff
    sta c64lib.IRR

    ManyNop(20)

    lda #CYAN
    sta c64lib.BORDER_COL
    sta c64lib.BG_COL_0

    lda #<Irq4
    sta $fffe
    lda #>Irq4
    sta $ffff
    lda #59
    sta c64lib.RASTER

    popStatus()

    rti
}

Irq4: { // 59
    pushStatus()

    lda #$ff
    sta c64lib.IRR

    ManyNop(30)

    lda #LIGHT_GRAY
    sta c64lib.BORDER_COL
    sta c64lib.BG_COL_0

    lda #<Irq5
    sta $fffe
    lda #>Irq5
    sta $ffff
    lda #61
    sta c64lib.RASTER

    popStatus()

    rti
}

Irq5: { // 61
    pushStatus()

    lda #$ff
    sta c64lib.IRR

    ManyNop(8)

    lda #CYAN
    sta c64lib.BORDER_COL
    sta c64lib.BG_COL_0

    lda #<RasterLandscapeStart
    sta $fffe
    lda #>RasterLandscapeStart
    sta $ffff
    lda #66
    sta c64lib.RASTER

    popStatus()

    rti
}

* = * "RasterLandscapeStart"
/* Raster line for landscape */
RasterLandscapeStart: { // 66
    pushStatus()

    lda #YELLOW
    sta $d020

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

    asl c64lib.IRR               // Interrupt status register

    popStatus()

    rti
}

* = * "RasterForegroundStart"
/* Raster line for foreground */
RasterForegroundStart: {  // 144
    pushStatus()

    lda #LIGHT_RED
    sta $d020

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

    // lda MapPositionBottom + 0
    // ora #%00010000
    // sta c64lib.CONTROL_2

    lda #%00010000
    sta c64lib.CONTROL_2

    lda #<RasterLowerForegroundStart
    sta $fffe
    lda #>RasterLowerForegroundStart
    sta $ffff
    lda #200
    sta c64lib.RASTER

    asl c64lib.IRR

    popStatus()

    rti
}

* = * "RasterLowerForegroundStart"
/* Raster line for lower foreground */
RasterLowerForegroundStart: {
    pushStatus()

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

    asl c64lib.IRR

    popStatus()

    rti
}

* = * "ScrollLandscape"
ScrollLandscape: {
    lda Direction
    beq !NoShift+

    // Increment map-position
    lda MapPositionLandscape + 0
    sec
    sbc MapSpeedLandscape
    sta MapPositionLandscape + 0
    bcs !NoShift+
    // Shift map
    adc #8
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

    // Increment map-position
    lda MapPositionLowerForeground + 0
    sec
    sbc MapSpeedForeground
    sta MapPositionLowerForeground + 0
    bcs !NoShift+
    // Shift map
    adc #8
    sta MapPositionLowerForeground + 0
    inc MapPositionLowerForeground + 1
    ldx MapPositionLowerForeground + 1
    jsr ShiftMapLowerForeground

  !NoShift:
    rts
}

.label ScreenPart1LowerRow = 2
.label ScreenPart2LowerRow = 9
.label ScreenPart3HigherRow = 20

* = * "ShiftMapLandscape"
ShiftMapLandscape: {
    lda MapPositionLandscape + 1
    clc
    adc #38
    tax

    .for (var i=ScreenPart1LowerRow; i < ScreenPart2LowerRow; i++) {
      .for (var j=0; j<38; j++) {
        lda SCREEN_RAM + (40 * i) + j + 1
        sta SCREEN_RAM + (40 * i) + j + 0
        lda c64lib.COLOR_RAM + (40 * i) + j + 1
        sta c64lib.COLOR_RAM + (40 * i) + j + 0
      }
      lda MAP + MapWidth * i, x
      sta SCREEN_RAM + (40 * i) + 38
      tay
      lda COLOR_MAP, y
      sta c64lib.COLOR_RAM + (40 * i) + 38
    }

    rts
}

* = * "ShiftMapLowerForeground"
ShiftMapLowerForeground: {
    lda MapPositionLowerForeground + 1
    clc
    adc #38
    tax

    .for (var i=ScreenPart3HigherRow; i < 25; i++) {
      .for (var j=0; j<38; j++) {
        ldy SCREEN_RAM + 40 * i + j + 1
        sty SCREEN_RAM + 40 * i + j + 0
        lda c64lib.COLOR_RAM + 40 * i + j + 1
        sta c64lib.COLOR_RAM + 40 * i + j + 0
      }
      lda MAP + MapWidth * i, x
      sta SCREEN_RAM + 40 * i + $26
      tay
      lda COLOR_MAP, y
      sta c64lib.COLOR_RAM + 40 * i + $26
    }

    rts
}

* = * "DrawScoreRows"
/* Draws first two rows. These are static so no scrolling is done. */
DrawScoreRows: {
    ldx #0
  !Loop1:
    lda MAP, x
    sta SCREEN_RAM, x
    lda #0
    sta c64lib.COLOR_RAM, x
    inx
    cpx #40
    bne !Loop1-

    ldx #0
  !Loop2:
    lda MAP + MapWidth, x
    sta SCREEN_RAM + 40, x
    lda #0
    sta c64lib.COLOR_RAM + 40, x
    inx
    cpx #40
    bne !Loop2-

    rts
}

* = * "DrawFixedForeground"
/* Draws earth line where Dino lives. This is static so no
   scrolling is done. */
DrawFixedForeground: {
    ldx #0
  !Loop:
    lda MAP + (ScreenPart3HigherRow * MapWidth), x
    sta SCREEN_RAM + (ScreenPart3HigherRow * 40), x
    tay
    lda COLOR_MAP, y
    sta c64lib.COLOR_RAM + (ScreenPart3HigherRow * 40), x
    inx
    cpx #40
    bne !Loop-

    rts
}

.macro ManyNop(nopCount) {
    .for (var i = 0; i < nopCount; i++) {
      nop
    }
}

.macro pushStatus() {
    pha
    txa
    pha
    tya
    pha
}

.macro popStatus() {
    pla
    tay
    pla
    tax
    pla
}

.label SCREEN_RAM = $4000

.label MapWidth = 256

MapPositionLandscape:
    .byte $07, $00  //Frac/Full
MapPositionBottom:
    .byte $07, $00  //Frac/Full
MapPositionLowerForeground:
    .byte $07, $00  //Frac/Full

Direction:          // Actual game direction
    .byte $01       // $00 - no move, $01 - right, $ff - left

.label StartMapSpeedForeground = 2;
MapSpeedLandscape: .byte 1
MapSpeedForeground: .byte StartMapSpeedForeground

FrameFlag: .byte $00

#import "./_label.asm"
