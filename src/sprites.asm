.segment "ZEROPAGE"

; ----------------------------------- ;
; sprite SOA
sprite_x: .res NUM_SPRITES
sprite_y: .res NUM_SPRITES
sprite_frame: .res NUM_SPRITES
sprite_palette: .res NUM_SPRITES
sprite_flags: .res NUM_SPRITES
; ----------------------------------- ;

current_sprite: .res 1
zp_sprite_pointer: .res 2

.segment "CODE"

.proc update_sprite
  php
  pha
  txa
  pha
  tya
  pha

  ldx current_sprite

  ; update y position.
  lda sprite_y, x
  sec
  sbc #$01 ; speed
  sta sprite_y, x

SetPosition:
; ----------------------------------- ;
; get the relevant OAM address where this particular sprite should be placed
  lda TableSpriteOffsets, x
  sta zp_sprite_pointer
  lda #$02
  sta zp_sprite_pointer+1

  lda sprite_y, x
  ldy #0                ; set y position
  sta (zp_sprite_pointer), y
  lda sprite_x, x
  ldy #3                ; set x position
  sta (zp_sprite_pointer), y
; ----------------------------------- ;
Done:
  jsr DrawSprite

  pla
  tay
  pla
  tax
  pla
  plp

  rts
.endproc

.proc ProcessSprites
  php
  pha
  txa
  pha
  tya
  pha

  ldx #$00
NextSprite:
  stx current_sprite
  jsr update_sprite
  
  inx
  cpx #NUM_SPRITES
  bne NextSprite

done:
  pla
  tay
  pla
  tax
  pla
  plp

  rts
.endproc

.proc DrawSprite
  php
  pha
  txa
  pha
  tya
  pha

  ldx current_sprite

; ----------------------------------- ;
; get the relevant OAM address where this particular sprite should be placed
  lda TableSpriteOffsets, x
  sta zp_sprite_pointer
  lda #$02
  sta zp_sprite_pointer+1
; get the type of sprite
  lda sprite_flags, x
  and #%00000111
  tay
  lda TableSpriteGFX, y

  ldy #1                ; draw one 8x8 sprite
  sta (zp_sprite_pointer), y
; ----------------------------------- ;

; <---------------------------------- ;
; set bullet palettes
  lda sprite_flags, x
  and #%00000111
  tay
  lda TableSpritePalettes, y
  ldy #2
  sta (zp_sprite_pointer), y
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
  .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
TableSpriteOffsets:
  .byte $00,$10,$20,$30,$40,$50,$60,$70,$80,$90,$A0,$B0,$C0,$D0,$E0,$F0

XStartPos:
  .byte $10,$15,$20,$25,$30,$35,$40,$45,$50,$55,$60,$65,$70,$75,$80,$85
YStartPos:
  .byte $00,$08,$10,$18,$20,$28,$30,$38,$40,$48,$50,$58,$60,$68,$70,$78