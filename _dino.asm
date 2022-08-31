#importonce

.filenamespace Dino

* = * "Dino.Init"
Init: {
    lda #PositionX
    sta c64lib.SPRITE_6_X
    lda #PositionY
    sta c64lib.SPRITE_6_Y

    lda #SPRITES_OFFSET.DINO_1
    sta DINO_PTR

    lda #GREEN
    sta c64lib.SPRITE_6_COLOR

    lda #0
    sta IsJumping
    sta IsDoped
    sta HandleJump.CurrentXFrame

    lda c64lib.SPRITE_ENABLE
    ora #%01000000
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
    cmp #SPRITES_OFFSET.DINO_DOPED_1
    beq !SwitchTo2+
    lda #SPRITES_OFFSET.DINO_DOPED_1
    jmp !Change+

  !SwitchTo2:
    lda #SPRITES_OFFSET.DINO_DOPED_2

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
    sta c64lib.SPRITE_6_COLOR

    ldx #0
  !WriteTxt:
    lda DopedText, x
    sta DopedLabel, x
    inx
    cpx #DopedTextSize
    bne !WriteTxt-

    CalculatePoints(0, 4, 0)
    CopyCalculatedPoints(
      Utils.CalculateScore.CalculatedScore, 
      HandleSpeedRunText.AlertScorePoints)

    CalculatePoints(0, 5, 0)
    CopyCalculatedPoints(
      Utils.CalculateScore.CalculatedScore, 
      HandleSpeedRunText.EndDopedScorePoints)

    rts
}

* = * "Dino.SetDinoUndoped"
SetDinoUndoped: {
    lda #0
    sta IsDoped

    lda #GREEN
    sta c64lib.SPRITE_6_COLOR

    ldx #0
    txa
  !WriteTxt:
    sta DopedLabel, x
    inx
    cpx #DopedTextSize
    bne !WriteTxt-

    rts
}

* = * "Dino.HandleSpeedRunText"
HandleSpeedRunText: {
    ldy #DopedTextSize + 1
    ldx Offset
    lda Colours, x
  !Loop:
    sta DopedColorsLabel - 1, y
    dey
    bne !Loop-

    inc Offset
    lda Offset
  FlashingQty:
    cmp #40
    bne !Done+
    lda #0
    sta Offset

  !Done:
    jsr HasEndDopedScorePointsReached
    beq !+

    jsr SetDinoUndoped
    lda #40
    sta FlashingQty + 1
    lda #0
    sta Offset

    jmp !Exit+

  !:
    jsr HasAlertScorePointsReached
    beq !Exit+

// Alert zone, flash faster to notify user that doped status
// is going to end soon
    lda #15
    sta FlashingQty + 1


  !Exit:
    rts

  AlertScorePoints: .byte 0, 0, 0, 0, 0
  EndDopedScorePoints: .byte 0, 0, 0, 0, 0

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

* = * "Dino.HasAlertScorePointsReached"
HasAlertScorePointsReached: {
    lda HandleSpeedRunText.AlertScorePoints
    cmp Utils.CurrentScore
    bcc !NotReached+
    bne !Reached+

    lda HandleSpeedRunText.AlertScorePoints + 1
    cmp Utils.CurrentScore + 1
    bcc !NotReached+
    bne !Reached+

    lda HandleSpeedRunText.AlertScorePoints + 2
    cmp Utils.CurrentScore + 2
    bcc !NotReached+
    bne !Reached+

    lda HandleSpeedRunText.AlertScorePoints + 3
    cmp Utils.CurrentScore + 3
    bcc !NotReached+
    bne !Reached+

    lda HandleSpeedRunText.AlertScorePoints + 4
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

* = * "Dino.HasEndDopedScorePointsReached"
HasEndDopedScorePointsReached: {
    lda HandleSpeedRunText.EndDopedScorePoints
    cmp Utils.CurrentScore
    bcc !NotReached+
    bne !Reached+

    lda HandleSpeedRunText.EndDopedScorePoints + 1
    cmp Utils.CurrentScore + 1
    bcc !NotReached+
    bne !Reached+

    lda HandleSpeedRunText.EndDopedScorePoints + 2
    cmp Utils.CurrentScore + 2
    bcc !NotReached+
    bne !Reached+

    lda HandleSpeedRunText.EndDopedScorePoints + 3
    cmp Utils.CurrentScore + 3
    bcc !NotReached+
    bne !Reached+

    lda HandleSpeedRunText.EndDopedScorePoints + 4
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

    PlaySound(12, 0, 0)

    inc IsJumping

    lda #0
    sta HandleJump.CurrentXFrame

    lda IsDoped
    bne !Doped+

    lda #SPRITES_OFFSET.DINO_JMP
    jmp !Change+

  !Doped:
    lda #SPRITES_OFFSET.DINO_DOPED_JMP

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
    sta c64lib.SPRITE_6_Y
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
// Check collision with obstacle1
    jsr Obstacle.Collided

// Check collision with ptero
    jsr Ptero.Collided

    lda Obstacle.IsExploding
    ora Ptero.IsExploding
    
  !Done:
    rts
}

* = * "Dino.CheckMushroomEaten"
CheckMushroomEaten: {
    lda #%01100000
    and Sprite2SpriteCollision
    cmp #%01100000

    rts
}

* = * "Dino.HandleDopedStatus"
HandleDopedStatus: {
    lda IsDoped

    rts
}

* = * "Dino.SetGameEnd"
SetGameEnd: {
    lda #SPRITES_OFFSET.DINO_DEAD
    sta DINO_PTR

    lda #GRAY
    sta c64lib.SPRITE_6_COLOR

    rts
}

IsJumping: .byte 0
IsDoped: .byte 0

Sprite2BackCollision: .byte 0
Sprite2SpriteCollision: .byte 0

.label TotalJumpFrame = 38
JumpMap:
.fill TotalJumpFrame, round(PositionY - 45*sin(toRadians(360*i/((TotalJumpFrame - 1) * 2))))

.label DopedLabel = SCREEN_RAM + c64lib_getTextOffset(1, 0)
.label DopedColorsLabel = c64lib.COLOR_RAM + c64lib_getTextOffset(1, 0)
.label DopedTextSize = 13
DopedText: .text "dino power!!!"

.label PositionX = 55
.label PositionY = 196

.label DINO_PTR = SCREEN_RAM + $3f8 + 6

#import "./_label.asm"
