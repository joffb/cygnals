
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global cygnals_update
.global sound_update_change_pattern

#ifdef __IA16_CMODEL_IS_FAR_TEXT
.section .fartext.sound_driver, "ax"
#else
.section .text.sound_driver, "ax"
#endif


# ax - song state
cygnals_update:

    push es
    push ds
    pusha

	# get song state pointer into di
    mov di, ax

    # check playing flag, we're done if it's not set
    test byte ptr [di + MUSIC_STATE_FLAGS], CYG_STATE_FLAG_PLAYING
    jz sound_update_done

    # es = song segment
    mov es, [di + MUSIC_STATE_SEGMENT]

    # decrement tic
    dec byte ptr [di + MUSIC_STATE_TIC]

    # when it hits 0 we need to move to the next line
    # (tic == speed)
    jnz music_update_tics_done

        # decrement line
        dec byte ptr [di + MUSIC_STATE_LINE]

        # when it's 0 we need to move to the next pattern
        jz mu_end_of_pattern

        # is there an order jump pending?
        mov al, [di + MUSIC_STATE_ORDER_JUMP]
        cmp al, 0xff
        jnz mu_order_jump

            # it's not the end of a pattern
            # reset tic to different value depending on line number
            test byte ptr [di + MUSIC_STATE_LINE], 1
            jnz mut_speed2

                mov al, [di + MUSIC_STATE_SPEED_1]
                mov [di + MUSIC_STATE_TIC], al

                jmp mut_speed_picked

            mut_speed2:

                mov al, [di + MUSIC_STATE_SPEED_2]
                mov [di + MUSIC_STATE_TIC], al

            mut_speed_picked:

            # set signal that we need to process the next line
            or byte ptr [di + MUSIC_STATE_FLAGS], CYG_STATE_FLAG_PROCESS_NEW_LINE

            jmp music_update_tics_done

        # move on to next pattern
        mu_end_of_pattern:

            mov al, [di + MUSIC_STATE_ORDER]
            inc al

            # check if we've hit the last order
            cmp al, es:[SONG_HEADER_ORDERS_LENGTH]
            jz mut_last_order

                call sound_update_change_pattern

                jmp music_update_tics_done

            mut_last_order:

                # return channels to first order
                xor al, al
                mov [di + MUSIC_STATE_ORDER], al

                # update pattern pointers
                call sound_update_change_pattern

                # is this song looping?
                test byte ptr [di + MUSIC_STATE_FLAGS], CYG_STATE_FLAG_LOOP
                jnz music_update_tics_done

                    # clear playing flag
                    and byte ptr [di + MUSIC_STATE_FLAGS], ~CYG_STATE_FLAG_PLAYING

                    # for sfx, don't mute all channels
                    test byte ptr [di + MUSIC_STATE_FLAGS], CYG_STATE_FLAG_SFX
                    jnz sound_update_done

                        # not looping
                        # mute channels
                        mov al, 0x00
                        mov dx, WS_SOUND_VOL_CH1_PORT
                        out dx, al
                        inc dx
                        out dx, al
                        inc dx
                        out dx, al
                        inc dx
                        out dx, al

                        jmp sound_update_done

            mu_order_jump:

                call sound_update_change_pattern

                # clear order jump
                mov byte ptr [di + MUSIC_STATE_ORDER_JUMP], 0xff

		music_update_tics_done:

			mov si, [di + MUSIC_STATE_CHANNELS_PTR]

            # sfx may have different numbers of channels
            mov cl, es:[SONG_HEADER_CHANNELS]
            shr cl, 4
            xor ch, ch

            # is this an sfx?
            muc_channels_loop:

                push cx

                call sound_update_channel
                add si, CHANNEL_SIZE

                pop cx

                loopnz muc_channels_loop

			# clear signal that we need to process the next line
			and byte ptr [di + MUSIC_STATE_FLAGS], ~CYG_STATE_FLAG_PROCESS_NEW_LINE

    sound_update_done:

    popa
    pop ds
    pop es

    IA16_RET

# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sound_update_channel:

    # is there a tic wait?
    test byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_TIC_WAIT
    jz suc_no_tic_wait

        # decrement and update tic wait
        dec byte ptr [si + CHANNEL_WAIT]

        # when tic_wait > 0, do nothing
        jnz suc_no_tic_wait

            # tic wait = 0, finish the line
            and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_TIC_WAIT
            call sound_update_new_line

    suc_no_tic_wait:

    # has a new line been reached?
    test byte ptr [di + MUSIC_STATE_FLAGS], CYG_STATE_FLAG_PROCESS_NEW_LINE
    jz suc_same_line

        call sound_update_new_line

    suc_same_line:

    # get flags into cx
    mov cx, [si + CHANNEL_FLAGS]

    # is this channel note-off or muted?
    mov al, cl
    and al, CHAN_FLAG_MUTED | CHAN_FLAG_NOTE_ON
    cmp al, CHAN_FLAG_NOTE_ON
    jnz sound_update_channel_done

        # does the volume need updating?
        # volume change flagged or a volume macro active?
        test ch, CHAN_FLAG2_VOLUME_CHANGE | CHAN_FLAG2_VOLUME_MACRO
        jz suc_no_volume_change

            call sound_update_channel_volume

        suc_no_volume_change:

        # is there a wave macro?
        test ch, CHAN_FLAG2_WAVE_MACRO
        jz suc_no_wave_macro

            call sound_update_wave_macro

        suc_no_wave_macro:

        # is there a duty macro?
        test ch, CHAN_FLAG2_DUTY_MACRO
        jz suc_no_ex_macro

            call sound_update_ex_macro
            call sound_noise_mode_change

        suc_no_ex_macro:

        # does the pitch need updating?
        # pitch changed flagged, either vibrato active
        test cx, CHAN_FLAG_VIBRATO | CHAN_FLAG_ARPEGGIO | CHAN_FLAG_SLIDE_PORTA | ((CHAN_FLAG2_ARP_MACRO | CHAN_FLAG2_PITCH_MACRO | CHAN_FLAG2_PITCH_CHANGED) << 8)
        jz suc_no_pitch_change

            call sound_update_channel_pitch

        suc_no_pitch_change:

    sound_update_channel_done:

    # clear pitch and volume changed flags
    and byte ptr [si + CHANNEL_FLAGS2], ~(CHAN_FLAG2_PITCH_CHANGED | CHAN_FLAG2_VOLUME_CHANGE)

    ret
