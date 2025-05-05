
#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_update_slide

.section .text.sound_driver

sound_update_slide:

    # get slide type
    mov al, [si + CHANNEL_FLAGS]
    and al, CHAN_FLAG_SLIDE_PORTA
    rol al
    rol al

    # get current pitch
    mov bx, [si + CHANNEL_FREQ]

    # is it slide up?
    dec al
    jnz sus_not_slide_up

        # add slide amount to frequency
        mov al, [si + CHANNEL_SLIDE_AMOUNT]
        xor ah, ah
        add bx, ax

        # have we slid too far?
        cmp bx, SLIDE_UP_MAX
        jc sus_up_not_max

            # clamp it if we have
            mov bx, SLIDE_UP_MAX

        sus_up_not_max:

        # update pitch
        mov [si + CHANNEL_FREQ], bx

        ret

    sus_not_slide_up:

    # is it slide down
    dec al
    jnz sus_not_slide_down

        # subtract slide amount from frequency
        mov al, [si + CHANNEL_SLIDE_AMOUNT]
        xor ah, ah
        sub bx, ax

        # have we slid too far?
        jnc sus_down_not_min

            # clamp it if we have
            mov bx, 0

        sus_down_not_min:

        # update pitch
        mov [si + CHANNEL_FREQ], bx

        ret

    sus_not_slide_down:
    dec al
    jnz sus_not_slide_porta

        # get target frequency
        mov ax, [si + CHANNEL_TARGET_FREQ]
        cmp ax, bx
        jc sus_slide_porta_target_below

            # target is above
            # subtract slide amount from frequency
            mov dl, [si + CHANNEL_SLIDE_AMOUNT]
            xor dh, dh
            add bx, dx

            # have we slid too far?
            cmp ax, bx
            jc sus_slide_porta_target_reached

            # update pitch
            # return freq in bx
            mov [si + CHANNEL_FREQ], bx
            ret

        sus_slide_porta_target_below:

            # target is below
            # subtract slide amount from frequency
            mov dl, [si + CHANNEL_SLIDE_AMOUNT]
            xor dh, dh
            sub bx, dx

            # have we slid too far?
            cmp ax, bx
            jnc sus_slide_porta_target_reached

            # update pitch
            # return freq in bx
            mov [si + CHANNEL_FREQ], bx
            ret

        sus_slide_porta_target_reached:

            # clear slide flag
            and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_SLIDE_PORTA

            # set freq = target_freq
            # return freq in bx
            mov [si + CHANNEL_FREQ], ax
            mov bx, ax

            ret

    sus_not_slide_porta:

    ret
