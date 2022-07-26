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
    sta c64lib.SPRITE_ENABLE

    lda #BLACK
    sta c64lib.SPRITE_COL_0
    lda #DARK_GRAY
    sta c64lib.SPRITE_COL_1
}

#import "./_label.asm"
