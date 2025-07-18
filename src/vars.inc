; set to 1 to enable debug cheats
.define DEBUG_MOD 0
.define ENABLE_MSU 0
.define ENABLE_MSU_MOVIE 0

NES_V_SCROLL        = $FA   ; might be swapped with H
NES_H_SCROLL        = $FC   ; 
PPU_CONTROL_STATE   = $FF   ; confirmed
PPU_MASK_STATE      = $FE   ; confirmed
BG_SCREEN_INDEX      = $FD
ACTIVE_BG1_BANK     = $69

OBJ_CHR_BANK_SWITCH = $15C0
BG_CHR_BANK_SWITCH  = $15C1
CHR_BANK_CURR_P1    = $15C2
BG_CHR_BANK_CURR    = $15C3
DATA_CHR_BANK_CURR  = $15C7
TARGET_BANK_OFFSET  = $15C8

; CHR_BANK_WORK
CHR_BANK_LOADED_TABLE = $1620
CHR_BANK_BANK_TO_LOAD = $1610
CHR_BANK_TARGET_BANK  = $1611
CHR_BANK_NEXT_OBJ_BANK= $1612
CHR_BANK_READ_LB    = $15C4
CHR_BANK_READ_HB    = $15C5
CHR_BANK_READ_DB    = $15C6

; SNES Register Value storage
.define NMITIMEN_STATE  $1706
.define VMAIN_STATE     $1705
.define INIDISP_STATE   $1704
.define TM_STATE        $1707

HOFS_LB             = $FC
HOFS_HB             = $08A4

VOFS_LB             = $FA
VOFS_HB             = $08A5

REUSABLE_CALC_BYTE  = $08A8
LEVEL_SELECT_INDEX  = $08A9
CHEATS_ENABLED      = $08AA

CURRENT_ATTRIBUTES  = $08B0

SPRITE_LOOP_JUNK    = $A0
tmp_dat             = $A0

FULL_ATTRIBUTE_COPY_SRC_LB = $AD
FULL_ATTRIBUTE_COPY_SRC_HB = $AE
FULL_ATTRIBUTE_COPY_HB = $AF

SOUND_HIJACK_ROUTINE_START = $0830
STACK_ADJUSTMENT_ROUTINE_START = $0800
STACK_ADJUSTMENT_RETURN_LO     = $90
STACK_ADJUSTMENT_RETURN_HI     = $FE

MSU_SELECTED        = $081C
PPU_CURR_VRAM_ADDR  = $0992
PPU_TILE_COUNT      = $0994
PPU_TILE_ATTR       = $0996
PPU_COL_OFFSET      = $0998
PPU_ROW_OFFSET      = $099A
TILES_TO_WRITE      = $099C
TILES_TO_WRITE_HB   = $099D
BANK_SWITCH_LB      = $0960
BANK_SWITCH_HB      = $0961
BANK_SWITCH_DB      = $0962
BANK_SWITCH_X      = $0963
BANK_SWITCH_Y      = $0964
BANK_SWITCH_A      = $0965
STACK_RETURN_LB    = $0966
STACK_RETURN_HB    = $0967
STACK_RETURN_DB    = $0968
ACTIVE_NES_BANK     = $F1

FULL_ATTRIBUTE_QUARTER_COUNTER = $0930
FAQ_OFFSET = $0931
ATTR_NES_SIZE = $0932
ATTR_NES_CURR_CALC_OFFSET = $0933
ATTR_PARTIAL_CURR_OFFSET = $0934

STORED_OFFSETS_SET  = $0940
UNPAUSE_BG1_VOFS_LB = $0941
UNPAUSE_BG1_VOFS_HB = $0942
UNPAUSE_BG1_HOFS_LB = $0943
UNPAUSE_BG1_HOFS_HB = $0944

.define TILE_CHUNK_COUNT   $0950
.define TILE_DEST_LB_SETS  $0951
.define TILE_DEST_HB       $0952
.define TILE_SRC_LB_BANK   $0953
.define TILE_SRC_HB        $0954

.define TILE_WORK_SIZE_LB  $0955
.define TILE_WORK_SIZE_HB  $0956

VRAM_UPDATE_ADDR_LB = $0970
VRAM_UPDATE_ADDR_HB = $0971
VRAM_UPDATE_DATA    = $0972
EXTRA_VRAM_UPDATE   = $0980


SNES_OAM_TRANSLATE_NEEDED = $12F0
SNES_OAM_START       = $1000
SNES_OAM_SECOND_BLOCK = SNES_OAM_START + $100

ATTRIBUTE_HOLDING   = $1400

ATTR_NES_HAS_VALUES = $09A0
ATTR_NES_VM_ADDR_HB = $09A1
ATTR_NES_VM_ADDR_LB = $09A2
ATTR_NES_VM_COUNT   = $09A3
ATTR_NES_VM_ATTR_START = $09A4

ATTR_VM_DATA_MAYBE_ATTR = $0990
ATTR_PARAM_LB = $0991
ATTR_PARAM_HB = $0992
ATTR_PARAM_SIZE = $0993
ATTR_PARAM_IMMEDIATE = $0994

ATTR2_NES_HAS_VALUES = $12A0
ATTR2_NES_VM_ADDR_HB = $12A1
ATTR2_NES_VM_ADDR_LB = $12A2
ATTR2_NES_VM_COUNT   = $12A3
ATTR2_NES_VM_ATTR_START = $12A4

WRITING_PALETTE     = $17D0
CURR_PALETTE_ADDR   = $17E0

ATTRIBUTE_DMA       = $17F0
ATTR_DMA_SRC_HB     = $17F2
ATTR_DMA_SRC_LB     = $17F4
ATTR_DMA_SIZE_LB    = $17F6
ATTR_DMA_SIZE_HB    = $17F8
ATTR_DMA_VMADDH     = $17FA
ATTR_DMA_VMADDL     = $17FC
ATTRIBUTE_CACHE     = $1800

ATTRIBUTE2_DMA       = $17C0
ATTR2_DMA_SRC_HB     = $17C2
ATTR2_DMA_SRC_LB     = $17C4
ATTR2_DMA_SIZE_LB    = $17C6
ATTR2_DMA_SIZE_HB    = $17C8
ATTR2_DMA_VMADDH     = $17CA
ATTR2_DMA_VMADDL     = $17CC
ATTRIBUTE2_CACHE     = $1900


; this will store 8 values that contain the 8 attributes
; each attribute value is used for 2 adjacent attribute pairs
; and each pair is for 2 tiles, resulting in 32 values
COL_ATTR_HAS_VALUES = $1A00
COL_ATTR_VM_HB      = $1A01
COL_ATTR_VM_LB      = $1A02
COL_ATTR_VM_COUNT   = $1A03 ; will always be 8 but whatevs
COL_ATTR_LB_SET     = $1A04
COL_ATTR_VM_START   = $1A05

COLUMN_1_DMA        = $1A10
C1_ATTR_DMA_SRC_HB  = $1A12
C1_ATTR_DMA_SRC_LB  = $1A14
C1_ATTR_DMA_SIZE_LB = $1A16
C1_ATTR_DMA_SIZE_HB = $1A18
C1_ATTR_DMA_VMADDH  = $1A1A
C1_ATTR_DMA_VMADDL  = $1A1C
C1_ATTRIBUTE_CACHE  = $1A20

COL2_ATTR_HAS_VALUES = $1B00
COL2_ATTR_VM_HB      = $1B01
COL2_ATTR_VM_LB      = $1B02
COL2_ATTR_VM_COUNT   = $1B03 ; will always be 8 but whatevs
COL2_ATTR_LB_SET     = $1B04
COL2_ATTR_VM_START   = $1B05

COLUMN_2_DMA        = $1B10
C2_ATTR_DMA_SRC_HB  = $1B12
C2_ATTR_DMA_SRC_LB  = $1B14
C2_ATTR_DMA_SIZE_LB = $1B16
C2_ATTR_DMA_SIZE_HB = $1B18
C2_ATTR_DMA_VMADDH  = $1B1A
C2_ATTR_DMA_VMADDL  = $1B1C
C2_ATTRIBUTE_CACHE  = $1B20

ATTR_WORK_BYTE_0 = $20
ATTR_WORK_BYTE_1 = ATTR_WORK_BYTE_0 + 1
ATTR_WORK_BYTE_2 = ATTR_WORK_BYTE_0 + 2
ATTR_WORK_BYTE_3 = ATTR_WORK_BYTE_0 + 3