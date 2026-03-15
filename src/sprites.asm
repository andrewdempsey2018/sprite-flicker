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
  and #%00011111         ; if it is a multiple of 32
  bne :+
  lda zp_anim_offset
  eor #%00000100
  sta zp_anim_offset
:  
  ; ----------------------------------- ;

  ; ----------------------------------- ;
  ; update OAM (OAM order: y, gfx, palette, x)

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

TableSpriteInformation:
  .byte %00000000,%00000001,%00000010,%00000011,%00000010,%00000011,%0000001,%00000000
  .byte %00000001,%00000010,%00000011,%00000000,%00000000,%00000001,%00000010,%00000011
TableXStartPos:
  .byte $30,$60,$90,$C0,$20,$50,$80,$B0,$30,$60,$90,$C0,$20,$50,$80,$B0
TableYStartPos:
  .byte $10,$10,$10,$10,$30,$30,$30,$30,$50,$50,$50,$50,$7A,$7A,$7A,$7A
TableSpriteGFX:
  .byte $10,$18,$20,$28,$30,$10,$18,$20,$28,$30,$10,$18,$20,$28,$30,$10