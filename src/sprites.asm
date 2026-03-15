.segment "ZEROPAGE"

; ----------------------------------- ;
; sprite SOA
sprite_x: .res NUM_SPRITES
sprite_y: .res NUM_SPRITES
sprite_palette: .res NUM_SPRITES
sprite_gfx: .res NUM_SPRITES
; ----------------------------------- ;

zp_anim_offset: .res 1
oam_address: .res 2

.segment "CODE"

.proc DrawSprites
  php
  pha
  txa
  pha
  tya
  pha

  ; ----------------------------------- ;
  ; animate sprites
  lda timer
  and #%00011111        ; if it is a multiple of 32
  bne :+
  lda zp_anim_offset
  eor #%00000100
  sta zp_anim_offset
:  
  ; ----------------------------------- ;

  ; ----------------------------------- ;
  ; sprite 0
  ; update OAM
  ; OAM: y, gfx, palette, x

  ldx #$00              ; sprite index
  ldy #$00              ; oam index
  
  lda #$00
  sta oam_address
  lda #$02
  sta oam_address+1

LoopThroughSprites:
  lda sprite_y, x
  sta (oam_address), y
  iny
  lda sprite_gfx, x
  clc
  adc zp_anim_offset
  sta (oam_address), y
  iny
  lda sprite_palette, x
  sta (oam_address), y
  iny
  lda sprite_x, x
  sta (oam_address), y
  iny

  lda sprite_y, x
  sta (oam_address), y
  iny
  lda sprite_gfx, x
  clc
  adc zp_anim_offset
  adc #1
  sta (oam_address), y
  iny
  lda sprite_palette, x
  sta (oam_address), y
  iny
  lda sprite_x, x
  clc
  adc #8
  sta (oam_address), y
  iny

  lda sprite_y, x
  clc
  adc #8
  sta (oam_address), y
  iny
  lda sprite_gfx, x
  clc
  adc zp_anim_offset
  adc #2
  sta (oam_address), y
  iny
  lda sprite_palette, x
  sta (oam_address), y
  iny
  lda sprite_x, x
  sta (oam_address), y
  iny

  lda sprite_y, x
  clc
  adc #8
  sta (oam_address), y
  iny
  lda sprite_gfx, x
  clc
  adc zp_anim_offset
  adc #3
  sta (oam_address), y
  iny
  lda sprite_palette, x
  sta (oam_address), y
  iny
  lda sprite_x, x
  clc
  adc #8
  sta (oam_address), y
  iny

  inx
  cpx #$10
  bne LoopThroughSprites
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