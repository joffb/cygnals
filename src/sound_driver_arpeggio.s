
#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_update_arpeggio

.section .text.sound_driver

sound_update_arpeggio:

	# load CHANNEL_ARPEGGIO_POS into al and CHANNEL_ARPEGGIO into ah
	# increment arpeggio position and see if it's == 3
	mov ax, [si + CHANNEL_ARP_VIB_POS]
	inc al
	cmp al, 3
	jnz arp_update_not_3

		# reset back to 0
		xor al, al

	arp_update_not_3:

	# update value in channel
	mov [si + CHANNEL_ARP_VIB_POS], al

	# return different things in ax depending on arp_pos
	or al, al
	jnz arp_update_not_zero

		# arp_pos == 0, return 0
		xor ah, ah
		ret

	arp_update_not_zero:
	dec al
	jnz arp_update_not_one

		# arp_pos == 1
		# return upper nibble shifted so it's effectively * 32
		mov al, ah
		and al, 0xf0
		xor ah, ah
		shl ax, 1

		ret

	arp_update_not_one:

		# arp_pos == 2
		# return lower nibble shifted so it's effectively * 32
		and ah, 0xf
		xor al, al
		shr ax, 3

		ret
