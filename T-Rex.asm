
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
    SetupRasterIrq(Irq0)
    
    lda #BLACK
    sta c64lib.BG_COL_1
    lda #DARK_GREY
    sta c64lib.BG_COL_2

  StartGame:
    lda #%00000001
    sta c64lib.IMR

    SetupSprites()

    jsr Background_Init

    jsr Utils.ResetScore
    jsr DrawScoreRows
    jsr DrawFixedForeground
    jsr Dino.Init
    jsr Sun.Init
    jsr Obstacle.Init
    jsr Obstacle.PrepareCactus

    IsReturnPressedAndReleased()

    lda #0
    sta GameEnded
    asl c64lib.SPRITE_2S_COLLISION

  !:
    lda c64lib.RASTER
    bne !-

    lda GameEnded
    bne WaitForGameRestart

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

  WaitForGameRestart:
    IsSpacePressedAndReleased()
    jmp StartGame
}

* = * "SetGameEnded"
SetGameEnded: {
    lda #1
    sta GameEnded
    
    jsr Dino.SetGameEnd

    lda #%00000000
    sta c64lib.IMR

    rts
}

GameEnded: .byte 0

#import "./_label.asm"
