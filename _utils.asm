#importonce

.label ZeroPage1 = $02
.label ZeroPage2 = $03
.label ZeroPage3 = $04
.label ZeroPage4 = $05
.label ZeroPage5 = $06
.label ZeroPage6 = $07
.label ZeroPage7 = $08
.label ZeroPage8 = $09
.label ZeroPage9 = $0A
.label ZeroPage10 = $0B
.label ZeroPage11 = $0C
.label ZeroPage12 = $0D
.label ZeroPage13 = $0E
.label ZeroPage14 = $0F
.label ZeroPage15 = $10

#if DEBUG
.macro LIBSCREEN_DEBUG8BIT_VVA(bXPos, bYPos, bIn) {
    LIBMATH_8BITTOBCD_AA(bIn, ZeroPage4)
    lda ZeroPage4
    and #%00001111      // get low nibble
    ora #$30            // convert to ascii
    sta ZeroPage6
    LIBSCREEN_SETCHARACTER_S_VVA(bXPos+2, bYPos, ZeroPage6)
    lda ZeroPage4
    lsr                 // get high nibble
    lsr
    lsr
    lsr
    ora #$30            // convert to ascii
    sta ZeroPage6
    LIBSCREEN_SETCHARACTER_S_VVA(bXPos+1, bYPos, ZeroPage6)
    lda ZeroPage5
    and #%00001111      // get low nibble
    ora #$30            // convert to ascii
    sta ZeroPage6
    LIBSCREEN_SETCHARACTER_S_VVA(bXPos, bYPos, ZeroPage6)
}

.macro LIBSCREEN_SETCHARACTER_S_VVA(bXPos, bYPos, bChar) {
    lda #bXPos
    sta ZeroPage1
    lda #bYPos
    sta ZeroPage2
    lda bChar
    sta ZeroPage3
    jsr Utils.libScreenSetCharacter
}

.macro LIBMATH_8BITTOBCD_AA(bIn, wOut) {
    ldy bIn
    sty ZeroPage13  // Store in a temporary variable
    sed 		    // Switch to decimal mode
    lda #0          // Ensure the result is clear
    sta wOut
    sta wOut+1
    ldx #8		    // The number of source bits
  cnvBit:
    asl ZeroPage13	// Shift out one bit
    lda wOut        // And add into result
    adc wOut
    sta wOut
    lda wOut+1	    // propagating any carry
    adc wOut+1
    sta wOut+1
    dex		        // And repeat for next bit
    bne cnvBit
    cld		        // Back to binary
}
#endif

.macro AddPoints(digit2, digit1) {
    lda #digit1
    sta Utils.AddScore.Points + 4
    lda #digit2
    sta Utils.AddScore.Points + 3

    jsr Utils.AddScore
}

.macro AddPointsToCalculated(digit3, digit2, digit1) {
    lda #digit1
    sta Utils.AddPointsToCalculated.Points + 4
    lda #digit2
    sta Utils.AddPointsToCalculated.Points + 3
    lda #digit3
    sta Utils.AddPointsToCalculated.Points + 2

    jsr Utils.AddPointsToCalculated
}

.macro CalculatePoints(digit3, digit2, digit1) {
    lda #digit1
    sta Utils.CalculateScore.Points + 4
    lda #digit2
    sta Utils.CalculateScore.Points + 3
    lda #digit3
    sta Utils.CalculateScore.Points + 2

    jsr Utils.CalculateScore
}

.macro CopyCalculatedPoints(Source, Dest) {
  .for (var i = 0; i < 5; i++) {
    lda Source + i
    sta Dest + i
  }
}

/* Generates a random number up to 254. */
.macro GetRandomNumberFromMinimum(minNumber) {
    lda #minNumber
    sta Utils.GetRandom.GeneratorMin
    lda #255
    sta Utils.GetRandom.GeneratorMax
    jsr Utils.GetRandom
}

/* Generates a random number in a range. */
.macro GetRandomNumberInRange(minNumber, maxNumber) {
    .errorif (maxNumber == 255), "maxNumber can't be 255"
    lda #minNumber
    sta Utils.GetRandom.GeneratorMin
    lda #(maxNumber + 1)
    sta Utils.GetRandom.GeneratorMax
    jsr Utils.GetRandom
}

.filenamespace Utils

* = * "Utils.AddScore"
AddScore: {
    ldx #5
    clc
  !Loop:
    lda CurrentScore - 1, x
    adc Points - 1, x
    cmp #10
    bcc !SaveDigit+
    sbc #10
    sec

  !SaveDigit:
    sta CurrentScore - 1, x
    dex
    bne !Loop-

    jsr EvaluateSpeedUp
    jmp DrawScore   // jsr + rts

  Points: .byte 0, 0, 0, 0, 0
}

* = * "Utils.AddPointsToCalculated"
AddPointsToCalculated: {
    ldx #5
    clc
  !Loop:
    lda BasePoints - 1, x
    adc Points - 1, x
    cmp #10
    bcc !SaveDigit+
    sbc #10
    sec

  !SaveDigit:
    sta BasePoints - 1, x
    dex
    bne !Loop-

    rts

  Points: .byte 0, 0, 0, 0, 0
  BasePoints: .byte 0, 0, 0, 0, 0
}

* = * "Utils.CalculateScore"
CalculateScore: {
    ldx #5
    clc
  !Loop:
    lda CurrentScore - 1, x
    adc Points - 1, x
    cmp #10
    bcc !SaveDigit+
    sbc #10
    sec

  !SaveDigit:
    sta CalculatedScore - 1, x
    dex
    bne !Loop-

    rts

  Points: .byte 0, 0, 0, 0, 0
  CalculatedScore: .byte 0, 0, 0, 0, 0
}

* = * "Utils.AdjustScore"
/* Adjust precalculated score */
AdjustScore: {
    CopyCalculatedPoints(
      Dino.HandleSpeedRunText.AlertScorePoints,
      Utils.AddPointsToCalculated.BasePoints)
    AddPointsToCalculated(0, 5, 0)
    CopyCalculatedPoints(
      Utils.AddPointsToCalculated.BasePoints, 
      Dino.HandleSpeedRunText.AlertScorePoints)

    CopyCalculatedPoints(
      Dino.HandleSpeedRunText.EndDopedScorePoints,
      Utils.AddPointsToCalculated.BasePoints)
    AddPointsToCalculated(0, 5, 0)
    CopyCalculatedPoints(
      Utils.AddPointsToCalculated.BasePoints, 
      Dino.HandleSpeedRunText.EndDopedScorePoints)

    rts
}

* = * "Utils.EvaluateSpeedUp"
EvaluateSpeedUp: {
    lda CurrentScore + 2  // 100 pts
    cmp #1
    bne !SecondSpeedUp+
    lda MapSpeedForeground
    cmp #3
    bcs !Done+
    inc MapSpeedForeground
    jmp !Done+

  !SecondSpeedUp:
    lda CurrentScore + 2  // 200 pts
    cmp #2
    bcc !Done+
    lda MapSpeedForeground
    cmp #4
    bcs !Done+
    inc MapSpeedForeground

  !Done:
    rts
}

* = * "Utils.ResetScore"
ResetScore: {
    ldx #5
    lda #0
  !Loop:
    sta CurrentScore, x
    dex
    bne !Loop-

    jmp DrawScore   // jsr + rts
}

* = * "Utils.CompareAndUpdateHiScore"
/* Compare and update, if necessary, hiscore. */
CompareAndUpdateHiScore: {
    lda HiScoreLabel
    cmp ScoreOnScreen
    // If HiScore-digit-1 lower than Score-digit-1, update HiScore
    bcc !UpdateHiScore1+
    // If HiScore-digit-1 notlower notequal Score-digit-1, exit
    bne !Exit+
    // If HiScore-digit-1 equal Score-digit-1, continue check

    lda HiScoreLabel + 1
    cmp ScoreOnScreen + 1
    bcc !UpdateHiScore2+
    bne !Exit+

    lda HiScoreLabel + 2
    cmp ScoreOnScreen + 2
    bcc !UpdateHiScore3+
    bne !Exit+

    lda HiScoreLabel + 3
    cmp ScoreOnScreen + 3
    bcc !UpdateHiScore4+
    bne !Exit+

    lda HiScoreLabel + 4
    cmp ScoreOnScreen + 4
    bcc !UpdateHiScore5+
    jmp !Exit+

  !UpdateHiScore1:
    lda ScoreOnScreen
    sta HiScoreLabel
  !UpdateHiScore2:
    lda ScoreOnScreen + 1
    sta HiScoreLabel + 1
  !UpdateHiScore3:
    lda ScoreOnScreen + 2
    sta HiScoreLabel + 2
  !UpdateHiScore4:
    lda ScoreOnScreen + 3
    sta HiScoreLabel + 3
  !UpdateHiScore5:
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
  !Loop:
    lda CurrentScore, x
    adc #CHAR_POSITIONS.CHAR_0
    sta ScoreOnScreen, x
    inx
    cpx #$05
    bne !Loop-

    rts
}

* = * "Utils.GetRandom"
GetRandom: {
  !Loop:
    inc x1 + 1
    clc
  x1:
    lda #$00
  c1:
    eor #$c2
  a1:
    eor #$11
    sta a1 + 1
  b1:
    adc #$37
    sta b1 + 1
    lsr
    eor a1 + 1
    adc c1 + 1
    sta c1 + 1

    cmp GeneratorMax
    bcs !Loop-        // Back if greather or equal to GeneratorMax
    cmp GeneratorMin
    bcc !Loop-        // Back if lower than GeneratorMin

    rts

    GeneratorMin: .byte $00
    GeneratorMax: .byte $00
}

#if DEBUG
wSCREEN_RAMRowStart: // SCREEN_RAM + 40*0, 40*1, 40*2, 40*3, 40*4 ... 40*24
    .word SCREEN_RAM,     SCREEN_RAM+40,  SCREEN_RAM+80,  SCREEN_RAM+120, SCREEN_RAM+160
    .word SCREEN_RAM+200, SCREEN_RAM+240, SCREEN_RAM+280, SCREEN_RAM+320, SCREEN_RAM+360
    .word SCREEN_RAM+400, SCREEN_RAM+440, SCREEN_RAM+480, SCREEN_RAM+520, SCREEN_RAM+560
    .word SCREEN_RAM+600, SCREEN_RAM+640, SCREEN_RAM+680, SCREEN_RAM+720, SCREEN_RAM+760
    .word SCREEN_RAM+800, SCREEN_RAM+840, SCREEN_RAM+880, SCREEN_RAM+920, SCREEN_RAM+960

libScreenSetCharacter: {
    lda ZeroPage2               // load y position as index into list
    asl                         // X2 as table is in words
    tay                         // Copy A to Y
    lda wSCREEN_RAMRowStart,Y    // load low address byte
    sta ZeroPage9
    lda wSCREEN_RAMRowStart+1,Y  // load high address byte
    sta ZeroPage10
    ldy ZeroPage1               // load x position into Y register
    lda ZeroPage3
    sta (ZeroPage9),Y
    rts
}
#endif

.label ScoreOnScreen = SCREEN_RAM + c64lib_getTextOffset(34, 1)
.label HiScoreLabel = MAP + c64lib_getTextOffset(34, 0);

CurrentScore: .byte 0, 0, 0, 0, 0

#import "./_label.asm"
