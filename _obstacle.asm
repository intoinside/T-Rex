#importonce

.filenamespace Obstacle

* = * "Obstacle.Init"
Init: {
    lda #PositionY
    sta c64lib.SPRITE_3_Y

    rts
}

* = * "Obstacle.PrepareCactus"
PrepareCactus: {
    lda #GREEN
    sta c64lib.SPRITE_3_COLOR

    lda #SPRITES_OFFSET.CACTUS_1
    sta OBSTACLE_1_PTR

    rts
}

* = * "Obstacle.ShowObstacle"
/* Show the obstacle */
ShowObstacle: {
    lda c64lib.SPRITE_ENABLE
    ora #%00001000
    sta c64lib.SPRITE_ENABLE

    lda #150
    sta c64lib.SPRITE_3_X
    lda c64lib.SPRITE_MSB_X
    ora #%00001000
    sta c64lib.SPRITE_MSB_X

    rts
}

* = * "Obstacle.MoveObstacle"
/* Moves the obstacle according to foreground speed */
MoveObstacle: {
    lda c64lib.SPRITE_ENABLE
    and #%00001000
    bne MoveIt

// Obstacle is hidden, check if should be created
    GetRandomNumberInRange(1, 255)
    cmp #253
    bcs CreateObstacle
    jmp Done

  CreateObstacle:
    jsr Obstacle.ShowObstacle
    jmp Done

// Obstacle already shown, move it
  MoveIt:
    ldx MapSpeedForeground
  !:
    dec c64lib.SPRITE_3_X
    lda c64lib.SPRITE_3_X
    cmp #255
    bne NextIt
    lda c64lib.SPRITE_MSB_X
    and #%11110111
    sta c64lib.SPRITE_MSB_X

  NextIt:
    dex
    bne !-

    lda c64lib.SPRITE_3_X
    cmp #10
    bcs Done
    lda c64lib.SPRITE_MSB_X
    and #%00001000
    bne Done

    lda c64lib.SPRITE_ENABLE
    and #%11110111
    sta c64lib.SPRITE_ENABLE

  Done:
    rts
}

.label PositionY = 196

.label OBSTACLE_1_PTR = SCREEN_RAM + $3f8 + 3

#import "./_label.asm"
