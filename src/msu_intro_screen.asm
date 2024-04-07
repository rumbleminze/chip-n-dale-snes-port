do_intro:
    JSR setup_intro_bg1
    JSR load_intro_tilesets
    JSR write_intro_palette
    JSR write_intro_tiles

    LDA #$0F
    STA INIDISP
    LDX #$FF


:
    jsr check_for_code_input
    ; jsr check_for_sprite_swap
    ; jsr check_for_msu
    LDA JOYTRIGGER1
    AND #$10
    CMP #$10
    BNE :-

    LDA INIDISP_STATE
    ORA #$8F
    STA INIDISP_STATE
    STA INIDISP

    JML $C7FF00

    jsr reset_bg_values
  RTS
setup_intro_bg1:
    LDA #$40
    STA BG1SC
    LDA #$50
    STA BG2SC

    LDA #$00
    STA BG12NBA
    rts

reset_bg_values:
    LDA #$21
    STA BG1SC
    LDA #$11
    STA BG12NBA
    rts
write_intro_tiles:
    
    LDA #$80
    STA VMAIN
    setAXY16
    LDA #$4000
    STA VMADDL

    LDY #$0000
:   LDA msu_intro_tilemap, Y
    STA VMDATAL
    INY
    INY
    CPY #$0380 * 2
    BNE :-

    setAXY8
    rts

write_intro_palette:
    jsr write_nes_box_pallete
    rts

write_nes_box_pallete:

    STZ CGADD    

    LDY #$00
:   LDA nes_box_palette, y
    STA CGDATA
    INY
    BNE :-

    RTS


load_intro_tilesets:
    lda #$01
    sta NMITIMEN
    LDA VMAIN_STATE
    AND #$0F
    STA VMAIN
    LDA #$8F
    STA INIDISP
    STA INIDISP_STATE

  LDA #$21
  STA CHR_BANK_BANK_TO_LOAD
  LDA #$00
  STA CHR_BANK_TARGET_BANK
  JSL load_chr_table_to_vm

    LDA #$22
  STA CHR_BANK_BANK_TO_LOAD
  LDA #$01
  STA CHR_BANK_TARGET_BANK
  JSL load_chr_table_to_vm

      LDA #$23
  STA CHR_BANK_BANK_TO_LOAD
  LDA #$02
  STA CHR_BANK_TARGET_BANK
  JSL load_chr_table_to_vm

      LDA #$24
  STA CHR_BANK_BANK_TO_LOAD
  LDA #$03
  STA CHR_BANK_TARGET_BANK
  JSL load_chr_table_to_vm

  rts
    
.include "msu_intro_tilemap.asm"
.include "movie-palette.asm"
.include "nes-box-palette.asm"