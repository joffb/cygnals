
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_update_ex_macro

#ifdef __IA16_CMODEL_IS_FAR_TEXT
.section .fartext.sound_driver, "ax"
#else
.section .text.sound_driver, "ax"
#endif


sound_update_ex_macro:

	push bx

	# macro pos in dl, number in dh
	mov dx, [si + CHANNEL_EX_MACRO_POS]

	# get pointer to macro in bx
	mov al, dh
	mov bl, MACRO_SIZE
	mul bl
	add ax, es:[SONG_HEADER_EX_MACRO_PTRS]
	mov bx, ax

	# macro pos in ax
	mov al, dl
	xor ah, ah

	# MACRO_LEN in dl and MACRO_LOOP in dh
	mov dx, es:[bx + MACRO_LEN]

	# macro_pos == macro_len ?
	cmp al, dl
	jz suem_macro_end

		# get pointer to macro
		mov bx, es:[bx + MACRO_DATA_PTR]
		add bx, ax

		# get value
		mov al, es:[bx]

		# move on pos
		inc byte ptr [si + CHANNEL_EX_MACRO_POS]

		pop bx

		ret

	# end reached
	suem_macro_end:

		# 0xff means there's no loop
		cmp dh, 0xff
		jz suem_macro_no_loop

			# current pos = loop
			mov al, dh

			# get pointer to macro
			mov bx, es:[bx + MACRO_DATA_PTR]
			add bx, ax

			# get new value
			mov al, es:[bx]

			# move on pos
			inc dh
			mov [si + CHANNEL_EX_MACRO_POS], dh

			pop bx

			ret

		suem_macro_no_loop:

			# get last value
			mov al, es:[bx + MACRO_LAST]

			pop bx

			ret
