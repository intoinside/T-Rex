#importonce
/*
Sprite recap:
#0 - Dino

*/

.macro SetupSprites() {
    lda #%11111111
    sta c64lib.SPRITE_COL_MODE

    lda #0
    sta c64lib.SPRITE_MSB_X
    lda c64lib.SPRITE_EXPAND_X
    lda c64lib.SPRITE_EXPAND_Y

    lda #SPRITES_PTR.DINO_1
    sta SCREEN_RAM + $3f8

    lda #BLACK
    sta c64lib.SPRITE_COL_0
    lda #DARK_GRAY
    sta c64lib.SPRITE_COL_1

    lda #GREEN
    sta c64lib.SPRITE_0_COLOR

    lda #55
    sta c64lib.SPRITE_0_X
    lda #196
    sta c64lib.SPRITE_0_Y

    lda #%00000001
    sta c64lib.SPRITE_ENABLE
}

* = * "SwitchDinoFrame"
SwitchDinoFrame: {
    dec Waiter
    bne Done
    lda #WaitCount
    sta Waiter
    lda SCREEN_RAM + $3f8
    cmp #SPRITES_PTR.DINO_1
    beq SwitchTo2
    lda #SPRITES_PTR.DINO_1
    jmp Change
    
  SwitchTo2:
    lda #SPRITES_PTR.DINO_2
  
  Change:
    sta SCREEN_RAM + $3f8

  Done:
    rts
  
  .label WaitCount = 15
  Waiter: .byte WaitCount
}

#import "_label.asm"
