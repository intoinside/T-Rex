#importonce

.filenamespace Dino

* = * "Dino.Init"
Init: {
    lda #PositionX
    sta c64lib.SPRITE_1_X
    lda #PositionY
    sta c64lib.SPRITE_1_Y

    lda #SPRITES_OFFSET.DINO_1
    sta DINO_PTR

    lda #GREEN
    sta c64lib.SPRITE_1_COLOR

    lda #0
    sta IsJumping
    sta IsDoped
    sta HandleJump.CurrentXFrame

    lda c64lib.SPRITE_ENABLE
    ora #%00000010
    sta c64lib.SPRITE_ENABLE

    rts
}

* = * "Dino.SwitchDinoFrame"
SwitchDinoFrame: {
    dec Waiter
    bne !Done+
    lda #WaitCount
    sta Waiter

    AddPoints(0, 1)

    lda IsJumping
    bne !Done+

    lda IsDoped
    bne !Doped+

    lda DINO_PTR
    cmp #SPRITES_OFFSET.DINO_1
    beq !SwitchTo2+
    lda #SPRITES_OFFSET.DINO_1
    jmp !Change+

  !SwitchTo2:
    lda #SPRITES_OFFSET.DINO_2
    jmp !Change+

  !Doped:
    lda DINO_PTR
    cmp #SPRITES_OFFSET.DINO_FAST_1
    beq !SwitchTo2+
    lda #SPRITES_OFFSET.DINO_FAST_1
    jmp !Change+

  !SwitchTo2:
    lda #SPRITES_OFFSET.DINO_FAST_2

  !Change:
    sta DINO_PTR

  !Done:
    rts

  .label WaitCount = 10
  Waiter: .byte WaitCount
}

* = * "Dino.SetDinoDoped"
SetDinoDoped: {
    lda #1
    sta IsDoped

    lda #RED
    sta c64lib.SPRITE_1_COLOR

    inc MapSpeedForeground

    ldx #0
  !WriteTxt:
    lda SpeedRunText, x
    sta SpeedRunLabel, x
    inx
    cpx #12
    bne !WriteTxt-

    CalculatePoints(0, 5, 0)

    rts
}

* = * "Dino.SetDinoUndoped"
SetDinoUndoped: {
    lda #0
    sta IsDoped

    lda #GREEN
    sta c64lib.SPRITE_1_COLOR

    dec MapSpeedForeground

    ldx #0
    txa
  !WriteTxt:
    sta SpeedRunLabel, x
    inx
    cpx #12
    bne !WriteTxt-

    rts
}

* = * "Dino.HandleSpeedRunText"
HandleSpeedRunText: {
    ldy #13
    ldx Offset
    lda Colours, x
  !Loop:
    sta SpeedRunColorsLabel - 1, y
    dey
    bne !Loop-

    inc Offset
    lda Offset
    cmp #40
    bne !Done+
    lda #0
    sta Offset

  !Done:
    jsr HasCalculatedScoreReached
    beq !Exit+

    jsr SetDinoUndoped

  !Exit:
    rts

  Colours: .byte $09,$09,$02,$02,$08
           .byte $08,$0a,$0a,$0f,$0f
           .byte $07,$07,$01,$01,$01
           .byte $01,$01,$01,$01,$01
           .byte $01,$01,$01,$01,$01
           .byte $01,$01,$01,$07,$07
           .byte $0f,$0f,$0a,$0a,$08
           .byte $08,$02,$02,$09,$09
  Offset: .byte 0
}

* = * "Dino.HasCalculatedScoreReached"
HasCalculatedScoreReached: {
    lda Utils.CalculateScore.CalculatedScore
    cmp Utils.CurrentScore
    bcc !NotReached+
    bne !Reached+

    lda Utils.CalculateScore.CalculatedScore + 1
    cmp Utils.CurrentScore + 1
    bcc !NotReached+
    bne !Reached+

    lda Utils.CalculateScore.CalculatedScore + 2
    cmp Utils.CurrentScore + 2
    bcc !NotReached+
    bne !Reached+

    lda Utils.CalculateScore.CalculatedScore + 3
    cmp Utils.CurrentScore + 3
    bcc !NotReached+
    bne !Reached+

    lda Utils.CalculateScore.CalculatedScore + 4
    cmp Utils.CurrentScore + 4
    bcc !NotReached+

  !Reached:
    lda #0
    jmp !Done+

  !NotReached:
    lda #1

  !Done:
    rts
}

* = * "Dino.Jump"
Jump: {
    lda IsJumping
    bne !Done+

    inc IsJumping

    lda #0
    sta HandleJump.CurrentXFrame

    lda IsDoped
    bne !Doped+

    lda #SPRITES_OFFSET.DINO_JMP
    jmp !Change+

  !Doped:
    lda #SPRITES_OFFSET.DINO_FAST_JMP

  !Change:
    sta DINO_PTR

  !Done:
    rts
}

* = * "Dino.HandleJump"
HandleJump: {
    lda IsJumping
    beq !Done+

    ldx CurrentXFrame
    cpx #TotalJumpFrame
    beq !ResetJump+

    lda JumpMap,x
    sta c64lib.SPRITE_1_Y
    inc CurrentXFrame
    jmp !Done+

  !ResetJump:
    lda #0
    sta IsJumping
    lda #SPRITES_OFFSET.DINO_1
    sta DINO_PTR

  !Done:
    rts

  CurrentXFrame: .byte 0
}

* = * "Dino.CheckCollision"
CheckCollision: {
    lda #%00001010
    and Sprite2SpriteCollision
    cmp #%00001010

    rts
}

* = * "Dino.CheckMushroomEaten"
CheckMushroomEaten: {
    lda #%00100010
    and Sprite2SpriteCollision
    cmp #%00100010

    rts
}

* = * "Dino.HandleDopedStatus"
HandleDopedStatus: {
    lda IsDoped
    bne !Doped+

    lda #0
    jmp !Done+

  !Doped:
    lda #1

  !Done:
    rts
}

* = * "Dino.SetGameEnd"
SetGameEnd: {
    lda #SPRITES_OFFSET.DINO_DEAD
    sta DINO_PTR

    lda #GRAY
    sta c64lib.SPRITE_1_COLOR

    rts
}

IsJumping: .byte 0
IsDoped: .byte 0

.label TotalJumpFrame = 38
JumpMap:
.fill TotalJumpFrame, round(PositionY - 45*sin(toRadians(360*i/((TotalJumpFrame - 1) * 2))))

.label SpeedRunLabel = SCREEN_RAM + c64lib_getTextOffset(1, 0)
.label SpeedRunColorsLabel = c64lib.COLOR_RAM + c64lib_getTextOffset(1, 0)
SpeedRunText: .text "speed run!!!"

.label PositionX = 55
.label PositionY = 196

.label DINO_PTR = SCREEN_RAM + $3f8 + 1

#import "./_label.asm"
