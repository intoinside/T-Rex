

.file [name="./T-Rex.prg", segments="Code", modify="BasicUpstart", _start=$0810]
.disk [filename="./T-Rex.d64", name="T-REX", id="C2022", showInfo]
{
  [name="--- RAFFAELE ---", type="rel"],
  [name="--- INTORCIA ---", type="rel"],
  [name="-- @GMAIL.COM --", type="rel"],
  [name="----------------", type="rel"],
  [name="T-REX", type="prg", segments="Code", modify="BasicUpstart", _start=$0810],
  [name="----------------", type="rel"]
}

#import "_label.asm"

* = $0810 "Entry"
Entry: {
    SetupRasterIrq(10, Irq0)

    rts
}

