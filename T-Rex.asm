
.segmentdef Code [start=$0810]
.segmentdef MapData [start=$7800]

.file [name="./T-Rex.prg", segments="Code, MapData", modify="BasicUpstart", _start=$0810]
.disk [filename="./T-Rex.d64", name="T-REX", id="C2022", showInfo]
{
  [name="--- RAFFAELE ---", type="rel"],
  [name="--- INTORCIA ---", type="rel"],
  [name="-- @GMAIL.COM --", type="rel"],
  [name="----------------", type="rel"],
  [name="T-REX", type="prg", segments="Code, MapData", modify="BasicUpstart", _start=$0810],
  [name="----------------", type="rel"]
}

.segment Code

* = $0810 "Entry"
Entry: {
    SetupRasterIrq(10, Irq0)

    lda #%00000010
    sta $dd00                // Select Vic Bank #1, $4000-$7fff

    lda #$7f
    sta $dc0d
    sta $dd0d

    lda #%00110101      // Bit 0-2:
    sta $01             // RAM visible at $a000-$bfff and $e000-$ffff
                        // I/O area visible at $d000-$dfff

    lda #%11101100
    sta c64lib.MEMORY_CONTROL           // Pointer to char memory $0800-$0fff
                        // Pointer to screen memory $0000-$03ff

    lda c64lib.CONTROL_2           // Screen control register #2
    and #%11110111
    ora #%00010111
    sta c64lib.CONTROL_2           // Horizontal raster scroll
                        // 38 columns
                        // Multicolor mode on

    lda #<RasterLandscapeStart
    sta $fffe
    lda #>RasterLandscapeStart
    sta $ffff
    lda #$20
    sta c64lib.RASTER           // Raster line at $ff

    lda c64lib.CONTROL_1           // Screen control register #1
    and #%01111111
    sta c64lib.CONTROL_1           // Vertical raster scroll
                        // 25 rows
                        // Screen on
                        // Bitmap mode on
                        // Extended background mode on

    lda #BLACK
    sta c64lib.BG_COL_1
    lda #DARK_GREY
    sta c64lib.BG_COL_2

  !:
    lda c64lib.RASTER
    bne !-
    jsr ScrollLandscape
    ManyNop(20);
    jmp !-

    rts
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
    lda #$90                        // Raster line $81 - 129
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
    // waste some cycles to stabilize the line
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

    lda #<Split03a
    sta $fffe
    lda #>Split03a
    sta $ffff
    lda #$a6
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

* = * "Split03a"
Split03a: {
    sta ModA + 1
    stx ModX + 1
    sty ModY + 1

    //Foreground
    lda c64lib.RASTER
    cmp c64lib.RASTER
    bne *-3

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
    nop

    lda #<RasterLandscapeStart
    sta $fffe
    lda #>RasterLandscapeStart
    sta $ffff
    lda #$20
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

FrameFlag: .byte $00

#import "_label.asm"
