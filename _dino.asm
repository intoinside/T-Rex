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
    lda #%00011010
    and c64lib.SPRITE_2S_COLLISION

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

.label PositionX = 55
.label PositionY = 196

.label DINO_PTR = SCREEN_RAM + $3f8 + 1

#import "./_label.asm"
