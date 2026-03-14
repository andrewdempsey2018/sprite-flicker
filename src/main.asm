.include "constants.inc" 
.include "header.inc"
.include "reset.asm"
.include "controllers.asm"
.include "sprites.asm"

.segment "ZEROPAGE"
sleeping: .res 1
buttons_held: .res 1
buttons_pressed: .res 1

.segment "CODE"

.proc irq_handler
  rti
.endproc

.proc nmi_handler

  php
  pha
  txa
  pha
  tya
  pha

  lda #$00
  sta OAMADDR
  lda #$02
  sta OAMDMA
  lda #$00

  jsr read_controller

  ;This is the PPU clean up section, so rendering the next frame starts properly.
  lda #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  sta PPUCTRL
  lda #%00011110   ; enable sprites, enable background, no clipping on left side
  sta PPUMASK

  ;;
  lda #$00
  sta sleeping

  pla
  tay
  pla
  tax
  pla
  plp

  rti
.endproc

.proc clear_oam
  php
  pha
  txa
  pha
  tya
  pha

	ldx #$00
	lda #$F8
@clear_oam:
	sta $0200, x ; set sprite y-positions off the screen
	inx
	inx
	inx
	inx
	bne @clear_oam

  pla
  tay
  pla
  tax
  pla
  plp

  rts
.endproc

.proc main
  ldx PPUSTATUS
  ldx #$3f
  stx PPUADDR
  ldx #$00
  stx PPUADDR

load_palettes:
  lda palettes,X
  sta PPUDATA
  inx
  cpx #$20 ; there are 32 colours to load
  bne load_palettes

  lda #%10010000  ; turn on NMIs, sprites use first pattern table
  sta PPUCTRL
  lda #%00011110  ; turn on screen
  sta PPUMASK
  ;;

vblankwait:       ; wait for another vblank before continuing
  bit PPUSTATUS
  bpl vblankwait

; ----------------------------------- ;
; init sprite positions
  ldx #$00
:
  lda XStartPos, x
  sta sprite_x, x
  lda YStartPos, x
  sta sprite_y, x
  inx
  cpx #$10
  bne :-
; ----------------------------------- ;

mainloop:
  jsr ProcessSprites

done:
  ;loop
  inc sleeping
sleep:
  lda sleeping
  bne sleep

  jmp mainloop
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "graphics.chr"

.segment "RODATA"

palettes:
  .byte $0f,$00,$10,$30 ; background
  .byte $0f,$01,$21,$31
  .byte $0f,$06,$16,$26
  .byte $0f,$09,$19,$29

  .byte $0f,$00,$10,$30 ; sprite
  .byte $0f,$01,$21,$31
  .byte $0f,$06,$16,$26
  .byte $0f,$09,$19,$29
