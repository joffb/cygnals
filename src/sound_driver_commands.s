
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sunl_commands

.section .fartext.sound_driver, "ax"

.balign 2
sunl_commands:
    .short sunl_note_on
    .short sunl_note_off
    .short sunl_instrument_change
    .short sunl_volume_change
    .short sunl_wavetable_change
    .short sunl_noise_mode
    .short sunl_slide_up
    .short sunl_slide_down
    .short sunl_slide_portamento
    .short sunl_slide_off
    .short sunl_arpeggio
    .short sunl_arpeggio_off
    .short sunl_vibrato
    .short sunl_vibrato_off
    .short sunl_do_nothing_1_byte
    .short sunl_do_nothing_1_byte
    .short sunl_panning
    .short sunl_panning_left
    .short sunl_panning_right
    .short sunl_sample_note_on
    .short sunl_sample_note_off
    .short sunl_speaker_loudness
    .short sunl_do_nothing_1_byte
    .short sunl_do_nothing_1_byte
    .short sunl_do_nothing_2_byte
    .short sunl_order_jump
    .short sunl_set_speed_1
    .short sunl_set_speed_2
    .short sunl_order_next
    .short sunl_note_delay
    .short sunl_do_nothing_1_byte
    .short sunl_do_nothing

sunl_do_nothing_2_byte:

    inc bx

sunl_do_nothing_1_byte:

    inc bx

sunl_do_nothing:

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_note_on:

    # move on command pointer
    add bx, 2

    # set note-on, volume and pitch change event flags
    or word ptr [si + CHANNEL_FLAGS], CHAN_FLAG_NOTE_ON | ((CHAN_FLAG2_VOLUME_CHANGE | CHAN_FLAG2_PITCH_CHANGED) << 8)

    # is this ch2?
    cmp byte ptr [si + CHANNEL_NUMBER], 0x1
    jnz sunlno_not_ch2

        # is a sample playing?
        test byte ptr [di + MUSIC_STATE_FLAGS], STATE_FLAG_SAMPLE_PLAYING
        jz sunlno_not_ch2

            push ax
            call sound_sample_note_off
            pop ax

    sunlno_not_ch2:

    # get midi note in al
    mov al, ah

    # multiply midi note by 32 to make it an index into the note table
    xor ah, ah
    shl ax, 5

    # is slide portamento on?
    mov cl, [si + CHANNEL_FLAGS]
    and cl, CHAN_FLAG_SLIDE_PORTA
    cmp cl, CHAN_FLAG_SLIDE_PORTA
    jz sunlno_has_slide_porta

        # slide portamento is off

        # set channel frequency
        mov [si + CHANNEL_FREQ], ax

        # reset macros 
        xor al, al
        mov [si + CHANNEL_VOLUME_MACRO_POS], al
        mov [si + CHANNEL_WAVE_MACRO_POS], al
        mov [si + CHANNEL_EX_MACRO_POS], al
        mov [si + CHANNEL_ARP_MACRO_POS], al

        jmp sunl_loop

    sunlno_has_slide_porta:

        # don't reset macros 
        # set frequency as a target 
        mov [si + CHANNEL_TARGET_FREQ], ax

        jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_note_off:

    # move on command pointer
    inc bx

    # clear note-on flag
    and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_NOTE_ON

    # silence channel - if it's not currently muted
    test byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_MUTED
    jnz sunl_loop

        mov dl, [si + CHANNEL_NUMBER]
        add dl, WS_SOUND_VOL_CH1_PORT
        xor dh, dh
        xor al, al
        out dx, al

        jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_instrument_change:

    # move on command pointer
    add bx, 2

    # are we already using this instrument?
    mov al, ah
    cmp al, [si + CHANNEL_INSTRUMENT_NUM]
    jz sunl_loop

        call sound_instrument_change

        jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_volume_change:

    # set volume change event flag
    or byte ptr [si + CHANNEL_FLAGS2], CHAN_FLAG2_VOLUME_CHANGE

    # get new volume
    mov [si + CHANNEL_VOLUME], ah

    # move on command pointer
    add bx, 2

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_wavetable_change:

    # get new wavetable number in al
    mov al, ah

    # change wavetable
    call sound_wavetable_change

    # move on command pointer
    add bx, 2

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_noise_mode:

    # get new noise mode
    mov al, ah
    mov [di + MUSIC_STATE_NOISE_MODE], al

    # move on command pointer
    add bx, 2

    # change noise mode - if it's not currently muted
    test byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_MUTED
    jnz sunl_loop

        call sound_noise_mode_change

        jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_slide_up:

    # set slide flag
    and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_PITCH_EFFECT_MASK
    or byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_SLIDE_UP

    # get slide amount
    mov [si + CHANNEL_ARP_VIB_POS], ah

    # move on command pointer
    add bx, 2

    jmp sunl_loop  


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_slide_down:

    # set slide flag
    and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_PITCH_EFFECT_MASK
    or byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_SLIDE_DOWN

    # get slide amount
    mov [si + CHANNEL_ARP_VIB_POS], ah

    # move on command pointer
    add bx, 2

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_slide_portamento:

    # set slide flag
    and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_PITCH_EFFECT_MASK
    or byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_SLIDE_PORTA

    # get slide amount
    mov [si + CHANNEL_ARP_VIB_POS], ah

    # move on command pointer
    add bx, 2

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_slide_off:

    # clear slide flag
    and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_PITCH_EFFECT_MASK

    # move on command pointer
    inc bx

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_arpeggio:

    # set arpeggio flag
    and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_PITCH_EFFECT_MASK
    or byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_ARPEGGIO

    # arpeggio amount is in ah, reset phase
    xor al, al
    mov [si + CHANNEL_ARP_VIB_POS], ax

    # move on command pointer
    add bx, 2

    jmp sunl_loop  


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_arpeggio_off:

    # clear arpeggio flag
    and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_PITCH_EFFECT_MASK

    # mark pitch as requiring update
    or byte ptr [si + CHANNEL_FLAGS2], CHAN_FLAG2_PITCH_CHANGED

    # move on command pointer
    inc bx

    jmp sunl_loop  


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_vibrato:

    # set vibrato flag
    and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_PITCH_EFFECT_MASK
    or byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_VIBRATO

    # vibrato amount is in ah, reset phase
    xor al, al
    mov [si + CHANNEL_ARP_VIB_POS], ax

    # move on command pointer
    add bx, 2

    jmp sunl_loop  


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_vibrato_off:

    # clear vibrato flag
    and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_PITCH_EFFECT_MASK

    # mark pitch as requiring update
    or byte ptr [si + CHANNEL_FLAGS2], CHAN_FLAG2_PITCH_CHANGED

    # move on command pointer
    inc bx

    jmp sunl_loop  


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_panning:

    # set volume change event flag
    or byte ptr [si + CHANNEL_FLAGS2], CHAN_FLAG2_VOLUME_CHANGE

    # get new panning
    mov [si + CHANNEL_PAN], ah

    # move on command pointer
    add bx, 2

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_panning_left:

    # set volume change event flag
    or byte ptr [si + CHANNEL_FLAGS2], CHAN_FLAG2_VOLUME_CHANGE

    # get new panning
    mov al, [si + CHANNEL_PAN]
    and al, 0x0f
    or al, ah
    mov [si + CHANNEL_PAN], al

    # move on command pointer
    add bx, 2

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_panning_right:

    # set volume change event flag
    or byte ptr [si + CHANNEL_FLAGS2], CHAN_FLAG2_VOLUME_CHANGE

    # get new panning
    mov al, [si + CHANNEL_PAN]
    and al, 0xf0
    or al, ah
    mov [si + CHANNEL_PAN], al

    # move on command pointer
    add bx, 2

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_sample_note_on:

    # don't do anything if channel muted
    test byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_MUTED
    jnz snl_sno_muted
        
        call sound_sample_note_on
        
    snl_sno_muted:

    # move on command pointer
    add bx, 2

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_sample_note_off:
    
    # don't do anything if channel muted
    test byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_MUTED
    jnz snl_snoff_muted

        call sound_sample_note_off

    snl_snoff_muted:

    # move on command pointer
    inc bx

    jmp sunl_loop

# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_speaker_loudness:

    # update loudness value 
    mov al, ah
    or al, WS_SOUND_OUT_CTRL_HEADPHONE_ENABLE | WS_SOUND_OUT_CTRL_SPEAKER_ENABLE
    out WS_SOUND_OUT_CTRL_PORT, al

    # move on command pointer
    add bx, 2

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_set_speed_1:

    # get new speed and store it
    mov [di + MUSIC_STATE_SPEED_1], ah

    # move on command pointer
    add bx, 2

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_set_speed_2:

    # get new speed and store it
    mov [di + MUSIC_STATE_SPEED_2], ah

    # move on command pointer
    add bx, 2

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_order_jump:

    # move on command pointer
    add bx, 2

    # order number is in ah
    # check that it's a valid order rnumber
    cmp ah, es:[SONG_HEADER_ORDERS_LENGTH]
    jz sunl_order_jump_invalid
    jnc sunl_order_jump_invalid

        # store order to jump to
        mov [di + MUSIC_STATE_ORDER_JUMP], ah

    sunl_order_jump_invalid:

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_order_next:

    # get new order by adding 1 to current order
    mov al, [di + MUSIC_STATE_ORDER]
    inc al

    # check that it's a valid order rnumber
    cmp al, es:[SONG_HEADER_ORDERS_LENGTH]
    jc sunl_order_next_valid
    jnz sunl_order_next_valid

        # wrap back to order 0
        xor al, al

    sunl_order_next_valid:

    # store order to jump to
    mov [di + MUSIC_STATE_ORDER_JUMP], al

    # move on command pointer
    inc bx

    jmp sunl_loop


# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sunl_note_delay:

    # get note delay time and store it
    mov [si + CHANNEL_WAIT], ah

    # set tic wait flag
    or byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_TIC_WAIT

    # move on command pointer
    add bx, 2

    # update pattern pointer
    mov [si + CHANNEL_PATTERN_PTR], bx

    # return from sound_update_new_line
    # without finishing the line
    ret