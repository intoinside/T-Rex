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

SPRITES_OFFSET: {
  .label FIRST_SPRITE_PTR = ((SPRITES - SCREEN_RAM) / 64)
  .label DINO_1 = FIRST_SPRITE_PTR
  .label DINO_2 = FIRST_SPRITE_PTR + 1
  .label DINO_JMP = FIRST_SPRITE_PTR + 2
}

#import "./_label.asm"
