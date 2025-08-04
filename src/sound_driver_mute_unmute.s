
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_get_channels
.global sound_mute_channel
.global sound_unmute_channel
.global sound_unmute_all
.global sound_mute_channels

.section .fartext.sound_driver, "ax"

# ax : song_state pointer
# returns
# al : channels byte
sound_get_channels:

    push di
    push es

    mov di, ax
    mov es, [di + MUSIC_STATE_SEGMENT]
    mov al, es:[SONG_HEADER_CHANNELS]

    pop es
    pop di

    IA16_RET


# ax : song state pointer
# dl : channel
sound_mute_channel:

    push di

    # get song state pointer in di
    mov di, ax

    # get pointer to channel in bx
    mov al, dl
    and al, 0x3
    mov bl, CHANNEL_SIZE
    mul bl
    mov bx, [di + MUSIC_STATE_CHANNELS_PTR]
    add bx, ax

    # set muted flag and clear note-on flag
    or byte ptr [bx + CHANNEL_FLAGS], CHAN_FLAG_MUTED
    and byte ptr [bx + CHANNEL_FLAGS], ~CHAN_FLAG_NOTE_ON

    # check if this is ch2 which has voice mode
    cmp dl, 1
    jnz smc_not_ch2

        # sample playing?
        test byte ptr [di + MUSIC_STATE_FLAGS], STATE_FLAG_SAMPLE_PLAYING
        jz smc_not_ch2

            # stop sample playback
            call sound_sample_note_off

    smc_not_ch2:

    # set chip channel volume to 0
    add dl, WS_SOUND_VOL_CH1_PORT
    xor dh, dh
    xor al, al
    out dx, al

    pop di

    IA16_RET

# ax: song state pointer
# dl: channels byte
sound_mute_channels:

    push di
    push si
    push es

    # get song state pointer in di
    mov di, ax

    # song segment in es
    mov es, [di + MUSIC_STATE_SEGMENT]

    # get pointer to channels in si
    mov si, [di + MUSIC_STATE_CHANNELS_PTR]

    # keep channels byte in ah
    mov ah, dl

    # loop through 4 channels
    mov cx, 4

    smc_channels_loop:

        # is this a channel to mute?
        test ah, 0x1
        jz smc_cl_dont_mute

            # set muted flag and clear note-on flag
            or byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_MUTED
            and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_NOTE_ON

            # set chip channel volume to 0
            mov dl, [si + CHANNEL_NUMBER]
            add dl, WS_SOUND_VOL_CH1_PORT
            xor dh, dh
            xor al, al
            out dx, al

            # is this ch2?
            cmp byte ptr [si + CHANNEL_NUMBER], 0x1
            jnz smc_loop_not_ch2

                # is a sample playing?
                test byte ptr [di + MUSIC_STATE_FLAGS], STATE_FLAG_SAMPLE_PLAYING
                jz smc_loop_not_ch2

                    push ax
                    call sound_sample_note_off
                    pop ax

            smc_loop_not_ch2:

        smc_cl_dont_mute:

        # move the next most significant bit into position
        # move to next channel
        shr ah, 1
        add si, CHANNEL_SIZE

        loopnz smc_channels_loop

    pop es
    pop si
    pop di

    IA16_RET


# ax : song state pointer
# dl : channel
sound_unmute_channel:

    push di
    push si
    push es

    # get song state pointer in di
    mov di, ax

    # song segment in es
    mov es, [di + MUSIC_STATE_SEGMENT]

    # get pointer to channel in si
    mov al, dl
    and al, 0x3
    mov bl, CHANNEL_SIZE
    mul bl
    mov si, [di + MUSIC_STATE_CHANNELS_PTR]
    add si, ax

    # clear muted flag
    and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_MUTED

    # restore noise control value
    mov [di + MUSIC_STATE_NOISE_MODE], al
    out WS_SOUND_NOISE_CTRL_PORT, al

    # is this channel 4?
    # restore noise mode value in sound control register
    cmp dl, 0x3
    jnz sunmc_not_ch4

        # get current register value
        in al, WS_SOUND_CH_CTRL_PORT
        and al, ~WS_SOUND_CH_CTRL_CH4_NOISE

        # should noise be on?
        test byte ptr [di + MUSIC_STATE_FLAGS], STATE_FLAG_NOISE_ON
        jz sunmc_noise_off

            or al, WS_SOUND_CH_CTRL_CH4_NOISE

        sunmc_noise_off:

        # update register
        out WS_SOUND_CH_CTRL_PORT, al

    sunmc_not_ch4:

    # restore wavetable
    mov al, [si + CHANNEL_WAVETABLE_NUM]
    call sound_wavetable_change
    
    pop es
    pop si
    pop di

    IA16_RET

# ax : song state pointer
sound_unmute_all:

    push di
    push si
    push es

    # get song state pointer in di
    mov di, ax

    # song segment in es
    mov es, [di + MUSIC_STATE_SEGMENT]

    # get pointer to channels in si
    mov si, [di + MUSIC_STATE_CHANNELS_PTR]

    # get number of channels to go through into cx
    mov cl, es:[SONG_HEADER_CHANNELS]
    shr cl, 4
    xor ch, ch

    suall_loop:

        # don't do anything if this channel is not muted
        test byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_MUTED
        jz suall_not_muted

            # clear muted flag
            and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_MUTED

            # restore wavetable
            mov al, [si + CHANNEL_WAVETABLE_NUM]
            call sound_wavetable_change

            # is this channel 4?
            # restore noise mode value in sound control register
            cmp byte ptr [si + CHANNEL_NUMBER], 0x3
            jnz sunmac_not_ch4

                # get current register value
                in al, WS_SOUND_CH_CTRL_PORT
                and al, ~WS_SOUND_CH_CTRL_CH4_NOISE

                # should noise be on?
                test byte ptr [di + MUSIC_STATE_FLAGS], STATE_FLAG_NOISE_ON
                jz sunmac_noise_off

                    or al, WS_SOUND_CH_CTRL_CH4_NOISE

                sunmac_noise_off:

                # update register
                out WS_SOUND_CH_CTRL_PORT, al

            sunmac_not_ch4:

        suall_not_muted:

        # move to next channel
        add si, CHANNEL_SIZE
        
        loopnz suall_loop

    # restore noise control value
    mov [di + MUSIC_STATE_NOISE_MODE], al
    out WS_SOUND_NOISE_CTRL_PORT, al

    pop es
    pop si
    pop di

    IA16_RET