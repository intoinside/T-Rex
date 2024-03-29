#importonce

.macro IsReturnPressed() {
    lda #%11111110
    sta Keyboard.DetectKeyPressed.MaskOnPortA
    lda #%00000010
    sta Keyboard.DetectKeyPressed.MaskOnPortB
    jsr Keyboard.DetectKeyPressed
    sta Keyboard.ReturnPressed
}

.macro IsReturnPressedAndReleased() {
  !:
    IsReturnPressed()
    beq !-
  !:
    jsr Keyboard.DetectKeyPressed
    bne !-
}

.macro IsSpacePressed() {
    lda #%01111111
    sta Keyboard.DetectKeyPressed.MaskOnPortA
    lda #%00010000
    sta Keyboard.DetectKeyPressed.MaskOnPortB
    jsr Keyboard.DetectKeyPressed
    sta Keyboard.SpacePressed
}

.macro IsSpacePressedAndReleased() {
  !:
    IsSpacePressed()
    beq !-
  !:
    jsr Keyboard.DetectKeyPressed
    bne !-
}

.filenamespace Keyboard

Init: {
    lda #1
    sta KEYB.BUFFER_LEN     // disable keyboard buffer
    lda #127
    sta KEYB.REPEAT_SWITCH  // disable key repeat

    rts
}

* = * "Keyboard DetectKeyPressed"
DetectKeyPressed: {
    sei
    lda #%11111111
    sta c64lib.CIA1_DATA_DIR_A
    lda #%00000000
    sta c64lib.CIA1_DATA_DIR_B

    lda MaskOnPortA
    sta c64lib.CIA1_DATA_PORT_A
    lda c64lib.CIA1_DATA_PORT_B
    and MaskOnPortB
    beq Pressed
    lda #$00
    jmp !+
  Pressed:
    lda #$01
  !:
    cli
    rts

  MaskOnPortA:    .byte $00
  MaskOnPortB:    .byte $00
}

KEYB: {
  .label CURRENT_PRESSED    = $00cb
  .label BUFFER_LEN         = $0289
  .label REPEAT_SWITCH      = $028a
}

ReturnPressed: .byte $00
SpacePressed: .byte $00

#import "./_label.asm"
