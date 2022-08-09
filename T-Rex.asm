
.segmentdef Code [start=$0810]
.segmentdef Assets [start=$6000]

.file [name="./T-Rex.prg", segments="Code, Assets", modify="BasicUpstart", _start=$0810]
.disk [filename="./T-Rex.d64", name="T-REX", id="C2022", showInfo]
{
  [name="--- RAFFAELE ---", type="rel"],
  [name="--- INTORCIA ---", type="rel"],
  [name="-- @GMAIL.COM --", type="rel"],
  [name="----------------", type="rel"],
  [name="          neeeem", type="rel"],
  [name="          tq   y", type="rel"],
  [name="          t    y", type="rel"],
  [name="  t       t  rrn", type="rel"],
  [name="  m      n   t  ", type="rel"],
  [name="  tm     t   t  ", type="rel"],
  [name="  t mrrrn    +ci", type="rel"],
  [name="  m          +i ", type="rel"],
  [name="   m        n   ", type="rel"],
  [name="    m     rn    ", type="rel"],
  [name="     rtrtn      ", type="rel"],
  [name="      t t       ", type="rel"],
  [name="      l l       ", type="rel"],
  [name="----------------", type="rel"],
  [name="T-REX", type="prg", segments="Code, Assets", modify="BasicUpstart", _start=$0810],
}

.segment Code

* = $0810 "Entry"
Entry: {
    SetupRasterIrq(Irq0)

    lda #RED
    sta c64lib.BG_COL_1
    lda #DARK_GREY
    sta c64lib.BG_COL_2

  !StartGame:
    jsr Background_Init

    SetupSprites()

    jsr Utils.ResetScore
    jsr DrawScoreRows
    jsr DrawFixedForeground
    jsr Dino.Init
    jsr Sun.Init
    jsr Ptero.Init
    jsr Obstacle.Init
    jsr Obstacle.PrepareCactus

  !CanStart:
    lda #0
    sta GameEnded
    asl c64lib.SPRITE_2S_COLLISION

  !MainLoop:
    lda c64lib.RASTER
    bne !MainLoop-

    lda GameEnded
    beq !GameInProgress+

    IsSpacePressed()
    beq !MainLoop-
    jsr Utils.CompareAndUpdateHiScore
    jmp !StartGame-

  !GameInProgress:
    jsr Dino.CheckCollision
    beq !Proceed+
    jsr SetGameEnded
    jmp !GameHandlingDone+

  !Proceed:
    jsr Obstacle.MoveObstacle
    jsr Ptero.MoveIt

    jsr ScrollLandscape
    jsr ScrollLowerForeground
    jsr Dino.SwitchDinoFrame
    jsr Dino.HandleJump

    ldy #11
  !WaitOuter:
    ldx #255
  !Wait:
    dex
    bne !Wait-
    dey
    bne !WaitOuter-

    IsReturnPressed()
    beq !MainLoop-
    jsr Dino.Jump

  !GameHandlingDone:
    jmp !MainLoop-

    rts
}

* = * "SetGameEnded"
SetGameEnded: {
    lda #1
    sta GameEnded

    jsr Dino.SetGameEnd

    rts
}

GameEnded: .byte 0

#import "./_label.asm"
