#importonce

.filenamespace Dino

* = * "Dino.Init"
Init: {
    lda #PositionX
    sta c64lib.SPRITE_1_X
    lda #PositionY
    sta c64lib.SPRITE_1_Y

    lda #0
    sta IsJumping
    sta HandleJump.CurrentXFrame
}

* = * "Dino.SwitchDinoFrame"
SwitchDinoFrame: {
    lda IsJumping
    bne Done
    
    dec Waiter
    bne Done
    lda #WaitCount
    sta Waiter
    lda DINO_PTR
    cmp #SPRITES_OFFSET.DINO_1
    beq SwitchTo2
    lda #SPRITES_OFFSET.DINO_1
    jmp Change
    
  SwitchTo2:
    lda #SPRITES_OFFSET.DINO_2
  
  Change:
    sta DINO_PTR

  Done:
    rts
  
  .label WaitCount = 15
  Waiter: .byte WaitCount
}

* = * "Dino.Jump"
Jump: {
    lda IsJumping
    bne Done

    inc IsJumping

    lda #0
    sta HandleJump.CurrentXFrame

    lda #SPRITES_OFFSET.DINO_JMP
    sta DINO_PTR
  Done:
    rts
}

* = * "Dino.HandleJump"
HandleJump: {
    lda IsJumping
    beq Done

    ldx CurrentXFrame
    cpx #TotalJumpFrame
    beq ResetJump

    lda JumpMap,x
    sta c64lib.SPRITE_1_Y
    inc CurrentXFrame
    jmp Done

  ResetJump:
    lda #0
    sta IsJumping

  Done:
    rts

  CurrentXFrame: .byte 0
}

IsJumping: .byte 0

.label TotalJumpFrame = 31
JumpMap:
.fill TotalJumpFrame, round(PositionY - 50.5*sin(toRadians(360*i/60)))

.label PositionX = 55
.label PositionY = 196

#import "_label.asm"