
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_update_change_pattern

.section .fartext.sound_driver, "ax"

# ds - ram segment
# es - song segment
# di - song header pointer
# al - pattern number
sound_update_change_pattern:

    mov [di + MUSIC_STATE_ORDER], al

    # multiply order number by 2 to get order table offset
    xor ah, ah
    add ax, ax

    # get pointer to order for first channel
    add ax, es:[SONG_HEADER_ORDER_PTRS]
    mov bx, ax

    # offset to go from one channel's orders to the next
    mov dl, es:[SONG_HEADER_ORDERS_LENGTH]
    xor dh, dh
    add dx, dx

    # channel pointer in si
    mov si, [di + MUSIC_STATE_CHANNELS_PTR]
    
    # sfx may have different numbers of channels
    mov cl, es:[SONG_HEADER_CHANNELS]
    shr cl, 4
    
    xor ch, ch

    mut_order_jump_loop:

        # get address of new pattern and update channel with it
        mov ax, es:[bx]
        mov [si + CHANNEL_PATTERN_PTR], ax

        # reset line wait and clear tic wait flag
        mov byte ptr [si + CHANNEL_WAIT], ch
        and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_TIC_WAIT

        # move order table pointer along
        add bx, dx

        # move to next channel
        add si, CHANNEL_SIZE

        dec cl
        jnz mut_order_jump_loop

    # reset tic and line values
    mov al, [di + MUSIC_STATE_SPEED_1]
    mov [di + MUSIC_STATE_TIC], al

    mov al, es:[SONG_HEADER_PATTERN_LENGTH]
    mov [di + MUSIC_STATE_LINE], al

    # set signal that we need to process the next line
    or byte ptr [di + MUSIC_STATE_FLAGS], STATE_FLAG_PROCESS_NEW_LINE

    ret
