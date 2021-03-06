#importonce

.filenamespace Sun

* = * "Sun.Init"
Init: {
    lda #PositionX
    sta c64lib.SPRITE_7_X
    lda #PositionY
    sta c64lib.SPRITE_7_Y

    lda #SPRITES_OFFSET.SUN_1
    sta SUN_PTR

    lda #YELLOW
    sta c64lib.SPRITE_7_COLOR

    lda c64lib.SPRITE_PRIORITY
    ora #%10000000
    sta c64lib.SPRITE_PRIORITY

    lda c64lib.SPRITE_ENABLE
    ora #%10000000
    sta c64lib.SPRITE_ENABLE

    rts
}

* = * "Sun.SwitchFrame"
SwitchFrame: {
    pha
    lda #SPRITES_OFFSET.SUN_2
    sta SUN_PTR
    pla

    rts
}

* = * "Sun.ResetFrame"
ResetFrame: {
    pha
    lda #SPRITES_OFFSET.SUN_1
    sta SUN_PTR
    pla

    rts
}

.label PositionX = 255
.label PositionY = 68

.label SUN_PTR = SCREEN_RAM + $3f8 + 7

#import "./_label.asm"
