#importonce
/*
Sprite recap:

#0 - Bomb
#1 - Dino
#2 - Pterodactyl
#3 - Obstacle1
#4 - Obstacle2

#7 - Sun

*/

.macro SetupSprites() {
    lda #%11111111
    sta c64lib.SPRITE_COL_MODE

    lda #0
    sta c64lib.SPRITE_MSB_X
    lda c64lib.SPRITE_EXPAND_X
    lda c64lib.SPRITE_EXPAND_Y

    lda #SPRITES_OFFSET.DINO_1
    sta DINO_PTR

    lda #BLACK
    sta c64lib.SPRITE_COL_0
    lda #DARK_GRAY
    sta c64lib.SPRITE_COL_1

    lda #GREEN
    sta c64lib.SPRITE_1_COLOR

    jsr Dino.Init
    
    lda #%00000010
    sta c64lib.SPRITE_ENABLE
}

* = * "SwitchDinoFrame"
SwitchDinoFrame: {
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

.label DINO_PTR = SCREEN_RAM + $3f9

#import "_label.asm"
