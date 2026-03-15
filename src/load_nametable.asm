.segment "RODATA"
.include "background.asm"

.segment "ZEROPAGE"
zp_nametable_pointer: .res 2

.segment "CODE"
.proc LoadNametable
  php
  pha
  txa
  pha
  tya
  pha

  lda PPUSTATUS         ; reset the high/low latch
  lda #$20              ; nametable 0 address
  sta PPUADDR           ; write the high byte of $2000 address
  lda #$00
  sta PPUADDR           ; write the low byte of $2000 address

  ldx #$00
  ldy #$00
OutsideLoop:

InsideLoop:

  lda (zp_nametable_pointer), y
  sta PPUDATA           ; write to PPU
  iny
  cpy #0
  bne InsideLoop

  inc zp_nametable_pointer+1
  inx
  cpx #4
  bne OutsideLoop

  pla
  tay
  pla
  tax
  pla
  plp

  rts
.endproc