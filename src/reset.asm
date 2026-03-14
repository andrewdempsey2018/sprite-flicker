.segment "ZEROPAGE"

.segment "CODE"
.export reset_handler
.proc reset_handler
  sei
  cld
  ldx #$40
  stx APU
  ldx #$FF
  txs
  inx
  stx PPUCTRL
  stx PPUMASK
  stx IRQ_ENABLE
  bit PPUSTATUS
vblankwait:
  bit PPUSTATUS
  bpl vblankwait

	ldx #$00
	lda #$FF
clear_oam:
	sta PPUCTRL, x ; set sprite y-positions off the screen
	inx
	inx
	inx
	inx
	bne clear_oam

  ; ----------------------------------- ;
  ; reset ram
  ldx #$00
  lda #$00
ResetRam:
  sta sprite_x, x
  sta sprite_y, x
  sta sprite_frame, x
  sta sprite_palette, x
  sta sprite_flags, x
  inx
  cpx #NUM_SPRITES
  bne ResetRam

  lda #$00
  sta current_sprite
  sta zp_sprite_pointer
  ; ----------------------------------- ;

vblankwait2:
  bit PPUSTATUS
  bpl vblankwait2
  jmp main
.endproc