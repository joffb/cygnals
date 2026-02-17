
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_update_channel_pitch

#ifdef __IA16_CMODEL_IS_FAR_TEXT
.section .fartext.sound_driver, "ax"
#else
.section .text.sound_driver, "ax"
#endif


# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
# cx - channel flags
sound_update_channel_pitch:

    # update slide if needed
    test cl, CHAN_FLAG_SLIDE_PORTA
    jz suc_no_slide

        call sound_update_slide
        jmp suc_skip_arp_vibrato

    suc_no_slide:

        # current frequency
        mov bx, [si + CHANNEL_FREQ]

        # update vibrato if needed
        test cl, CHAN_FLAG_VIBRATO
        jz suc_no_vibrato

            call sound_update_vibrato
            add bx, ax

        suc_no_vibrato:

        # update arpeggio if needed
        test cl, CHAN_FLAG_ARPEGGIO
        jz suc_no_arpeggio

            call sound_update_arpeggio
            add bx, ax

    suc_no_arpeggio:
    suc_skip_arp_vibrato:

    # is there a pitch ex macro going?
    test ch, CHAN_FLAG2_PITCH_MACRO
    jz suc_no_pitch_ex_macro

        # get macro val
        call sound_update_ex_macro

        # sign extend al into ah
        cbw

        # add to running total
        add bx, ax

    suc_no_pitch_ex_macro:

    # is there an arp macro going?
    test ch, CHAN_FLAG2_ARP_MACRO
    jz suc_no_arp_macro

        # get macro val
        call sound_update_arp_macro

        # msb set means it's absolute
        test al, 0x80
        jz suc_arp_macro_relative

            # isolate lower bits
            and al, 0x7f
            xor ah, ah

            # shift so it's * 32
            shl ax, 5

            # replace pitch
            mov bx, ax

            jmp suc_arp_macro_done

        suc_arp_macro_relative:

            # this is a 7 bit signed number
            # shift up by 1
            shl al, 1

            # sign extend al into ah
            cbw

            # shift again so it's * 32
            shl ax, 4

            # add to running total
            add bx, ax

    suc_arp_macro_done:
    suc_no_arp_macro:

    # get pitch
    shl bx, 1
    add bx, offset sound_note_table
    mov bx, cs:[bx]

    # get port number for pitch for this channel
    mov dl, [si + CHANNEL_NUMBER]
    add dl ,dl
    add dl, WS_SOUND_FREQ_CH1_PORT
    xor dh, dh

    # update pitch
    mov ax, bx
    out dx, ax

    ret
