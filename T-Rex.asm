
.segmentdef Code [start=$0810]
.segmentdef Assets [start=$5000]

.file [name="./T-Rex.prg", segments="Code, Assets", modify="BasicUpstart", _start=$0810]
.disk [filename="./T-Rex.d64", name="T-REX", id="C2022", showInfo]
{
  [name="--- RAFFAELE ---", type="usr"],
  [name="--- INTORCIA ---", type="usr"],
  [name="-- @GMAIL.COM --", type="usr"],
  [name="----------------", type="usr"],
  [name="         neeeem ", type="usr"],
  [name="         tq   y ", type="usr"],
  [name="         t    y ", type="usr"],
  [name=" tm      t  rrn ", type="usr"],
  [name=" t t    n   t   ", type="usr"],
  [name=" t m    t   t   ", type="usr"],
  [name=" t  mrrn    +ci ", type="usr"],
  [name=" m          +i  ", type="usr"],
  [name="  m        n    ", type="usr"],
  [name="   m     rn     ", type="usr"],
  [name="    rtrtn       ", type="usr"],
  [name="     t t        ", type="usr"],
  [name="     l l        ", type="usr"],
  [name="----------------", type="usr"],
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
    bne !MushroomEatenCheck+
    jsr SetGameEnded
    jmp !GameHandlingDone+

  !MushroomEatenCheck:
    jsr Dino.CheckMushroomEaten
    beq !Proceed+    

  !Proceed:
    jsr Obstacle.MoveObstacle
    jsr Obstacle.MoveMushroom
    jsr Ptero.MoveIt

    jsr ScrollLandscape
    jsr ScrollLowerForeground
    jsr Dino.SwitchDinoFrame
    jsr Dino.HandleJump

    ldy #14
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
