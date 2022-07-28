#importonce

CIA1: {
  .label PORT_A             = $dc00
  .label PORT_B             = $dc01
  .label PORT_A_DIRECTION   = $dc02
  .label PORT_B_DIRECTION   = $dc03
}

CIA2: {
  .label PORT_A             = $dd00
}

#import "./_background.asm"
#import "./_sprites.asm"
#import "./_keyboard.asm"
#import "./_dino.asm"
#import "./_obstacle.asm"
#import "./_sun.asm"
#import "./_ptero.asm"
#import "./_utils.asm"
#import "./_assets.asm"
#import "./chipset/lib/sprites.asm"
#import "./chipset/lib/sprites-global.asm"
#import "./chipset/lib/vic2.asm"
#import "./chipset/lib/vic2-global.asm"
