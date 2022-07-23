#importonce

.macro AddPoints(digit2, digit1) {
    lda #digit1
    sta Utils.AddScore.Points + 4
    lda #digit2
    sta Utils.AddScore.Points + 3

    jsr Utils.AddScore
}

.macro GetRandomNumberInRange(minNumber, maxNumber) {
    lda #minNumber
    sta Utils.GetRandom.GeneratorMin
    lda #maxNumber
    sta Utils.GetRandom.GeneratorMax
    jsr Utils.GetRandom
}

.filenamespace Utils

* = * "Utils.AddScore"
AddScore: {
    ldx #5
    clc
  !:
    lda CurrentScore - 1, x
    adc Points - 1, x
    cmp #10
    bcc SaveDigit
    sbc #10
    sec

  SaveDigit:
    sta CurrentScore - 1, x
    dex
    bne !-

  Done:
    jmp DrawScore   // jsr + rts

  Points: .byte $00, $00, $00, $00, $00
}

* = * "Utils.ResetScore"
ResetScore: {
    ldx #5
    lda #0
  !:
    sta CurrentScore, x
    dex
    bne !-

    jmp DrawScore   // jsr + rts
}

* = * "Utils.DrawScore"
DrawScore: {
  // Append current score on score label
    ldx #0
    clc
  !:
    lda CurrentScore, x
    adc #CHAR_POSITIONS.CHAR_0
    sta ScoreOnScreen, x
    inx
    cpx #$05
    bne !-

    rts
}

* = * "Utils.GetRandom"
GetRandom: {
  Loop:
    lda c64lib.RASTER
    eor $dc04
    sbc $dc05
    cmp GeneratorMax
    bcs Loop
    cmp GeneratorMin
    bcc Loop

    rts

    GeneratorMin: .byte $00
    GeneratorMax: .byte $00
}

CurrentScore: .byte 0, 0, 0, 0, 0

#import "./_label.asm"
