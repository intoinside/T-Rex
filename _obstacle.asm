#importonce

.filenamespace Obstacle

* = * "Obstacle.Init"
Init: {
    lda #PositionY
    sta c64lib.SPRITE_3_Y
    sta c64lib.SPRITE_5_Y

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
    lda OBSTACLE_1_PTR
#endif
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

* = * "Obstacle.PrepareMushroom"
PrepareMushroom: {
    lda #SPRITES_OFFSET.MUSHROOM
    sta MUSHROOM_PTR

    lda #LIGHT_RED
    sta c64lib.SPRITE_5_COLOR

    rts
}

.label ObstacleStartX = 150

* = * "Obstacle.ShowObstacle"
/* Show the obstacle */
ShowObstacle: {
    lda c64lib.SPRITE_ENABLE
    ora #%00001000
    sta c64lib.SPRITE_ENABLE

    lda #ObstacleStartX
    sta c64lib.SPRITE_3_X
    lda c64lib.SPRITE_MSB_X
    ora #%00001000
    sta c64lib.SPRITE_MSB_X

    jsr Sun.SwitchFrame
    rts
}

* = * "Obstacle.ShowMushroom"
/* Show the mushroom */
ShowMushroom: {
    lda Dino.IsDoped
    bne !Done+

    lda c64lib.SPRITE_ENABLE
    ora #%00100000
    sta c64lib.SPRITE_ENABLE

    lda #ObstacleStartX + 25
    sta c64lib.SPRITE_5_X
    lda c64lib.SPRITE_MSB_X
    ora #%00100000
    sta c64lib.SPRITE_MSB_X

  !Done:
    rts
}

* = * "Obstacle.HideMushroom"
/* Hide the mushroom */
HideMushroom: {
    lda c64lib.SPRITE_ENABLE
    and #%11011111
    sta c64lib.SPRITE_ENABLE

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
    jsr Obstacle.PrepareMushroom

    jsr Obstacle.ShowObstacle
    jsr Obstacle.ShowMushroom
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

* = * "Obstacle.MoveMushroom"
/* Moves the mushroom according to foreground speed */
MoveMushroom: {
    lda c64lib.SPRITE_ENABLE
    and #%00100000
    bne MoveIt

// Mushroom already shown, move it
  MoveIt:
    ldx MapSpeedForeground
  !:
    dec c64lib.SPRITE_5_X
    lda c64lib.SPRITE_5_X
    cmp #255
    bne NextIt
    lda c64lib.SPRITE_MSB_X
    and #%11011111
    sta c64lib.SPRITE_MSB_X

  NextIt:
    dex
    bne !-

    lda c64lib.SPRITE_5_X
    cmp #134
    bcs !HasDone+

  !HasDone:
    cmp #10
    bcs !Done+
    lda c64lib.SPRITE_MSB_X
    and #%00100000
    bne !Done+

    lda c64lib.SPRITE_ENABLE
    and #%11011111
    sta c64lib.SPRITE_ENABLE

  !Done:
    rts
}

* = * "Obstacle.Collided"
Collided: {
    lda #%01001000
    and Dino.Sprite2SpriteCollision
    cmp #%01001000
    beq !Collided+

    lda #0
    jmp !Done+

  !Collided:
    lda #1

  !Done:    
    sta IsExploding
    rts
}

* = * "Obstacle.Explodes"
/* Handle the obstacle explosion */
Explodes: {
    lda IsExploding
    beq !Done+

    lda Waiter
    eor #$ff
    sta Waiter
    beq !Done+

    ldx OBSTACLE_1_PTR
    cpx #SPRITES_OFFSET.CACTUS_6 + 1
    bcs !NoCactus+

// It's a cactus not exploded, give points and start explosion
    jsr Utils.AdjustScore
    PlaySound(12, 1, 1)
    AddPoints(5, 0)
    ldx #SPRITES_OFFSET.CACTUS_EXP_1
    jmp !SetShape+

  !NoCactus:
    cpx #SPRITES_OFFSET.ROCK_2 + 1
    bcs !NoRock+

// It's a rock not exploded, give points and start explosion
    jsr Utils.AdjustScore
    PlaySound(12, 1, 1)
    AddPoints(5, 0)
    ldx #SPRITES_OFFSET.ROCK_EXP_1
    jmp !SetShape+

// No cactus and no rock, explosion already in progress
  !NoRock:
    inx
    cpx #SPRITES_OFFSET.CACTUS_EXP_A + 1
    beq !ExpDone+

    cpx #SPRITES_OFFSET.ROCK_EXP_8 + 1
    beq !ExpDone+

// Explosion in progress, going to next frame
    jmp !SetShape+
    
  !ExpDone:
    lda c64lib.SPRITE_ENABLE
    and #%11110111
    sta c64lib.SPRITE_ENABLE
    dec IsExploding
    jmp !Done+

  !SetShape:
    stx OBSTACLE_1_PTR
  !Done:
    rts

  Waiter: .byte 0
}

IsExploding: .byte 0

.label PositionY = 198

.label OBSTACLE_1_PTR = SCREEN_RAM + $3f8 + 3
.label MUSHROOM_PTR = SCREEN_RAM + $3f8 + 5

#import "./_label.asm"
