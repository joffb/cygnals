
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_instrument_change

.section .text.sound_driver

sound_instrument_change:

    # update instrument number
    mov [si + CHANNEL_INSTRUMENT_NUM], al

    # preserve command pointer
    push bx

    # get pointer to instrument from table
    # al * 6
    mov bl, INSTRUMENT_SIZE
    mul bl
    add ax, es:[SONG_HEADER_INSTRUMENT_PTRS]
    mov bx, ax

    # get volume and ex macro numbers
    mov ax, es:[bx]

    # clear dl and dh
    xor dx, dx

    # exchange so
    # al is now 0, ah is vol_macro_num
    # dl is now 0, dh is ex_macro_num
    xchg dh, al

    mov [si + CHANNEL_VOLUME_MACRO_POS], ax
    mov [si + CHANNEL_EX_MACRO_POS], dx

    # get arp and wave macro numbers
    mov ax, es:[bx + INSTRUMENT_WAVE_MACRO_PTR]

    # clear dl and dh
    xor dx, dx

    # exchange so
    # al is now 0, ah is arp_macro_num
    # dl is now 0, dh is wave_macro_num
    xchg dh, al

    mov [si + CHANNEL_ARP_MACRO_POS], ax
    mov [si + CHANNEL_WAVE_MACRO_POS], dx

    # load macro flags
    # preserve top two bits of flags2
    mov al, [si + CHANNEL_FLAGS2]
    and al, 0xc0
    or al, es:[bx + INSTRUMENT_MACRO_FLAGS]
    mov [si + CHANNEL_FLAGS2], al

    # get wave
    mov al, es:[bx + INSTRUMENT_WAVE]

    # 0xff means don't change wave
    cmp al, 0xff
    jz sui_no_wave_change
    
        # is this wave already in use?
        cmp al, [si + CHANNEL_WAVETABLE_NUM]
        jz sui_no_wave_change

            call sound_wavetable_change

    sui_no_wave_change:

    # restore command pointer
    pop bx

    ret