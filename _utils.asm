#importonce

.macro GetRandomNumberInRange(minNumber, maxNumber) {
    lda #minNumber
    sta Utils.GetRandom.GeneratorMin
    lda #maxNumber
    sta Utils.GetRandom.GeneratorMax
    jsr Utils.GetRandom
}

.filenamespace Utils

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

#import "./_label.asm"
