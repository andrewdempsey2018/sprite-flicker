.include "constants.inc" 
.include "header.inc"
.include "reset.asm"
.include "controllers.asm"
.include "sprites.asm"
.include "load_nametable.asm"

.segment "ZEROPAGE"
sleeping: .res 1
buttons_held: .res 1
buttons_pressed: .res 1
timer: .res 1

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

  inc timer

; ----------------------------------- ;
; PPU clean up section
  lda #%10010000        ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  sta PPUCTRL
  lda #%00011110        ; enable sprites, enable background, no clipping on left side
  sta PPUMASK
; ----------------------------------- ;

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
	sta $0200, x          ; set sprite y-positions off the screen
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
  lda #0                ; turn off rendering before initialisation
  sta PPUMASK

  ldx PPUSTATUS
  ldx #$3f
  stx PPUADDR
  ldx #$00
  stx PPUADDR

  ldx #$00
load_palettes:
  lda palettes, x
  sta PPUDATA
  inx
  cpx #$20              ; 32 colours to load
  bne load_palettes

  ; ----------------------------------- ;
  ; init background tiles
  lda #<background
  sta zp_nametable_pointer
  lda #>background
  sta zp_nametable_pointer+1
  jsr LoadNametable
  ; ----------------------------------- ;

  ; ----------------------------------- ;
  ; prep sprites
  ldx #$00
PrepSprites:
  lda TableSpriteInformation, x
  sta sprite_palette, x
  lda TableXStartPos, x
  sta sprite_x, x
  lda TableYStartPos, x
  sta sprite_y, x
  lda TableSpriteGFX, x
  sta sprite_gfx, x
  inx
  cpx #$10
  bne PrepSprites
  ; ----------------------------------- ;

vblankwait:             ; wait for another vblank before continuing
  bit PPUSTATUS
  bpl vblankwait

  ; ----------------------------------- ;
  ; turn on rendering
  lda #%10010000        ; turn on NMIs, sprites use first pattern table
  sta PPUCTRL
  lda #%00011110        ; turn on screen
  sta PPUMASK
  ; ----------------------------------- ;

mainloop:
  jsr DrawSprites

done:
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
                        ; background
  .byte $0F,$24,$35,$30
  .byte $0F,$14,$15,$25
  .byte $0F,$29,$26,$27
  .byte $0F,$36,$38,$36

                        ; sprites
  .byte $0F,$15,$16,$26
  .byte $0F,$27,$28,$28
  .byte $0F,$29,$2a,$2b
  .byte $0F,$21,$22,$23
