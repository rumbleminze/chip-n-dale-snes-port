intro_screen_data:



.byte $e2, $20, $43, $41, $47, $4b, $2d, $2b, $00                       ; Ported 
.byte $27, $55, $00                                                 ; by 
.byte $47, $4d, $3d, $27, $3b, $2d, $3d, $35, $3f, $57, $2d, $00       ; Rumbleminze, 
.byte $15, $11, $15, $19, $ff                                         ; 2024

.byte $00, $23, $15, $25, $11, $17, $00                 ; 2A03
.byte $49, $41, $4d, $3f, $2b, $00                 ; SOUND 
.byte $2d, $3d, $4d, $3b, $25, $4b, $41, $47, $00                 ; EMULATOR
.byte $27, $55, $00                 ; BY
.byte $3d, $2d, $3d, $27, $3b, $2d, $47, $49, $ff                 ; MEMBLERS

.byte $78, $23, $47, $2d, $4f, $13, $ff ; Version (REV0)
.byte $ff, $ff

write_intro_palette:
    STZ CGADD    
    LDA #$00
    STA CGDATA
    STA CGDATA

    LDA #$FF
    STA CGDATA
    STA CGDATA

    LDA #$B5
    STA CGDATA
    LDA #$56
    STA CGDATA
    
    LDA #$29
    STA CGDATA
    LDA #$25
    STA CGDATA


; sprite default colors
    LDA #$80
    STA CGADD
    LDA #$D0
    STA CGDATA
    LDA #$00
    STA CGDATA
    
    LDA #$b5
    STA CGDATA
    LDA #$56
    STA CGDATA

    LDA #$d0
    STA CGDATA
    LDA #$00
    STA CGDATA
    
    LDA #$00
    STA CGDATA
    LDA #$00
    STA CGDATA

    
    LDA #$90
    STA CGADD
    LDA #$D0
    STA CGDATA
    LDA #$00
    STA CGDATA
    
    LDA #$00
    STA CGDATA
    LDA #$00
    STA CGDATA

    LDA #$d6
    STA CGDATA
    LDA #$10
    STA CGDATA
    
    LDA #$41
    STA CGDATA
    LDA #$02
    STA CGDATA

    
    LDA #$A0
    STA CGADD
    LDA #$D0
    STA CGDATA
    LDA #$00
    STA CGDATA
    
    LDA #$00
    STA CGDATA
    LDA #$00
    STA CGDATA

    LDA #$33
    STA CGDATA
    LDA #$01
    STA CGDATA

    LDA #$D0
    STA CGDATA
    LDA #$00
    STA CGDATA

    
    LDA #$B0
    STA CGADD
    LDA #$D0
    STA CGDATA
    LDA #$00
    STA CGDATA
    
    LDA #$33
    STA CGDATA
    LDA #$01
    STA CGDATA

    LDA #$33
    STA CGDATA
    LDA #$01
    STA CGDATA
    
    LDA #$6a
    STA CGDATA
    LDA #$00
    STA CGDATA

    RTS


write_intro_tiles:
    LDY #$00

next_line:
    ; get starting address
    LDA intro_screen_data, Y
    CMP #$FF
    BEQ exit_intro_write

    PHA
    INY    
    LDA intro_screen_data, Y
    STA VMADDH
    PLA
    STA VMADDL
    INY

next_tile:
    LDA intro_screen_data, Y
    INY

    CMP #$FF
    BEQ next_line

    STA VMDATAL
    BRA next_tile

exit_intro_write:
    RTS

do_intro:
    JSR load_intro_tilesets
    JSR write_intro_palette
    JSR write_default_palettes
    JSR write_intro_tiles
    ; JSR write_intro_sprites

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

:   RTS
check_for_sprite_swap:

    LDA JOYTRIGGER1
    AND #$20
    CMP #$20
    BNE :-
    jsr load_intro_tilesets
    LDA #$0F
    STA INIDISP
:   rts
check_for_msu:
    LDA JOYTRIGGER1
    AND #$01
    CMP #$01
    BEQ :+
    LDA JOYTRIGGER1
    AND #$02
    CMP #$02
    BNE :-
:   LDA MSU_SELECTED
    EOR #$01
    STA MSU_SELECTED

    LDA SNES_OAM_START + (4*9 - 1)
    EOR #$40
    STA SNES_OAM_START + (4*9 - 1)
    JSR dma_oam_table
    RTS
intro_sprite_info:
    ; x, y, sprite
    .byte $80, $30, $00, $00
    .byte $80, $38, $01, $00
    .byte $88, $30, $02, $00
    .byte $88, $38, $03, $00
    .byte $80, $40, $08, $00
    .byte $80, $48, $09, $00
    .byte $88, $40, $0a, $00
    .byte $88, $48, $0B, $00
    .byte $80, $78, $54, $40
    .byte $ff

write_intro_sprites:
    LDY #$00
    LDX #$09

:   LDA intro_sprite_info, y
    STA SNES_OAM_START, y
    INY
    LDA intro_sprite_info, y
    STA SNES_OAM_START, y
    INY
    LDA intro_sprite_info, y
    STA SNES_OAM_START, y
    INY
    LDA intro_sprite_info, y
    STA SNES_OAM_START, y
    INY
    DEX
    BNE :-

    JSR dma_oam_table

    rts

load_intro_tilesets:
    lda #$01
    sta NMITIMEN
    LDA VMAIN_STATE
    AND #$0F
    STA VMAIN
    LDA #$8F
    STA INIDISP
    STA INIDISP_STATE

  LDA #$20
  STA CHR_BANK_BANK_TO_LOAD
  LDA #$00
  STA CHR_BANK_TARGET_BANK
  JSL load_chr_table_to_vm

    LDA #$20
  STA CHR_BANK_BANK_TO_LOAD
  LDA #$01
  STA CHR_BANK_TARGET_BANK
  JSL load_chr_table_to_vm
    
;   LDA #$1F
;   STA CHR_BANK_BANK_TO_LOAD
;   LDA #$01
;   STA CHR_BANK_TARGET_BANK
;   JSL load_chr_table_to_vm
    
;   LDA #$00
;   STA CHR_BANK_BANK_TO_LOAD
;   LDA #$03
;   STA CHR_BANK_TARGET_BANK
;   JSL load_chr_table_to_vm

;   LDA #$01
;   STA CHR_BANK_BANK_TO_LOAD
;   LDA #$04
;   STA CHR_BANK_TARGET_BANK
;   JSL load_chr_table_to_vm
  
;   LDA #$02
;   STA CHR_BANK_BANK_TO_LOAD
;   LDA #$05
;   STA CHR_BANK_TARGET_BANK
;   JSL load_chr_table_to_vm
  
;   LDA #$03
;   STA CHR_BANK_BANK_TO_LOAD
;   LDA #$06
;   STA CHR_BANK_TARGET_BANK
;   JSL load_chr_table_to_vm

;   LDA #$04
;   STA CHR_BANK_BANK_TO_LOAD
;   STA DATA_CHR_BANK_CURR
;   LDA #$07
;   STA CHR_BANK_TARGET_BANK
;   JSL load_chr_table_to_vm

    rts