#importonce

.filenamespace Obstacle

* = * "Obstacle.Init"
Init: {
    lda #PositionY
    sta c64lib.SPRITE_3_Y

    rts
}

* = * "Obstacle.PrepareOstacle"
PrepareOstacle: {
    GetRandomNumberInRange(0, (SPRITES_OFFSET.ROCK_2 - SPRITES_OFFSET.CACTUS_1))
    clc
    adc #SPRITES_OFFSET.CACTUS_1
    sta OBSTACLE_1_PTR
#if DEBUG
    LIBSCREEN_DEBUG8BIT_VVA(8, 1, OBSTACLE_1_PTR)
#endif

    lda OBSTACLE_1_PTR
    cmp #SPRITES_OFFSET.ROCK_1
    bcc !SetGreen+

  !SetGray:
    lda #LIGHT_GRAY
    jmp !Done+

  !SetGreen:
    lda #GREEN

  !Done:
    sta c64lib.SPRITE_3_COLOR

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

    jsr Sun.SwitchFrame
    rts
}

* = * "Obstacle.MoveObstacle"
/* Moves the obstacle according to foreground speed */
MoveObstacle: {
    lda c64lib.SPRITE_ENABLE
    and #%00001000
    bne MoveIt

  DontMoveIt:  
// Obstacle is hidden, check if should be created
    GetRandomNumberFromMinimum(1)
    cmp #250
    bcs CreateObstacle
    jmp Done

  CreateObstacle:
    jsr Obstacle.PrepareOstacle

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
    cmp #134
    bcs !HasDone+
    jsr Sun.ResetFrame

  !HasDone:
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

.label PositionY = 198

.label OBSTACLE_1_PTR = SCREEN_RAM + $3f8 + 3

#import "./_label.asm"
