
.segmentdef Code [start=$0810]
.segmentdef Assets [start=$6000]

.file [name="./T-Rex.prg", segments="Code, Assets", modify="BasicUpstart", _start=$0810]
.disk [filename="./T-Rex.d64", name="T-REX", id="C2022", showInfo]
{
  [name="--- RAFFAELE ---", type="rel"],
  [name="--- INTORCIA ---", type="rel"],
  [name="-- @GMAIL.COM --", type="rel"],
  [name="----------------", type="rel"],
  [name="T-REX", type="prg", segments="Code, Assets", modify="BasicUpstart", _start=$0810],
  [name="----------------", type="rel"]
}

.segment Code

* = $0810 "Entry"
Entry: {
    IsReturnPressedAndReleased()
    sei
    SetupRasterIrq(10, Irq0)

    lda #%00000010
    sta $dd00                // Select Vic Bank #1, $4000-$7fff

    lda #$7f
    sta $dc0d
    sta $dd0d

    lda #%00110101      // Bit 0-2:
    sta $01             // RAM visible at $a000-$bfff and $e000-$ffff
                        // I/O area visible at $d000-$dfff

    lda #%00001100
    sta c64lib.MEMORY_CONTROL           // Pointer to char memory $0800-$0fff
                        // Pointer to screen memory $0000-$03ff

    lda c64lib.CONTROL_2           // Screen control register #2
    and #%11110111
    ora #%00010111
    sta c64lib.CONTROL_2           // Horizontal raster scroll
                        // 38 columns
                        // Multicolor mode on

    lda c64lib.CONTROL_1           // Screen control register #1
    and #%01111111
    sta c64lib.CONTROL_1           // Vertical raster scroll
                        // 25 rows
                        // Screen on
                        // Bitmap mode on
                        // Extended background mode on
    cli
    
    lda #BLACK
    sta c64lib.BG_COL_1
    lda #DARK_GREY
    sta c64lib.BG_COL_2

    SetupSprites()

    jsr DrawFixedForeground
    jsr Dino.Init
    jsr Obstacle.Init
    jsr Obstacle.PrepareCactus
    IsReturnPressedAndReleased()
  !:
    lda c64lib.RASTER
    bne !-

    lda GameEnded
    bne !-

    jsr Dino.CheckCollision
    beq !Proceed+
    jsr SetGameEnded
    jmp !-

  !Proceed:
    jsr Obstacle.MoveObstacle

    jsr ScrollLandscape
    jsr ScrollLowerForeground
    jsr Dino.SwitchDinoFrame
    jsr Dino.HandleJump

    ldx #255
  Wait:
    dex
    ManyNop(16)
    bne Wait

    IsReturnPressed()
    beq !-
    jsr Dino.Jump

    jmp !-

    rts
}

SetGameEnded: {
    lda #1
    sta GameEnded
    
    jsr Dino.SetGameEnd

    rts
}

GameEnded: .byte 0

#import "_label.asm"
