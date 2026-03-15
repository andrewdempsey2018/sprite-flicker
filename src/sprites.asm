.segment "ZEROPAGE"
sprite_x: .res NUM_SPRITES
sprite_y: .res NUM_SPRITES
sprite_palette: .res NUM_SPRITES
sprite_gfx: .res NUM_SPRITES

.segment "CODE"

.proc DrawSprites
  php
  pha
  txa
  pha
  tya
  pha

  ldx #$00              ; sprite index

  ; ----------------------------------- ;
  ; sprite 0
  lda #$10              ; sprite y
  sta $0200
  lda #$18              ; sprite image graphics
  sta $0201
  lda #$00              ; sprite palette
  sta $0202
  lda #$10              ; sprite x
  sta $0203

  lda #$10
  sta $0204
  lda #$19
  sta $0205
  lda #$00
  sta $0206
  lda #$18
  sta $0207

  lda #$18
  sta $0208
  lda #$1A
  sta $0209
  lda #$00
  sta $020A
  lda #$10
  sta $020B

  lda #$18
  sta $020C
  lda #$1B
  sta $020D
  lda #$00
  sta $020E
  lda #$18
  sta $020F
  ; ----------------------------------- ;

  pla
  tay
  pla
  tax
  pla
  plp

  rts
.endproc

.segment "RODATA"

TableSpritePalettes:
  .byte $02,$01,$02,$02,$02,$02,$02,$02,$02,$02,$01,$02,$02,$02,$02,$02
TableSpriteGFX:
  .byte $10,$11,$12,$13,$14,$15,$16,$17
  .byte $14,$15,$24,$25,$16,$17,$26,$27
  .byte $18,$19,$28,$29,$1A,$1B,$2A,$2B
  .byte $1C,$1D,$2C,$2D,$1E,$1F,$2E,$2F
  .byte $30,$31,$40,$41,$32,$33,$42,$43
TableSpriteOffsets:
  .byte $00,$10,$20,$30,$40,$50,$60,$70,$80,$90,$A0,$B0,$C0,$D0,$E0,$F0

XStartPos:
  .byte $00,$10,$20,$30,$40,$50,$60,$70,$80,$90,$A0,$B0,$C0,$D0,$E0,$F0
YStartPos:
  .byte $00,$10,$20,$30,$40,$50,$60,$70,$80,$90,$A0,$B0,$C0,$D0,$E0,$F0