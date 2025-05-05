
#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_update_wave_macro
.global sound_wavetable_change

.section .text.sound_driver

# al: wavetable number
sound_wavetable_change:

    # don't change wavetable if channel is currently muted
    test byte ptr [si + CHANNEL_FLAGS], CHAN_FLAG_MUTED
    jnz swc_muted

    push bx
	push si

	mov [si + CHANNEL_WAVETABLE_NUM], al

    # get address of wave ram for this channel into bx
    mov bl, [si + CHANNEL_NUMBER]
    shl bl, 4
    xor bh, bh
    add bx, [sound_wavetable_ram_ptr]

    # get source address of wavetable 
    xor ah, ah
    shl ax, 4
    add ax, es:[SONG_HEADER_WAVETABLES_PTR] 
    mov si, ax

	# copy wave table
	mov ax, es:[si + 0]
	mov [bx + 0], ax
	mov ax, es:[si + 2]
	mov [bx + 2], ax
	mov ax, es:[si + 4]
	mov [bx + 4], ax
	mov ax, es:[si + 6]
	mov [bx + 6], ax
	mov ax, es:[si + 8]
	mov [bx + 8], ax
	mov ax, es:[si + 10]
	mov [bx + 10], ax
	mov ax, es:[si + 12]
	mov [bx + 12], ax
	mov ax, es:[si + 14]
	mov [bx + 14], ax

	pop si
	pop bx

	swc_muted:
    ret


sound_update_wave_macro:

	# macro pos in dl, number in dh
	mov dx, [si + CHANNEL_WAVE_MACRO_POS]

	# get pointer to macro in bx
	mov al, dh
	mov bl, MACRO_SIZE
	mul bl
	add ax, es:[SONG_HEADER_WAVE_MACRO_PTRS]
	mov bx, ax

	# macro pos in ax
	mov al, dl
	xor ah, ah

	# MACRO_LEN in dl and MACRO_LOOP in dh
	mov dx, es:[bx + MACRO_LEN]

	# macro_pos == macro_len ?
	cmp al, dl
	jz wm_macro_end
		
		# get pointer to macro
		mov bx, es:[bx + MACRO_DATA_PTR]
		add bx, ax

		# get value
		mov al, es:[bx]

		# move on pos
		inc byte ptr [si + CHANNEL_WAVE_MACRO_POS]

		jmp suwm_done
		
	# end reached
	wm_macro_end:

		# 0xff means there's no loop
		cmp dh, 0xff
		jz wm_macro_no_loop
		
			# current pos = loop
			mov al, dh

			# get pointer to macro
			mov bx, es:[bx + MACRO_DATA_PTR]
			add bx, ax
			
			# get new value
			mov al, es:[bx]

			# move on pos
			inc dh
			mov [si + CHANNEL_WAVE_MACRO_POS], dh

			jmp suwm_done
		
		wm_macro_no_loop:
		
			ret

	suwm_done:

	# only update the waveform if it's different
	cmp al, [si + CHANNEL_WAVETABLE_NUM]
	jz suwm_same_wave

		call sound_wavetable_change

	suwm_same_wave:

	ret
