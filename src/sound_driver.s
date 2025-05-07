
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_play
.global sound_update
.global sound_stop
.global sound_resume

.global sound_set_wavetable_ram_address

.global sound_wavetable_ram_ptr

.data

sound_wavetable_ram_ptr: .word WAVETABLE_WRAM

.section .text.sound_driver

sound_play:

    # get channels pointer into bx from stack
    push bp
    mov bp, sp
    mov bx, [bp + WF_PLATFORM_CALL_STACK_OFFSET(2)] 
    pop bp

    push es
    push ds
    pusha

    # es = song segment
    mov es, dx

    # di = song state
    mov di, cx

    # save song's segment in song state
    mov [di + MUSIC_STATE_SEGMENT], dx

    # save channels pointer in song state
    mov [di + MUSIC_STATE_CHANNELS_PTR], bx

    # check for a magic byte at the start of the segment
    cmp byte ptr es:[SONG_HEADER_MAGIC_BYTE], BANJO_MAGIC_BYTE
    jnz sound_play_done

    # copy song header from rom into ram
    # don't overwrite the song segment or channel pointer
    mov bx, 0
    mov cx, (MUSIC_STATE_SIZE - 4) >> 1

    sp_copy_header_loop:

        mov ax, es:[bx + SONG_HEADER_SIZE]
        mov [di + bx], ax
        add bx, 2

        loopnz sp_copy_header_loop

    # initialise pattern pointers
    mov al, 0
    call sound_update_change_pattern

    # channels pointer in si
    mov si, [di + MUSIC_STATE_CHANNELS_PTR]

    # init channel 0?
    test byte ptr es:[SONG_HEADER_CHANNELS], 0x1
    jz sp_no_ch0

        mov al, 0
        call sound_init_channel
        add si, CHANNEL_SIZE

    sp_no_ch0:

    # init channel 1?
    test byte ptr es:[SONG_HEADER_CHANNELS], 0x2
    jz sp_no_ch1

        mov al, 1
        call sound_init_channel
        add si, CHANNEL_SIZE
        
    sp_no_ch1:

    # init channel 2?
    test byte ptr es:[SONG_HEADER_CHANNELS], 0x4
    jz sp_no_ch2

        mov al, 2
        call sound_init_channel
        add si, CHANNEL_SIZE

    sp_no_ch2:

    # init channel 3?
    test byte ptr es:[SONG_HEADER_CHANNELS], 0x8
    jz sp_no_ch3

        mov al, 3
        call sound_init_channel
        add si, CHANNEL_SIZE

    sp_no_ch3:

    # initialise sound chip stuff

    # don't mute channels and initialise wavetables for sfx
    test byte ptr [di + MUSIC_STATE_FLAGS], STATE_FLAG_SFX
    jnz sound_play_done

    # enable channels 0-3
    mov al, [di + MUSIC_STATE_SOUND_CH_CONTROL]
	out IO_SND_CH_CTRL, al

	# set audio output level
	mov al, 0x0f
	out IO_SND_OUT_CTRL, al
	
	# set channel volumes
	xor al, al
	out IO_SND_VOL_CH1, al
	out IO_SND_VOL_CH2, al
	out IO_SND_VOL_CH3, al
	out IO_SND_VOL_CH4, al

    # get wave ram location
    mov bx, [sound_wavetable_ram_ptr]

    # turn it into a value for the wave base register
    mov ax, bx
    shr ax, 6
    mov dx, IO_SND_WAVE_BASE
    out dx, al

    # write wavetables starting at bx
    mov cx, 4
    mov dx, 0x2222

    sp_init_wavetables:

        mov ax, 0x1100

        mov [bx], ax
        add ax, dx
        mov [bx + 2], ax
        add ax, dx
        mov [bx + 4], ax
        add ax, dx
        mov [bx + 6], ax
        add ax, dx
        mov [bx + 8], ax
        add ax, dx
        mov [bx + 10], ax
        add ax, dx
        mov [bx + 12], ax
        add ax, dx
        mov [bx + 14], ax
        add ax, dx

        add bx, 16

        loopnz sp_init_wavetables

    sound_play_done:

    popa
    pop ds
    pop es

    WF_PLATFORM_RET 0x2


# ds - ram segment
# es - song segment
# si - pointer to channel
# al - channel number
sound_init_channel:

    # initialise variables
    mov [si + CHANNEL_NUMBER], al

    xor al, al
    mov [si + CHANNEL_FLAGS], al
    mov [si + CHANNEL_FLAGS2], al
    mov [si + CHANNEL_WAIT], al
    mov [si + CHANNEL_PAN], al

    dec al
    mov [si + CHANNEL_INSTRUMENT_NUM], al
    mov [si + CHANNEL_WAVETABLE_NUM], al

    mov al, 0x0f
    mov [si + CHANNEL_VOLUME], al

    ret

# ax: song state pointer
sound_stop:

    push di

    # is a song currently playing?
    mov di, ax
    test byte ptr [di + MUSIC_STATE_FLAGS], STATE_FLAG_PLAYING
    jz sound_stop_done

        # clear playing flag
        and byte ptr [di + MUSIC_STATE_FLAGS], ~STATE_FLAG_PLAYING

        # is a sample playing?
        test byte ptr [di + MUSIC_STATE_FLAGS], STATE_FLAG_SAMPLE_PLAYING
        jz ss_no_sample_playing

            call sound_sample_note_off

        ss_no_sample_playing:

        # mute channel volumes
        xor al, al
        out IO_SND_VOL_CH1, al
        out IO_SND_VOL_CH2, al
        out IO_SND_VOL_CH3, al
        out IO_SND_VOL_CH4, al

    sound_stop_done:

    pop di

    WF_PLATFORM_RET

# ax: song state pointer
sound_resume:

    mov bx, ax
    or byte ptr [bx + MUSIC_STATE_FLAGS], STATE_FLAG_PLAYING

    WF_PLATFORM_RET

# ax: wavetable ram address
sound_set_wavetable_ram_address:

    mov [sound_wavetable_ram_ptr], ax

    WF_PLATFORM_RET