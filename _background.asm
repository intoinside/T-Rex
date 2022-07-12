
.macro SetupRasterIrq(line, irq) {
    sei

    // Disattiva gli interrupt che possono arrivare dalla CIA-1
    lda #%01111111
    sta $dc0d

    // Azzera il bit 7 del registro raster del Vic-II
    and $d011  
    sta $d011

    // Conferma per gli interrupt generati da CIA-1 e CIA-2
    lda $dc0d
    lda $dd0d

    ChangeRasterIrq(line, irq)
    
    // Abilita gli interrupt del Vic-II
    lda #%00000001
    sta $d01a

    // Abilito tutti gli sprite
    lda #%11111111
    sta $d015

    // Riabilito il lancio degli interrupt
    cli
}

.macro ChangeRasterIrq(line, irq) {
// Imposto il primo interrupt alla riga 149
    lda #line    
    sta $d012

// Imposto la routine all'indirizzo Irq
    lda #<irq   
    sta $0314
    lda #>irq
    sta $0315
}

.macro ManyNop(nopCount) {
    .for (var i = 0; i < nopCount; i++) {
      nop
    }
}

Irq0: {
    lda #$ff
    sta $d019

    lda #CYAN
    sta $d020
    sta $d021

    ChangeRasterIrq(80, Irq1)  
  
    jmp $ea81
}

Irq1: {
    lda #$ff
    sta $d019

    ManyNop(6)

    lda #LIGHT_GRAY
    sta $d020
    sta $d021

    ChangeRasterIrq(82, Irq2)  
  
    jmp $ea81
}

Irq2: {
    lda #$ff
    sta $d019

    ManyNop(15)

    lda #CYAN
    sta $d020
    sta $d021

    ChangeRasterIrq(84, Irq3)  
  
    jmp $ea81
}

Irq3: {
    lda #$ff
    sta $d019

    ManyNop(17)

    lda #LIGHT_GRAY
    sta $d020
    sta $d021

    ChangeRasterIrq(87, Irq4)  

    jmp $ea81
}

Irq4: {
    lda #$ff
    sta $d019

    ManyNop(4)

    lda #CYAN
    sta $d020
    sta $d021

    ChangeRasterIrq(89, Irq5)  

    jmp $ea81
}

Irq5: {
    lda #$ff
    sta $d019

    ManyNop(6)

    lda #LIGHT_GRAY
    sta $d020
    sta $d021

    ChangeRasterIrq(10, Irq0)  

    jmp $ea81
}
