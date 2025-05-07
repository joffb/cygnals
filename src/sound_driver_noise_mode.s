
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_noise_mode_change

.section .text.sound_driver

# al : noise mode
sound_noise_mode_change:

    # noise mode = 0
    or al, al
    jnz snmc_noise_on

        # clear ch4 noise bit
        in al, IO_SND_CH_CTRL 
        and al, ~SND_CH4_NOISE

        # update noise flag in state
        and byte ptr [di + MUSIC_STATE_FLAGS], ~STATE_FLAG_NOISE_ON

        # don't actually update value on chip if channel muted
        test byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_MUTED
        jnz snmc_off_muted

            # output to sound control port
            out IO_SND_CH_CTRL, al

        snmc_off_muted:

        ret

    # noise mode > 0
    snmc_noise_on:
        
        # get noise tap value with noise enable bit
        dec al
        or al, SND_NOISE_ENABLE | SND_NOISE_RESET
        mov [di + MUSIC_STATE_NOISE_MODE], al
        mov ah, al

        # set ch4 noise bit
        in al, IO_SND_CH_CTRL
        or al, SND_CH4_NOISE

        # update noise flag in state
        or byte ptr [di + MUSIC_STATE_FLAGS], STATE_FLAG_NOISE_ON

        # don't actually update value on chip if channel muted
        test byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_MUTED
        jnz snmc_on_muted

            # output to sound control port
            out IO_SND_CH_CTRL, al

            # output to noise control port
            mov al, ah
            out IO_SND_NOISE_CTRL, al

        snmc_on_muted:

        ret