
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_update_channel_volume

.section .fartext.sound_driver, "ax"


# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
# cx - channel flags
sound_update_channel_volume:

	# sample playing?
	# sample channel?
	test byte ptr [di + MUSIC_STATE_FLAGS], CYG_STATE_FLAG_SAMPLE_PLAYING
	jz sucv_no_sample

		cmp byte ptr [si + CHANNEL_NUMBER], 1
		jnz sucv_no_sample

			# get new volume and update chip
			push cx
			call sound_calc_sample_voice_volume
			out WS_SOUND_VOICE_VOL_PORT, al
			pop cx

			ret

	sucv_no_sample:

	# wavetable voice

	# get volume
	mov al, [si + CHANNEL_VOLUME]

	# skip rest of function if the volume is set to 0
	or al, al
	jz sucv_chip_write

	# keep current volume in dl
	mov dl, al

	# master volume
	# when the msb is set, master volume is at max
	# so there's no attenuation
	mov al, [di + MUSIC_STATE_MASTER_VOLUME]
	test al, 0x80
	jnz master_volume_full

		# scale master volume
		shr al, 3

		# add it to the attentuation total
		inc al
		mul dl
		shr al, 4
		mov dl, al

	master_volume_full:

	# get master volume

	# volume macro level if present
	test ch, CHAN_FLAG2_VOLUME_MACRO
	jz sucv_no_volume_macro

		call sound_update_volume_macro

		# skip rest of function if the volume macro is set to 0
		or al, al
		jz sucv_chip_write

			# scale volume by macro level
			inc al
			mul dl
			shr al, 4
			mov dl, al

	sucv_no_volume_macro:

	mov al, dl
	mov ah, dl

	# get panning attenuations into dl and dh
	# one for each channel
	mov dl, [si + CHANNEL_PAN]
	mov dh, dl
	and dl, 0xf
	shr dh, 4

	# subtract attentuation from left channel
	sub al, dl
	jnc volume_left_no_carry

		# zero out volume if carry
		xor al, al

	volume_left_no_carry:

	# subtract attentuation from right channel
	sub ah, dh
	jnc volume_right_no_carry

		# zero out volume if carry
		xor ah, ah

	volume_right_no_carry:

	# combine volumes into one byte
	and al, 0x0f
	shl ah, 4
	or al, ah

	sucv_chip_write:

	# update chip register
	mov dl, [si + CHANNEL_NUMBER]
	add dl, WS_SOUND_VOL_CH1_PORT
	xor dh, dh
	out dx, al

	ret

/*
# ds - ram segment
# es - song segment
# di - song header pointer
# si - channel pointer
# cx - channel flags
sound_update_channel_volume:

	# add up all of the attenuations in dl and dh
	# need one byte for each channel

	# get panning attenuations into dl and dh
	# one for each channel
	mov dl, [si + CHANNEL_PAN]
	mov dh, dl
	and dl, 0xf
	shr dh, 4

	# volume macro level if present
	test ch, CHAN_FLAG2_VOLUME_MACRO
	jz sucv_no_volume_macro

		call sound_update_volume_macro

		add dl, al
		add dh, al

	sucv_no_volume_macro:

	# master volume
	# when the msb is set, master volume is at max
	# so there's no attenuation
	mov al, [di + MUSIC_STATE_MASTER_VOLUME]
	test al, 0x80
	jnz master_volume_full

		# turn master volume into an attentuation
		shr al, 3
		neg al
		add al, 15

		# add it to the attentuation total
		add dl, al
		add dh, al

	master_volume_full:

	# get volume
	mov al, [si + CHANNEL_VOLUME]
	mov ah, al

	# subtract attentuation from left channel
	sub al, dl
	jnc volume_left_no_carry

		# zero out volume if carry
		xor al, al

	volume_left_no_carry:

	# subtract attentuation from right channel
	sub ah, dh
	jnc volume_right_no_carry

		# zero out volume if carry
		xor ah, ah

	volume_right_no_carry:

	# combine volumes into one byte
	and al, 0x0f
	shl ah, 4
	or al, ah

	# update chip register
    mov dl, [si + CHANNEL_NUMBER]
    add dl, WS_SOUND_VOL_CH1_PORT
	xor dh, dh
	out dx, al

	ret
*/