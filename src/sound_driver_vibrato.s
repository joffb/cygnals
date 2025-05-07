
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_update_vibrato

.section .text.sound_driver

sound_update_vibrato:

    push bx

	# update vibrato counter - has 64 steps from 0-63
	# load CHANNEL_VIBRATO_COUNTER into al and CHANNEL_VIBRATO into ah
	# CHANNEL_VIBRATO has depth in upper nibble and add amount in lower nibble
	# so keep it in dl too for later
	mov ax, [si + CHANNEL_ARP_VIB_POS]
	mov dl, ah
	and ah, 0xf
	add ah, al
	and ah, 0x3f	
	mov [si + CHANNEL_ARP_VIB_POS], ah

	# turning the 0-63 range of the counter
	# into a 0-15 range, depending on the quadrant
	
	# keep full value in ah to test against
	# restrict al to 0-15
	mov al, ah
	and al, 0xf

	# counter's 16 bit set? reverse the lookup index
	test ah, 0x10
	jz suv_no_reverse

		neg al
		add al, 15

	suv_no_reverse:

	# get vibrato table row using the depth
	# and combine with the index
	and dl, 0xf0
	or dl, al
	xor dh, dh

	# get address of vibrato value into bx
	# index it and get the value
	lea bx, [music_vibrato_table]
	add bx, dx
	mov al, cs:[bx]

	# counter >= 32? make value negative
	test ah, 0x20
	jz suv_no_invert

		neg al

	suv_no_invert:

    # sign extend al into ah
    cbw

    pop bx

	# return value in ax
	
	ret

# quarter of sine table
# 16 rows, one for each vibrato amplitude
# 16 values per row, other quadrants of sine are calculated
music_vibrato_table:
	.byte 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1
    .byte 0,0,0,1,1,1,2,2,2,3,3,3,3,3,3,3
    .byte 0,0,1,1,2,2,3,3,4,4,4,5,5,5,5,5
    .byte 0,0,1,2,3,3,4,5,5,6,6,7,7,7,7,7
    .byte 0,0,1,2,3,4,5,6,7,7,8,8,9,9,9,9
    .byte 0,1,2,3,4,5,6,7,8,9,9,10,11,11,11,11
    .byte 0,1,2,4,5,6,7,8,9,10,11,12,12,13,13,13
    .byte 0,1,3,4,6,7,8,10,11,12,13,14,14,15,15,15
    .byte 0,1,3,5,6,8,10,11,12,13,14,15,16,17,17,17
    .byte 0,1,3,5,7,9,11,12,14,15,16,17,18,19,19,19
    .byte 0,2,4,6,8,10,12,13,15,17,18,19,20,21,21,21
    .byte 0,2,4,6,9,11,13,15,16,18,19,21,22,22,23,23
    .byte 0,2,5,7,9,12,14,16,18,20,21,22,24,24,25,25
    .byte 0,2,5,8,10,13,15,17,19,21,23,24,25,26,27,27
    .byte 0,2,5,8,11,14,16,19,21,23,24,26,27,28,29,29
    .byte 0,3,6,9,12,15,17,20,22,24,26,28,29,30,31,31


# following code is not in use
# didn't seem much faster 
# despite using about 768 extra bytes

/*
.global sound_update_vibrato_full

sound_update_vibrato_full:

    push bx

	# update vibrato counter - has 64 steps from 0-63
	# CHANNEL_VIBRATO has depth in upper nibble and add amount in lower nibble
	# so keep it in dl too for later
	mov al, [si + CHANNEL_VIBRATO]
	mov dl, al
	and al, 0xf
	add al, [si + CHANNEL_VIBRATO_COUNTER]
	and al, 0x3f	
	mov [si + CHANNEL_VIBRATO_COUNTER], al

	# get vibrato table row using the depth << 2
	# and combine with the index
	and dl, 0xf0
	xor dh, dh
	shl dx, 2
	or dl, al

	# get address of vibrato value into bx
	# index it and get the value
	lea bx, [music_vibrato_table_full]
	add bx, dx
	mov al, cs:[bx]

    # sign extend al into ah
    cbw

    pop bx

	# return value in ax
	
	ret

*/

/*
define = ""
for (i = 0; i < 16; i++) { 
    out = []; 
    for (j = 0; j < 64; j++) { 
        out.push(Math.floor(Math.sin((Math.PI/32) * j) * (i + 1) * 2));
    }
    define += "\t.byte " + out.join(",") + "\n";
}
console.log(define);
*/

/*
music_vibrato_table_full:
	.byte 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,-1,-1,-1,-1,-1,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1
	.byte 0,0,0,1,1,1,2,2,2,3,3,3,3,3,3,3,4,3,3,3,3,3,3,3,2,2,2,1,1,1,0,0,0,-1,-1,-2,-2,-2,-3,-3,-3,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-3,-3,-3,-2,-2,-2,-1,-1
	.byte 0,0,1,1,2,2,3,3,4,4,4,5,5,5,5,5,6,5,5,5,5,5,4,4,4,3,3,2,2,1,1,0,0,-1,-2,-2,-3,-3,-4,-4,-5,-5,-5,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-5,-5,-5,-4,-4,-3,-3,-2,-2,-1
	.byte 0,0,1,2,3,3,4,5,5,6,6,7,7,7,7,7,8,7,7,7,7,7,6,6,5,5,4,3,3,2,1,0,0,-1,-2,-3,-4,-4,-5,-6,-6,-7,-7,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-7,-7,-6,-6,-5,-4,-4,-3,-2,-1
	.byte 0,0,1,2,3,4,5,6,7,7,8,8,9,9,9,9,10,9,9,9,9,8,8,7,7,6,5,4,3,2,1,0,0,-1,-2,-3,-4,-5,-6,-7,-8,-8,-9,-9,-10,-10,-10,-10,-10,-10,-10,-10,-10,-9,-9,-8,-8,-7,-6,-5,-4,-3,-2,-1
	.byte 0,1,2,3,4,5,6,7,8,9,9,10,11,11,11,11,12,11,11,11,11,10,9,9,8,7,6,5,4,3,2,1,0,-2,-3,-4,-5,-6,-7,-8,-9,-10,-10,-11,-12,-12,-12,-12,-12,-12,-12,-12,-12,-11,-10,-10,-9,-8,-7,-6,-5,-4,-3,-2
	.byte 0,1,2,4,5,6,7,8,9,10,11,12,12,13,13,13,14,13,13,13,12,12,11,10,9,8,7,6,5,4,2,1,0,-2,-3,-5,-6,-7,-8,-9,-10,-11,-12,-13,-13,-14,-14,-14,-14,-14,-14,-14,-13,-13,-12,-11,-10,-9,-8,-7,-6,-5,-3,-2
	.byte 0,1,3,4,6,7,8,10,11,12,13,14,14,15,15,15,16,15,15,15,14,14,13,12,11,10,8,7,6,4,3,1,0,-2,-4,-5,-7,-8,-9,-11,-12,-13,-14,-15,-15,-16,-16,-16,-16,-16,-16,-16,-15,-15,-14,-13,-12,-11,-9,-8,-7,-5,-4,-2
	.byte 0,1,3,5,6,8,10,11,12,13,14,15,16,17,17,17,18,17,17,17,16,15,14,13,12,11,10,8,6,5,3,1,0,-2,-4,-6,-7,-9,-11,-12,-13,-14,-15,-16,-17,-18,-18,-18,-18,-18,-18,-18,-17,-16,-15,-14,-13,-12,-11,-9,-7,-6,-4,-2
	.byte 0,1,3,5,7,9,11,12,14,15,16,17,18,19,19,19,20,19,19,19,18,17,16,15,14,12,11,9,7,5,3,1,0,-2,-4,-6,-8,-10,-12,-13,-15,-16,-17,-18,-19,-20,-20,-20,-20,-20,-20,-20,-19,-18,-17,-16,-15,-13,-12,-10,-8,-6,-4,-2
	.byte 0,2,4,6,8,10,12,13,15,17,18,19,20,21,21,21,22,21,21,21,20,19,18,17,15,13,12,10,8,6,4,2,0,-3,-5,-7,-9,-11,-13,-14,-16,-18,-19,-20,-21,-22,-22,-22,-22,-22,-22,-22,-21,-20,-19,-18,-16,-14,-13,-11,-9,-7,-5,-3
	.byte 0,2,4,6,9,11,13,15,16,18,19,21,22,22,23,23,24,23,23,22,22,21,19,18,16,15,13,11,9,6,4,2,0,-3,-5,-7,-10,-12,-14,-16,-17,-19,-20,-22,-23,-23,-24,-24,-24,-24,-24,-23,-23,-22,-20,-19,-17,-16,-14,-12,-10,-7,-5,-3
	.byte 0,2,5,7,9,12,14,16,18,20,21,22,24,24,25,25,26,25,25,24,24,22,21,20,18,16,14,12,9,7,5,2,0,-3,-6,-8,-10,-13,-15,-17,-19,-21,-22,-23,-25,-25,-26,-26,-26,-26,-26,-25,-25,-23,-22,-21,-19,-17,-15,-13,-10,-8,-6,-3
	.byte 0,2,5,8,10,13,15,17,19,21,23,24,25,26,27,27,28,27,27,26,25,24,23,21,19,17,15,13,10,8,5,2,0,-3,-6,-9,-11,-14,-16,-18,-20,-22,-24,-25,-26,-27,-28,-28,-28,-28,-28,-27,-26,-25,-24,-22,-20,-18,-16,-14,-11,-9,-6,-3
	.byte 0,2,5,8,11,14,16,19,21,23,24,26,27,28,29,29,30,29,29,28,27,26,24,23,21,19,16,14,11,8,5,2,0,-3,-6,-9,-12,-15,-17,-20,-22,-24,-25,-27,-28,-29,-30,-30,-30,-30,-30,-29,-28,-27,-25,-24,-22,-20,-17,-15,-12,-9,-6,-3
	.byte 0,3,6,9,12,15,17,20,22,24,26,28,29,30,31,31,32,31,31,30,29,28,26,24,22,20,17,15,12,9,6,3,0,-4,-7,-10,-13,-16,-18,-21,-23,-25,-27,-29,-30,-31,-32,-32,-32,-32,-32,-31,-30,-29,-27,-25,-23,-21,-18,-16,-13,-10,-7,-4
*/