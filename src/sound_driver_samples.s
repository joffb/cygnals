
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_sample_note_on
.global sound_sample_note_off
.global sound_sample_ptr
.global sound_calc_sample_voice_volume
.global sound_ds_value

.section .iram.cygnals_iram

    # the value of ds may be changed when an interrupt runs
    # variable used to store the correct ds for use in the interrupt
    .balign 2
    sound_ds_value: .word 0

.data

    .balign 2
    sound_sample_state_ptr: .word 0

    sound_sample_segment: .word 0

    sound_sample_start: .word 0
    sound_sample_length: .word 0

    sound_sample_ptr: .word 0
    sound_sample_counter: .word 0

    sound_sample_flags: .byte 0

    #ifdef __WONDERFUL_WWITCH__
        sound_sample_irq_vector:
            sound_sample_irq_offset: .word 0
            sound_sample_irq_segment: .word 0
            sound_sample_irq_data_segment: .word 0
            sound_sample_irq_unknown: .word 0
    #endif


.section .fartext.sound_driver, "ax"


# return sound channel 2 voice volume
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
#
# cx - channel flags
sound_calc_sample_voice_volume:
    
    mov al, [si + CHANNEL_VOLUME]

	# volume macro level if present
	test ch, CHAN_FLAG2_VOLUME_MACRO
	jz scsvv_no_volume_macro

        # keep current volume in dl
        mov dl, al

		call sound_update_volume_macro

        # scale volume by macro level
        inc al
        mul dl
        shr al, 4

	scsvv_no_volume_macro:

    # check if master volume > 0x80
    mov cl, [di + MUSIC_STATE_MASTER_VOLUME]
    test cl, 0x80
    jnz scsvv_master_volume_full

        # multiply channel volume by master volume
        shr cl, 3
        inc cl
        mul cl
        shr al, 4

    scsvv_master_volume_full:

    # volume == 0 ?
    or al, al
    jnz scsvv_not_zero

        ret

    # volume < 8 ?
    scsvv_not_zero:
    cmp al, 8
    jnc scsvv_vol_max

        mov al, (2 | (2 << 2))
        ret

    scsvv_vol_max:

        mov al, (1 | (1 << 2))
        ret

sound_sample_update_interrupt:

    push ds
    push es
    push ax
    push bx

    mov ds, ss:[sound_ds_value]
    mov es, [sound_sample_segment]
    mov bx, [sound_sample_ptr]

    # get and output next sample 
    mov al, es:[bx]
    out WS_SOUND_VOL_CH2_PORT, al

    # get counter and decrease it
    dec word ptr [sound_sample_counter]
    jnz ssu_int_not_end

        # looping?
        test byte ptr [sound_sample_flags], WS_SDMA_CTRL_REPEAT
        jnz ssu_int_looping

            # is not looping
            # disable interrupt

            # disable line timer interrupts
            in al, WS_INT_ENABLE_PORT
            and al, ~WS_INT_ENABLE_HBL_TIMER
            out WS_INT_ENABLE_PORT, al

            # disable line timer interrupts
            in al, WS_TIMER_CTRL_PORT
            and al, ~(WS_TIMER_CTRL_HBL_ENABLE_BIT | WS_TIMER_CTRL_HBL_REPEAT)
            out WS_TIMER_CTRL_PORT, al

            # set ch2 volume/sample to 0
            xor al, al
            out WS_SOUND_VOL_CH2_PORT, al

            # clear sample playing flag
            mov bx, [sound_sample_state_ptr]
            and byte ptr [bx + MUSIC_STATE_FLAGS], ~CYG_STATE_FLAG_SAMPLE_PLAYING

            # acknowledge interrupt
            mov al, WS_INT_ACK_HBL_TIMER
            out WS_INT_ACK_PORT, al

            pop bx
            pop ax
            pop es
            pop ds

            #ifndef __WONDERFUL_WWITCH__
            iret
            #else
            retf
            #endif

        ssu_int_looping:

            # is looping

            # end sample, loop it by refreshing
            # the pointer and counter variables
            mov ax, [sound_sample_length]
            mov [sound_sample_counter], ax
            mov ax, [sound_sample_start]
            mov [sound_sample_ptr], ax

            # acknowledge interrupt
            mov al, WS_INT_ACK_HBL_TIMER
            out WS_INT_ACK_PORT, al

            pop bx
            pop ax
            pop es
            pop ds

            #ifndef __WONDERFUL_WWITCH__
            iret
            #else
            retf
            #endif

    ssu_int_not_end:

        # move along pointer
        inc bx
        mov [sound_sample_ptr], bx

        # acknowledge interrupt
        mov al, WS_INT_ACK_HBL_TIMER
        out WS_INT_ACK_PORT, al

        pop bx
        pop ax
        pop es
        pop ds

        #ifndef __WONDERFUL_WWITCH__
        iret
        #else
        retf
        #endif

# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
#
# ah - sample number
sound_sample_note_on:

    # set note-on
    or byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_NOTE_ON

    # running in colour mode?
    in al, WS_SYSTEM_CTRL_PORT
    test al, WS_SYSTEM_CTRL_MODEL_COLOR 
    jnz ssno_colour_mode
        
        # mono mode, using interrupts
        push bx
        push cx

        # sample number is in ah
        # look up sample 
        mov al, ah
        mov bl, SAMPLE_TABLE_SIZE
        mul bl
        mov bx, ax
        add bx, es:[SONG_HEADER_SAMPLE_TABLE_PTR]

        # get flags
        mov al, es:[bx + SAMPLE_TABLE_FLAGS]
        mov [sound_sample_flags], al

        # don't play sample if it's 24khz
        and al, WS_SDMA_CTRL_RATE_MASK
        cmp al, WS_SDMA_CTRL_RATE_24000
        jnz ssno_mono_sample_rate_ok

            # set ch2 volume/sample to 0
            xor al, al
            out WS_SOUND_VOL_CH2_PORT, al

            # disable voice mode
            in al, WS_SOUND_CH_CTRL_PORT
            and al, ~WS_SOUND_CH_CTRL_CH2_VOICE
            out WS_SOUND_CH_CTRL_PORT, al

            # disable line timer interrupts
            in al, WS_INT_ENABLE_PORT
            and al, ~WS_INT_ENABLE_HBL_TIMER
            out WS_INT_ENABLE_PORT, al

            # disable line timer interrupts
            in al, WS_TIMER_CTRL_PORT
            and al, ~(WS_TIMER_CTRL_HBL_ENABLE_BIT | WS_TIMER_CTRL_HBL_REPEAT)
            out WS_TIMER_CTRL_PORT, al

            # clear sample playing flag
            and byte ptr [di + MUSIC_STATE_FLAGS], ~CYG_STATE_FLAG_SAMPLE_PLAYING

            pop bx

            ret

        ssno_mono_sample_rate_ok:

        # get segment of sample
        mov ax, es:[bx + SAMPLE_TABLE_DATA_PTR + 2]
        mov [sound_sample_segment], ax

        # get address of start of sample within segment
        mov ax, es:[bx + SAMPLE_TABLE_DATA_PTR]
        mov [sound_sample_start], ax
        mov [sound_sample_ptr], ax

        # get sample length
        mov ax, es:[bx + SAMPLE_TABLE_LENGTH]
        mov [sound_sample_length], ax
        mov [sound_sample_counter], ax

        # store pointer to song state
        mov [sound_sample_state_ptr], di

        # set ch2 volume/first sample to 0
        xor al, al
        out WS_SOUND_VOL_CH2_PORT, al

        # enable ch2 voice mode
        in al, WS_SOUND_CH_CTRL_PORT
        or al, WS_SOUND_CH_CTRL_CH2_VOICE
        out WS_SOUND_CH_CTRL_PORT, al

        # set ch2 voice volume
        # get flags into cx
        mov cx, [si + CHANNEL_FLAGS]
        call sound_calc_sample_voice_volume
        out WS_SOUND_VOICE_VOL_PORT, al

        #ifndef __WONDERFUL_WWITCH__

            # set interrupt vector
            # get vector address for hblank timer repeat into bx
            # vector number in al
            in al, WS_INT_VECTOR_PORT
            and al, 0xf8
            add al, WS_INT_HBL_TIMER

            # bx = vector number * 4
            mov bl, al
            xor bh, bh
            add bx, bx
            add bx, bx

            # set interrupt vector address and segment
            mov word ptr ss:[bx], offset sound_sample_update_interrupt
            mov word ptr ss:[bx + 2], cs

        #else

            push dx

            # set hblank timer interrupt vector using freyabios

            # set up irq vector table
            mov ax, offset sound_sample_update_interrupt
            mov [sound_sample_irq_offset], ax
            mov ax, cs
            mov [sound_sample_irq_segment], ax
            mov ax, ds
            mov [sound_sample_irq_data_segment], ax

            # pointer to irq vector table in ds:bx            
            mov bx, offset sound_sample_irq_vector
            mov dx, bx

            # al is the interrupt number
            # ah is set interrupt mode
            mov al, WS_INT_HBL_TIMER
            mov ah, 0

            int 0x17

            pop dx

        #endif

        # turn sdma rates into hblank counter rates
        # invert rates and mask off upper bits
        # this will become the line counter value
        # 12khz = 1, 6khz = 2, 4khz = 3
        mov al, [sound_sample_flags]
        not al
        and al, 0x3
        xor ah, ah
        out WS_TIMER_HBL_RELOAD_PORT, ax

        # configure line timer interrupts
        in al, WS_TIMER_CTRL_PORT
        or al, WS_TIMER_CTRL_HBL_ENABLE_BIT | WS_TIMER_CTRL_HBL_REPEAT
        out WS_TIMER_CTRL_PORT, al

        # enable line timer interrupt
        in al, WS_INT_ENABLE_PORT
        or al, WS_INT_ENABLE_HBL_TIMER
        out WS_INT_ENABLE_PORT, al

        # set sample playing flag
        or byte ptr [di + MUSIC_STATE_FLAGS], CYG_STATE_FLAG_SAMPLE_PLAYING

        pop cx
        pop bx

        ret

    ssno_colour_mode:

        # colour mode, using sdma
        push bx
        push cx

        # sample number is in ah
        # look up sample 
        mov al, ah
        mov bl, SAMPLE_TABLE_SIZE
        mul bl
        mov bx, ax
        add bx, es:[SONG_HEADER_SAMPLE_TABLE_PTR]

        # calculate sample's linear address

        # get address
        mov ax, es:[bx + SAMPLE_TABLE_DATA_PTR]

        # get segment
        mov cx, es:[bx + SAMPLE_TABLE_DATA_PTR + 2]
        
        # shift segment left 4 and add to address
        shl cx, 4
        add ax, cx

        # output lower 2 bytes of address
        out WS_SDMA_SOURCE_L_PORT, ax

        # upper 4 bits of segment shifted right 4 + carry from previous addition
        mov al, 0
        adc al, 0
        mov ch, es:[bx + SAMPLE_TABLE_DATA_PTR + 3]
        shr ch, 4
        add al, ch

        # output upper byte of address
        out WS_SDMA_SOURCE_H_PORT, al

        # output SDMA length
        mov ax, es:[bx + SAMPLE_TABLE_LENGTH]
        out WS_SDMA_LENGTH_L_PORT, ax
        mov al, es:[bx + SAMPLE_TABLE_LENGTH + 2]
        out WS_SDMA_LENGTH_H_PORT, al

        # start SDMA
        mov al, es:[bx + SAMPLE_TABLE_FLAGS]
        out WS_SDMA_CTRL_PORT, al

        # set ch2 voice mode bit
        in al, WS_SOUND_CH_CTRL_PORT
        or al, WS_SOUND_CH_CTRL_CH2_VOICE
        out WS_SOUND_CH_CTRL_PORT, al

        # set ch2 voice volume
        # get flags into cx
        mov cx, [si + CHANNEL_FLAGS]
        call sound_calc_sample_voice_volume
        out WS_SOUND_VOICE_VOL_PORT, al

        # set sample playing flag
        or byte ptr [di + MUSIC_STATE_FLAGS], CYG_STATE_FLAG_SAMPLE_PLAYING

        pop cx
        pop bx

        ret

# bx - command pointer
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
sound_sample_note_off:

    # clear sample playing flag
    and byte ptr [di + MUSIC_STATE_FLAGS], ~CYG_STATE_FLAG_SAMPLE_PLAYING

    # clear note-on
    and byte ptr [si + CHANNEL_FLAGS], ~CHAN_FLAG_NOTE_ON

    # running in colour mode?
    in al, WS_SYSTEM_CTRL_PORT
    test al, WS_SYSTEM_CTRL_MODEL_COLOR
    jnz ssnoff_colour_mode

        # mono mode

        # disable line timer interrupts
        in al, WS_INT_ENABLE_PORT
        and al, ~WS_INT_ENABLE_HBL_TIMER
        out WS_INT_ENABLE_PORT, al

        # disable line timer interrupts
        in al, WS_TIMER_CTRL_PORT
        and al, ~(WS_TIMER_CTRL_HBL_ENABLE_BIT | WS_TIMER_CTRL_HBL_REPEAT)
        out WS_TIMER_CTRL_PORT, al

        # acknowledge interrupt
        mov al, WS_INT_ACK_HBL_TIMER
        out WS_INT_ACK_PORT, al


        # set ch2 volume/sample to 0
        xor al, al
        out WS_SOUND_VOL_CH2_PORT, al

        # disable voice mode
        in al, WS_SOUND_CH_CTRL_PORT
        and al, ~WS_SOUND_CH_CTRL_CH2_VOICE
        out WS_SOUND_CH_CTRL_PORT, al

        ret

    ssnoff_colour_mode:

        # colour mode

        # stop SDMA
        xor al, al
        out WS_SDMA_CTRL_PORT, al

        # set ch2 volume/sample to 0
        xor al, al
        out WS_SOUND_VOL_CH2_PORT, al

        # disable voice mode
        in al, WS_SOUND_CH_CTRL_PORT
        and al, ~WS_SOUND_CH_CTRL_CH2_VOICE
        out WS_SOUND_CH_CTRL_PORT, al

        ret