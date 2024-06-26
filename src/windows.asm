; sets up a black window on the left column of the screen
; this is used during pause
setup_pause_window:
    LDA #$01
    STA TMW

    ; Window 1 Left
    LDA #$00
    STA WH0

    LDA #$10
    STA WH1

    LDA #%10101010
    STA WBGLOG

    LDA #%00001010
    STA WOBJLOG

    LDA #$02
    STA W12SEL
    STA WOBJSEL
    
    jslb disable_pause_window, $a0
    rts

enable_pause_window:
    LDA #%00000010
    STA W12SEL

    RTL

disable_pause_window:
    LDA #$00
    STA W12SEL
    RTL