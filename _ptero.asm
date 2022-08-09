#importonce

.filenamespace Ptero

* = * "Ptero.Init"
Init: {
    lda #PositionY
    sta c64lib.SPRITE_2_Y

    lda #SPRITES_OFFSET.PTERO_1
    sta PTERO_PTR

    lda #ORANGE
    sta c64lib.SPRITE_2_COLOR

    rts
}

* = * "Ptero.ShowIt"
/* Show the ptero */
ShowIt: {
    lda c64lib.SPRITE_ENABLE
    ora #%00000100
    sta c64lib.SPRITE_ENABLE

    lda #155
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
    GetRandomNumberFromMinimum(1)
    cmp #254
    bcs CreatePtero
    jmp !Done+

  CreatePtero:
    jsr Ptero.ShowIt
    jmp !Done+

// Ptero already shown, move it
  !MovePtero:
    ldx MapSpeedLandscape
  !Loop:
    lda c64lib.SPRITE_2_X
    sec
    sbc #3  // TIP: keep attention on SPRITE_2_X value in ShowIt
    sta c64lib.SPRITE_2_X
    cmp #255
    bne !NextIt+
    lda c64lib.SPRITE_MSB_X
    and #%11111011
    sta c64lib.SPRITE_MSB_X

  !NextIt:
    dex
    bne !Loop-

    jsr HasToSwitch

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

* = * "Ptero.HasToSwitch"
/* Detect is Ptero frame must be changed. */
HasToSwitch: {
    dec Waiter
    bne !Done+
    lda #WaitCount
    sta Waiter

  !Switch:
    lda AnimationForwarding
    bne !Forward+

  !BackWard:
    dec PTERO_PTR
    lda PTERO_PTR
    cmp #SPRITES_OFFSET.PTERO_1
    bcs !Done+
    inc PTERO_PTR
    inc AnimationForwarding

  !Forward:
    inc PTERO_PTR
    lda PTERO_PTR
    cmp #SPRITES_OFFSET.PTERO_4 + 1
    bcc !Done+
    dec PTERO_PTR
    dec AnimationForwarding
    jmp !BackWard-

  !Done:
    rts

  .label WaitCount = 5
  Waiter: .byte WaitCount
  AnimationForwarding: .byte 0
}

.label PositionY = 100

.label PTERO_PTR = SCREEN_RAM + $3f8 + 2

#import "./_label.asm"
