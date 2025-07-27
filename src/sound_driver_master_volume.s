
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_set_master_volume
.global sound_set_master_volume_fade

.section .fartext.sound_driver, "ax"

# ax : song state pointer
# dl : volume
sound_set_master_volume:

    push si
    push di

    mov di, ax

    # cap at 0x80
    cmp dl, 0x80
    jc ssmv_set_volume

        mov dl, 0x80

    ssmv_set_volume:

    # update master volume variable
    mov [di + MUSIC_STATE_MASTER_VOLUME], dl

    # get channels pointer in si
    mov si, [di + MUSIC_STATE_CHANNELS_PTR]
    mov cx, 4

    ssmv_loop:

        # set master volume change flag
        or byte ptr [si + CHANNEL_FLAGS2], CHAN_FLAG2_VOLUME_CHANGE

        # move to next channel
        add si, CHANNEL_SIZE
        loopnz ssmv_loop

    pop di
    pop si

    IA16_RET
