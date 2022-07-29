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

* = * "Utils.CompareAndUpdateHiScore"
/* Compare and update, if necessary, hiscore. */
CompareAndUpdateHiScore: {
    lda HiScoreLabel
    cmp ScoreOnScreen
    // If HiScore-digit-1 lower than Score-digit-1, update HiScore
    bcc UpdateHiScore1
    // If HiScore-digit-1 notlower notequal Score-digit-1, exit
    bne !Exit+
    // If HiScore-digit-1 equal Score-digit-1, continue check

    lda HiScoreLabel + 1
    cmp ScoreOnScreen + 1
    bcc UpdateHiScore2
    bne !Exit+

    lda HiScoreLabel + 2
    cmp ScoreOnScreen + 2
    bcc UpdateHiScore3
    bne !Exit+

    lda HiScoreLabel + 3
    cmp ScoreOnScreen + 3
    bcc UpdateHiScore4
    bne !Exit+

    lda HiScoreLabel + 4
    cmp ScoreOnScreen + 4
    bcc UpdateHiScore5
    jmp !Exit+

  UpdateHiScore1:
    lda ScoreOnScreen
    sta HiScoreLabel
  UpdateHiScore2:
    lda ScoreOnScreen + 1
    sta HiScoreLabel + 1
  UpdateHiScore3:
    lda ScoreOnScreen + 2
    sta HiScoreLabel + 2
  UpdateHiScore4:
    lda ScoreOnScreen + 3
    sta HiScoreLabel + 3
  UpdateHiScore5:
    lda ScoreOnScreen + 4
    sta HiScoreLabel + 4

  !Exit:
    rts
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

.label ScoreOnScreen = SCREEN_RAM + c64lib_getTextOffset(34, 1)
.label HiScoreLabel = MAP + c64lib_getTextOffset(34, 0);

CurrentScore: .byte 0, 0, 0, 0, 0

#import "./_label.asm"
