
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_noise_mode_change

.section .fartext.sound_driver, "ax"

# al : noise mode
sound_noise_mode_change:

    # noise mode = 0
    or al, al
    jnz snmc_noise_on

        # clear ch4 noise bit
        in al, WS_SOUND_CH_CTRL_PORT 
        and al, ~WS_SOUND_CH_CTRL_CH4_NOISE

        # update noise flag in state
        and byte ptr [di + MUSIC_STATE_FLAGS], ~STATE_FLAG_NOISE_ON

        # don't actually update value on chip if channel muted
        test byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_MUTED
        jnz snmc_off_muted

            # output to sound control port
            out WS_SOUND_CH_CTRL_PORT, al

        snmc_off_muted:

        ret

    # noise mode > 0
    snmc_noise_on:
        
        # get noise tap value with noise enable bit
        # and reset lsfr while we're here
        dec al
        or al, WS_SOUND_NOISE_CTRL_RESET | WS_SOUND_NOISE_CTRL_ENABLE
        mov ah, al

        # update noise flag in state
        or byte ptr [di + MUSIC_STATE_FLAGS], STATE_FLAG_NOISE_ON

        # don't actually update value on chip if channel muted
        test byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_MUTED
        jnz snmc_on_muted

            # output to sound control port
            
            # set ch4 noise bit
            in al, WS_SOUND_CH_CTRL_PORT
            or al, WS_SOUND_CH_CTRL_CH4_NOISE
            out WS_SOUND_CH_CTRL_PORT, al

            # output tap & noise enable to noise control port
            mov al, ah
            out WS_SOUND_NOISE_CTRL_PORT, al

        snmc_on_muted:

        ret