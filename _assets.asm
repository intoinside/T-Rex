#importonce

.segment Assets

* = $5000 "Sprites"
SPRITES:
  .import binary "./assets/sprites.bin"

* = $7000 "CharMemory"
CHAR_MEMORY:
  .import binary "./assets/charset.bin"

* = $7800 "Map"
MAP:
  .import binary "./assets/map.bin"

* = * "ColorMap"
COLOR_MAP:
  .import binary "./assets/colors.bin"

* = $c000 "Sounds"
SOUNDS:
.byte $bd,$a7,$c2,$99,$68,$c2,$bd,$a8,$c2,$99,$6b,$c2,$bd,$ab,$c2,$99
.byte $74,$c2,$bd,$ac,$c2,$99,$77,$c2,$bd,$a9,$c2,$99,$6e,$c2,$bd,$aa
.byte $c2,$99,$71,$c2,$60,$bd,$ad,$c2,$99,$68,$c2,$bd,$ae,$c2,$99,$6b
.byte $c2,$bd,$b1,$c2,$99,$74,$c2,$bd,$b2,$c2,$99,$77,$c2,$bd,$af,$c2
.byte $99,$6e,$c2,$bd,$b0,$c2,$99,$71,$c2,$60,$99,$5c,$c2,$aa,$98,$48
.byte $b9,$59,$c2,$85,$fe,$a9,$d4,$85,$ff,$bd,$a5,$c2,$99,$62,$c2,$bd
.byte $a6,$c2,$99,$65,$c2,$bd,$9c,$c2,$99,$86,$c2,$bd,$9d,$c2,$99,$89
.byte $c2,$bd,$9e,$c2,$99,$8c,$c2,$bd,$9b,$c2,$c9,$41,$d0,$18,$bd,$a1
.byte $c2,$99,$8f,$c2,$bd,$a2,$c2,$99,$92,$c2,$bd,$a3,$c2,$99,$95,$c2
.byte $bd,$a4,$c2,$99,$98,$c2,$a9,$00,$99,$7a,$c2,$99,$7d,$c2,$99,$80
.byte $c2,$99,$83,$c2,$20,$00,$c0,$bd,$9b,$c2,$c9,$41,$d0,$0d,$a0,$02
.byte $bd,$a1,$c2,$91,$fe,$c8,$bd,$a2,$c2,$91,$fe,$bd,$9f,$c2,$a0,$05
.byte $91,$fe,$bd,$a0,$c2,$c8,$91,$fe,$bd,$9b,$c2,$a0,$04,$91,$fe,$68
.byte $a8,$a9,$00,$99,$5f,$c2,$60,$b9,$5c,$c2,$c9,$ff,$f0,$f8,$aa,$b9
.byte $59,$c2,$85,$fe,$a9,$d4,$85,$ff,$b9,$5f,$c2,$c9,$02,$f0,$18,$4c
.byte $16,$c1,$a9,$ff,$99,$5c,$c2,$b9,$59,$c2,$85,$fe,$a9,$d4,$85,$ff
.byte $a9,$00,$a0,$04,$91,$fe,$60,$a9,$ff,$99,$5c,$c2,$bd,$9b,$c2,$29
.byte $fe,$a0,$04,$91,$fe,$60,$86,$fc,$84,$fd,$a6,$fd,$bd,$8c,$c2,$f0
.byte $5b,$a0,$00,$18,$bd,$62,$c2,$7d,$7d,$c2,$91,$fe,$c8,$bd,$65,$c2
.byte $7d,$80,$c2,$91,$fe,$bd,$83,$c2,$d0,$24,$18,$bd,$7d,$c2,$7d,$86
.byte $c2,$9d,$7d,$c2,$bd,$80,$c2,$7d,$89,$c2,$9d,$80,$c2,$fe,$7a,$c2
.byte $bd,$7a,$c2,$dd,$8c,$c2,$d0,$31,$fe,$83,$c2,$4c,$89,$c1,$38,$bd
.byte $7d,$c2,$fd,$86,$c2,$9d,$7d,$c2,$bd,$80,$c2,$fd,$89,$c2,$9d,$80
.byte $c2,$de,$7a,$c2,$d0,$13,$de,$83,$c2,$4c,$89,$c1,$a0,$00,$bd,$62
.byte $c2,$91,$fe,$bd,$65,$c2,$c8,$91,$fe,$a4,$fc,$b9,$9b,$c2,$c9,$41
.byte $d0,$3b,$a0,$02,$bd,$8f,$c2,$91,$fe,$c8,$bd,$92,$c2,$91,$fe,$bd
.byte $5f,$c2,$d0,$16,$18,$bd,$8f,$c2,$7d,$95,$c2,$9d,$8f,$c2,$bd,$92
.byte $c2,$7d,$98,$c2,$9d,$92,$c2,$4c,$cd,$c1,$38,$bd,$8f,$c2,$fd,$95
.byte $c2,$9d,$8f,$c2,$bd,$92,$c2,$fd,$98,$c2,$9d,$92,$c2,$18,$bd,$62
.byte $c2,$7d,$68,$c2,$9d,$62,$c2,$bd,$65,$c2,$7d,$6b,$c2,$9d,$65,$c2
.byte $30,$3a,$18,$bd,$68,$c2,$7d,$6e,$c2,$9d,$68,$c2,$bd,$6b,$c2,$7d
.byte $71,$c2,$9d,$6b,$c2,$bd,$6b,$c2,$10,$11,$bd,$65,$c2,$dd,$77,$c2
.byte $d0,$06,$98,$dd,$74,$c2,$f0,$14,$90,$12,$60,$bd,$65,$c2,$dd,$77
.byte $c2,$90,$08,$d0,$07,$98,$dd,$74,$c2,$b0,$01,$60,$fe,$5f,$c2,$bd
.byte $5f,$c2,$c9,$01,$d0,$07,$a6,$fc,$a4,$fd,$20,$25,$c0,$60,$a0,$00
.byte $20,$d7,$c0,$ad,$0d,$dc,$40,$a0,$00,$20,$d7,$c0,$a0,$01,$20,$d7
.byte $c0,$a0,$02,$4c,$d7,$c0,$20,$37,$c2,$4c,$31,$ea,$78,$a9,$46,$8d
.byte $14,$03,$a9,$c2,$8d,$15,$03,$58,$60,$00,$07,$0e,$ff,$ff,$ff,$02
.byte $00,$00,$69,$00,$00,$19,$00,$00,$15,$00,$00,$ff,$00,$00,$fd,$00
.byte $00,$ff,$00,$00,$62,$00,$00,$19,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$11,$00,$00,$00,$7a
.byte $a9,$00,$00,$00,$00,$46,$1b,$52,$00,$64,$00,$e8,$2d,$72,$ff,$fd
.byte $ff,$62,$19

CHAR_POSITIONS: {
  .label CHAR_0 = 48;
  .label CHAR_9 = 57;
}

SPRITES_OFFSET: {
  .label FIRST_SPRITE_PTR = ((SPRITES - SCREEN_RAM) / 64)
  .label DINO_1 = FIRST_SPRITE_PTR
  .label DINO_2 = FIRST_SPRITE_PTR + 1
  .label DINO_JMP = FIRST_SPRITE_PTR + 2
  .label DINO_DOPED_1 = FIRST_SPRITE_PTR + 3
  .label DINO_DOPED_2 = FIRST_SPRITE_PTR + 4
  .label DINO_DOPED_JMP = FIRST_SPRITE_PTR + 5
  .label DINO_DEAD = FIRST_SPRITE_PTR + 6

  .label PTERO_1 = DINO_DEAD + 1
  .label PTERO_2 = DINO_DEAD + 2
  .label PTERO_3 = DINO_DEAD + 3
  .label PTERO_4 = DINO_DEAD + 4

  .label SUN_1 = PTERO_4 + 1
  .label SUN_2 = PTERO_4 + 2

  .label CACTUS_1 = SUN_2 + 1
  .label CACTUS_2 = SUN_2 + 2
  .label CACTUS_3 = SUN_2 + 3
  .label CACTUS_4 = SUN_2 + 4
  .label CACTUS_5 = SUN_2 + 5
  .label CACTUS_6 = SUN_2 + 6

  .label ROCK_1 = CACTUS_6 + 1
  .label ROCK_2 = CACTUS_6 + 2

  .label MUSHROOM = ROCK_2 + 1

  .label CACTUS_EXP_1 = MUSHROOM + 1
  .label CACTUS_EXP_2 = MUSHROOM + 2
  .label CACTUS_EXP_3 = MUSHROOM + 3
  .label CACTUS_EXP_4 = MUSHROOM + 4
  .label CACTUS_EXP_5 = MUSHROOM + 5
  .label CACTUS_EXP_6 = MUSHROOM + 6
  .label CACTUS_EXP_7 = MUSHROOM + 7
  .label CACTUS_EXP_8 = MUSHROOM + 8
  .label CACTUS_EXP_9 = MUSHROOM + 9
  .label CACTUS_EXP_A = MUSHROOM + 10

  .label ROCK_EXP_1 = CACTUS_EXP_A + 1
  .label ROCK_EXP_2 = CACTUS_EXP_A + 2
  .label ROCK_EXP_3 = CACTUS_EXP_A + 3
  .label ROCK_EXP_4 = CACTUS_EXP_A + 4
  .label ROCK_EXP_5 = CACTUS_EXP_A + 5
  .label ROCK_EXP_6 = CACTUS_EXP_A + 6
  .label ROCK_EXP_7 = CACTUS_EXP_A + 7
  .label ROCK_EXP_8 = CACTUS_EXP_A + 8

  .print "FIRST_SPRITE_PTR="+FIRST_SPRITE_PTR
  .print "PTERO_1="+PTERO_1
  .print "SUN_1="+SUN_1
  .print "CACTUS_1="+CACTUS_1
  .print "ROCK_1="+ROCK_1
  .print "MUSHROOM="+MUSHROOM
}

#import "./_label.asm"
