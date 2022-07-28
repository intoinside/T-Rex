#importonce

.filenamespace Ptero

* = * "Ptero.Init"
Init: {
    lda #PositionY
    sta c64lib.SPRITE_2_Y

    lda #SPRITES_OFFSET.PTERO_1
    sta PTERO_PTR

    lda #GREEN
    sta c64lib.SPRITE_2_COLOR

    rts
}

* = * "Ptero.ShowIt"
/* Show the ptero */
ShowIt: {
    lda c64lib.SPRITE_ENABLE
    ora #%00000100
    sta c64lib.SPRITE_ENABLE

    lda #150
    sta c64lib.SPRITE_2_X
    lda c64lib.SPRITE_MSB_X
    ora #%00000100
    sta c64lib.SPRITE_MSB_X

    rts
}

* = * "Ptero.MoveIt"
/* Moves the ptero according to foreground speed */
MoveIt: {
    lda c64lib.SPRITE_ENABLE
    and #%00000100
    bne !MovePtero+

// Ptero is hidden, check if should be created
    GetRandomNumberInRange(1, 255)
    cmp #254
    bcs CreatePtero
    jmp !Done+

  CreatePtero:
    jsr Ptero.ShowIt
    jmp !Done+

// Ptero already shown, move it
  !MovePtero:
    ldx MapSpeedLandscape
  !:
    dec c64lib.SPRITE_2_X
    lda c64lib.SPRITE_2_X
    cmp #255
    bne !NextIt+
    lda c64lib.SPRITE_MSB_X
    and #%11111011
    sta c64lib.SPRITE_MSB_X

  !NextIt:
    dex
    bne !-

    lda c64lib.SPRITE_2_X
    cmp #10
    bcs !Done+
    lda c64lib.SPRITE_MSB_X
    and #%00000100
    bne !Done+

    lda c64lib.SPRITE_ENABLE
    and #%11111011
    sta c64lib.SPRITE_ENABLE

  !Done:
    rts
}

.label PositionY = 100

.label PTERO_PTR = SCREEN_RAM + $3f8 + 2

#import "./_label.asm"
