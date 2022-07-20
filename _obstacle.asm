#importonce

.filenamespace Obstacle

* = * "Obstacle.Init"
Init: {
    lda #255
    sta c64lib.SPRITE_3_X
    lda #PositionY
    sta c64lib.SPRITE_3_Y

    rts
}

PrepareCactus: {
    lda #GREEN
    sta c64lib.SPRITE_3_COLOR

    lda #SPRITES_OFFSET.CACTUS_1
    sta OBSTACLE_1_PTR

    rts
}

ShowObstacle: {
    lda c64lib.SPRITE_ENABLE
    ora #%00001000
    sta c64lib.SPRITE_ENABLE

    rts
}

.label PositionY = 196

.label OBSTACLE_1_PTR = SCREEN_RAM + $3f8 + 3

#import "_label.asm"
