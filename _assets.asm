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

CHAR_POSITIONS: {
  .label CHAR_0 = 48;
  .label CHAR_9 = 57;
}

SPRITES_OFFSET: {
  .label FIRST_SPRITE_PTR = ((SPRITES - SCREEN_RAM) / 64)
  .label DINO_1 = FIRST_SPRITE_PTR
  .label DINO_2 = FIRST_SPRITE_PTR + 1
  .label DINO_JMP = FIRST_SPRITE_PTR + 2
  .label DINO_FAST_1 = FIRST_SPRITE_PTR + 3
  .label DINO_FAST_2 = FIRST_SPRITE_PTR + 4
  .label DINO_FAST_JMP = FIRST_SPRITE_PTR + 5
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

  .print "FIRST_SPRITE_PTR="+FIRST_SPRITE_PTR
  .print "PTERO_1="+PTERO_1
  .print "SUN_1="+SUN_1
  .print "CACTUS_1="+CACTUS_1
  .print "ROCK_1="+ROCK_1
  .print "MUSHROOM="+MUSHROOM
}

#import "./_label.asm"
