.define T_0 $51
.define T_1 T_0 + 1
.define T_2 T_0 + 2
.define T_3 T_0 + 3
.define T_4 T_0 + 4
.define T_5 T_0 + 5
.define T_6 T_0 + 6
.define T_7 T_0 + 7
.define T_8 T_0 + 8
.define T_9 T_0 + 9
.define T_A T_0 + 10
.define T_B T_0 + 11
.define T_C T_0 + 12
.define T_D T_0 + 13
.define T_E T_0 + 14
.define T_F T_0 + 15
.define T_G T_0 + 16
.define T_H T_0 + 17
.define T_I T_0 + 18
.define T_J T_0 + 19
.define T_K T_0 + 20
.define T_L T_0 + 21
.define T_M T_0 + 22
.define T_N T_0 + 23
.define T_O T_0 + 24
.define T_P T_0 + 25
.define T_Q T_0 + 26
.define T_R T_0 + 27
.define T_S T_0 + 28
.define T_T T_0 + 29
.define T_U T_0 + 30
.define T_V T_0 + 31
.define T_W T_0 + 32
.define T_X T_0 + 34
.define T_Y T_0 + 34
.define T_Z T_0 + 35
.define T_PERIOD    T_0 + 36
.define T_DASH      T_0 + 37
.define T_EQ        T_0 + 38
.define T_QUESTMK   T_0 + 39
.define T_EXCLM     T_0 + 40
.define T_CR        T_0 + 41
.define T_ARROW_L   T_0 + 42
.define T_ARROR_R   T_0 + 43
.define T_APOS      T_0 + 44
.define T_SLASH     T_0 + 45
.define T_SP        T_0 + 46

intro_screen_text:
.byte $D2, $71, T_P, T_O, T_R, T_T, T_SP                    ; Port
.byte T_B, T_Y, $ff                                                     ; by 
.byte $F2, $71, T_R, T_U, T_M, T_B, T_L, T_E, T_M, T_I, T_N, T_Z, T_E, $FF        ; Rumbleminze, 
.byte $12, $72, T_2, T_0, T_2, T_4, $ff                                           ; 2024

.byte $b2, $72, T_2, T_A, T_0, T_3, T_SP                                 ; 2A03
.byte T_S, T_O, T_U, T_N, T_D, $ff                                      ; SOUND 
.byte $d2, $72, T_E, T_M, T_U, T_L, T_A, T_T, T_O, T_R, $ff                       ; EMULATOR
.byte $f2, $72, T_B, T_Y, T_SP                                                     ; BY
.byte T_M, T_E, T_M, T_B, T_L, T_E, T_R, T_S, $ff                       ; MEMBLERS

.byte $78, $73, T_R, T_E, T_V, T_C, $ff ; Version (REV0)
.byte $ff, $ff

do_intro:
    PHB
    PHK
    PLB
    JSR setup_intro_bg1
    JSR write_intro_palette
    JSR load_intro_tilesets
    JSR write_intro_tiles
    JSR write_intro_text

    LDA #$0F
    STA INIDISP
    LDX #$FF


:
    jslb check_for_code_input_long, $a0
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
    jsr reset_bg_values
    PLB

    .if ENABLE_MSU = 1
        JML $C7FF00
    .endif
  RTL
setup_intro_bg1:
    LDA #$03
    STA BGMODE
    LDA #$70
    STA BG1SC
    LDA #$50
    STA BG2SC

    LDA #$00
    STA BG12NBA

    LDA #$50
    STA VMADDH
    STZ VMADDL

    setAXY16
    LDA #$0747
    LDX #$0400
:   STA VMDATAL
    DEX
    BNE :-
    LDA #$0000
    LDX #$0000

    setAXY8

    LDA #$FF
    STA BG1VOFS
    LDA #$01
    STA BG1VOFS
    STZ BG1HOFS
    STZ BG1HOFS
    rts

reset_bg_values:
    LDA #$21
    STA BG1SC
    LDA #$11
    STA BG12NBA
    rts

write_intro_text:
    LDY #$00

next_line:
    ; get starting address
    LDA intro_screen_text, Y
    CMP #$FF
    BEQ exit_intro_write

    PHA
    INY    
    LDA intro_screen_text, Y
    STA VMADDH
    PLA
    STA VMADDL
    INY

next_tile:
    LDA intro_screen_text, Y
    INY

    CMP #$FF
    BEQ next_line
    
    STA VMDATAL
    ; tiles from bank 2
    ; pallete 7
    LDA #$1E
    STA VMDATAH
    
    BRA next_tile

exit_intro_write:
    RTS

write_intro_tiles:
:   LDA RDNMI
    BPL :-
    STZ HDMAEN
    STZ MDMAEN
    LDA #$80
    STA VMAIN
    setAXY16
    LDA #$7000
    STA VMADDL

    LDY #$0000
:   LDA intro_tilemap_8bpp, Y
    STA VMDATAL
    INY
    INY
    CPY #$800
    BNE :-

    setAXY8
    rts

write_intro_palette:
    jsr write_8bpp_pallete
    rts

write_nes_box_pallete:

    STZ CGADD    

    LDY #$00
:   LDA nes_box_palette, y
    STA CGDATA
    INY
    BNE :-

    RTS

write_8bpp_pallete:
  STZ DMAP0
  LDA #$22
  STA BBAD0
  STZ CGADD
  LDA #^(title_bg_palette_8bpp)
  STA A1B0
  LDA #>(title_bg_palette_8bpp)
  STA A1T0H
  LDA #<(title_bg_palette_8bpp)
  STA A1T0L
  LDA #$02
  STA DAS0H
  STZ DAS0L
  LDA #$01
  STA MDMAEN
  rts

load_intro_tilesets:
    lda #$00
    sta NMITIMEN
    ; LDA VMAIN_STATE
    LDA #$80
    STA VMAIN
    LDA #$8F
    STA INIDISP
    STA INIDISP_STATE

    LDA #$01
    STA DMAP0
    LDA #$18
    STA BBAD0
    LDA #$C6
    STA A1B0
    STZ A1T0H
    STZ A1T0L
    STZ VMADDH
    STZ VMADDL
    LDA #$E0
    STA DAS0H
    STZ DAS0L
    LDA #$01
    STA MDMAEN

    LDA #$01
    STA DMAP0
    LDA #$18
    STA BBAD0
    LDA #$4A
    STA VMADDH
    LDA #$20
    STA VMADDL
    LDA #^(basic_intro_tiles_start)
    STA A1B0
    LDA #>(basic_intro_tiles_start)    
    STA A1T0H
    LDA #<(basic_intro_tiles_start)    
    STA A1T0L
    LDA #$0B
    STA DAS0H
    LDA #$C0
    STA DAS0L
    LDA #$01
    STA MDMAEN


  rts
    
.include "msu_intro_tilemap.asm"
.include "movie-palette.asm"
.include "nes-box-palette.asm"