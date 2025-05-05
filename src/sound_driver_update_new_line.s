
#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sunl_loop
.global sound_update_new_line

.section .text.sound_driver

# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sound_update_new_line:

    # check if we're waiting x number of lines
    mov al, [si + CHANNEL_WAIT]
    or al, al
    jz sunl_no_line_wait

        # decrement and update line wait count
        dec al
        mov [si + CHANNEL_WAIT], al

        ret

    sunl_no_line_wait:

        # get command pointer into bx
        mov bx, [si + CHANNEL_PATTERN_PTR]

        sunl_loop:

        # get command
        # load a word as many commands use two bytes
        mov ax, es:[bx]

        # is it a wait command?
        test al, 0x80
        jz sunl_not_wait_command

            # it is a wait

            # move on command pointer
            inc bx
            
            # lower 7 bits is the number of lines to wait
            and al, 0x7f
            mov [si + CHANNEL_WAIT], al
            jmp sunl_done

        sunl_not_wait_command:

            # preserve command pointer
            push bx

            # get address of command to jump to
            add al, al
            mov bx, offset sunl_commands
            add bl, al
            adc bh, 0
            mov dx, cs:[bx]
            
            # restore command pointer
            pop bx

            # jump to command
            jmp dx

        sunl_done:

            # update pattern pointer
            mov [si + CHANNEL_PATTERN_PTR], bx

            ret