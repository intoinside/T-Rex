#importonce

.segment Assets

* = $6000 "Sprites"
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
  .label DINO_DEAD = FIRST_SPRITE_PTR + 3

  .label CACTUS_1 = DINO_DEAD + 1
  .label CACTUS_6 = DINO_DEAD + 6

  .label PTERO_1 = CACTUS_6 + 1
  .label PTERO_2 = CACTUS_6 + 2
  .label PTERO_3 = CACTUS_6 + 3
  .label PTERO_4 = CACTUS_6 + 4

  .label SUN_1 = PTERO_4 + 1
  .label SUN_2 = PTERO_4 + 2
}

#import "./_label.asm"
