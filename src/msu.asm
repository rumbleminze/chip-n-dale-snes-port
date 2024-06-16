.segment "PRGB2"

; Audio Tracks (NSF id)
; 0x00 - Zone 0
; 0x01 - Zone B
; 0x02 - Zone D
; 0x03 - Zone G
; 0x04 - Zone J
; 0x05 - Zone A
; 0x06 - Zone F
; 0x07 - title
; 0x08 - Ending
; 0x09 - overworld
; 0x0A - Boss
; 0x0B - Game Over
; 0x0C - Bonus Stage
; 0x0D - Invincible
; 0x23 - zone clear

; Read Flags
.DEFINE MSU_STATUS      $2000
.DEFINE MSU_READ        $2001
.DEFINE MSU_ID          $2002   ; 2002 - 2007

; Write flags
.DEFINE MSU_SEEK        $2000
.DEFINE MSU_TRACK       $2004   ; 2004 - 2005
.DEFINE MSU_VOLUME      $2006
.DEFINE MSU_CONTROL     $2007

.DEFINE CURRENT_NSF     $09FF
.DEFINE MSU_TRACK_IDX   $09FE
.DEFINE LOOP_VALUE      $09FD
.DEFINE MSU_ENABLE      $09FC
.DEFINE MSU_TRIGGER     $09FB
.DEFINE MSU_CURR_VOLUME $09F9
.DEFINE MSU_CURR_CTRL   $09F8

.DEFINE CND_STOP        #$F2
.DEFINE CND_PAUSE       #$F3
.DEFINE CND_RESUME      #$F4

.DEFINE NUM_TRACKS      #$0F
.DEFINE TRACKS_AVAILABLE $1ff0

check_for_all_tracks_present:
  PHB
  LDA #$B2
  PHA
  PLB
  LDA MSU_ID		; load first byte of msu-1 identification string
  CMP #$53		    ; is it "M" present from "MSU-1" string?
  BEQ :+
  PLB
  RTL ; no MSU exit early

: STZ MSU_VOLUME
  LDY NUM_TRACKS
  INY
: jsr wait_a_frame
  STZ MSU_CONTROL
  DEY
  BMI :+
  TYA
  STA MSU_TRACK
  STZ MSU_TRACK + 1 
  jsr wait_a_frame
  LDA MSU_STATUS  ; load track Status
  AND #$08		    ; isolate PCM track present byte
        		      ; is PCM track present after attempting to play using STA $2004?
  BNE :-
  LDA #$01
  STA TRACKS_AVAILABLE, Y
  BRA :-
: PLB
  RTL

wait_a_frame:
: LDA RDNMI
  BPL :-
  LDA RDNMI
  LDA #$FF
:		; check msu ready status (required for sd2snes hardware compatibility)
  bit $2000
  bvs :-
msu_status_check:
  LDA MSU_STATUS
  AND #$40
  BNE msu_status_check
  RTS

; Checks for MSU track for audio try in Accumulator
msu_check:
  PHB  
  PHK
  PLB

  PHY
  PHX
  PHA  

  LDA MSU_ID		; load first byte of msu-1 identification string
  CMP #$53		    ; is it "M" present from "MSU-1" string?
  BNE fall_through  ; No MSU-1 support, fall back to NSF
  

  ; check if we have a track for this value
  PLA
  PHA
  CMP CND_STOP
  BEQ stop_msu

  CMP CND_PAUSE
  BEQ pause_msu

  CMP CND_RESUME
  BEQ resume_msu

  TAY
  LDA msu_track_lookup, Y
  CMP #$FF
  BEQ fall_through  

  ; check if we actually have the track available
  TAY
  LDA TRACKS_AVAILABLE, Y
  BEQ stop_msu
  TYA

  ; non-FF value means we have an MSU track
  BRA msu_available

stop_msu:
; is msu playing?  if not, just exit
    LDA MSU_ENABLE
    BEQ fall_through
    STZ MSU_CONTROL
    STZ MSU_CURR_CTRL
    STZ MSU_ENABLE
    BRA fall_through

pause_msu:
    LDA MSU_ENABLE
    BEQ fall_through
    STZ MSU_CONTROL
    STZ MSU_CURR_CTRL
    BRA fall_through

resume_msu:
    LDA MSU_ENABLE
    BEQ fall_through
    LDA MSU_TRACK_IDX
    TAY
    LDA msu_track_loops, Y
    STA MSU_CONTROL
    STA MSU_CURR_CTRL

  ; fall through to default
fall_through:
  PLA
  PLX
  PLY
  PLB
  STX $00 ; native code
  LDX $DA ; native code
  STA $01
  LDA $DC,X

  RTL

  ; if msu is present, process msu routine
msu_available:
  TAY
  PLA
  PHY                   ; push the MSU-1 track 

  STZ MSU_ENABLE		; clear disable/enable nsf music flag
  STA CURRENT_NSF		; store current nsf track-id for later retrieval

  LDA #$01
  STA MSU_TRIGGER
  LDA #$FF		       
  STA MSU_ENABLE		; set mute NSF flag (writing FF in RAM location)

  PLA                   ; pull the current MSU-1 Track
  STA MSU_TRACK_IDX		; store current re-mapped nsf track-id for later retrieval
  STA MSU_TRACK		    ; store current valid NSF track-ID
  stz MSU_TRACK + 1	    ; must zero out high byte or current msu-1 track will not play !!!

  PLX
  PLY
  PLB

  STX $00 ; native code
  LDX $DA ; native code
  LDA CND_STOP
  STA $01
  LDA $DC,X
  
  RTL


: RTL
msu_nmi_check:
  LDA MSU_TRIGGER
  BEQ :-
  LDA MSU_STATUS
  AND #$40
  BNE :-
  LDA MSU_STATUS

  PHB
  PHK
  PLB
  STZ MSU_TRIGGER
  LDA MSU_TRACK_IDX ; pull the current MSU-1 Track
  TAY
  LDA msu_track_loops, Y
  STA MSU_CONTROL		; write current loop value
  STA MSU_CURR_CTRL
  LDA msu_track_volume, Y
  STA MSU_VOLUME		; write max volume value
  STA MSU_CURR_VOLUME
  PLB
  RTL

msu_track_lookup:
; 0 - d are tracks, 15 is life lost, and 23 is zone clear, the rest are invalid
.byte $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $0F, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


msu_track_loops:
; 0 is intro video
; 1 - 11, 14 all loop
; 12, 13, and 15 dont
.byte $01, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $01, $01, $03, $01
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

msu_track_volume:
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
.byte $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F


.include "msu_intro_screen.asm"

.if ENABLE_MSU_MOVIE = 1
    .include "msu_video_player.asm"
.endif