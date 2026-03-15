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
	sta PPUCTRL, x        ; set sprite y-positions off the screen
	inx
	inx
	inx
	inx
	bne clear_oam

  ldx #$00
  lda #$00
ResetSpriteSOA:
  sta sprite_x, x
  sta sprite_y, x
  sta sprite_palette, x
  sta sprite_gfx, x
  inx
  cpx #$10
  bne ResetSpriteSOA

  lda #$00
  sta zp_anim_offset
  sta timer
  sta oam_address
  sta oam_address+1
  sta zp_nametable_pointer
  sta zp_nametable_pointer+1

vblankwait2:
  bit PPUSTATUS
  bpl vblankwait2
  jmp main
.endproc