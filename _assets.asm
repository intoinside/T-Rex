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

#import "./_label.asm"
