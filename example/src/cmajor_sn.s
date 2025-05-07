#include <wonderful.h>
#include <ws.h>
.code16
.arch i186
.intel_syntax noprefix
.global cmajor_sn
.section .fartext.cmajor_sn, "a"
.balign 16
.org 0
cmajor_sn:
cmajor_sn_magic_byte:
.byte 186
cmajor_sn_bank:
.byte 0
cmajor_sn_sfx_channel:
.byte 0x4f
cmajor_sn_sfx_subchannel:
.byte 255
cmajor_sn_pattern_length:
.byte 32
cmajor_sn_orders_length:
.byte 6
cmajor_sn_instrument_ptrs:
.short cmajor_sn_instrument_data
cmajor_sn_order_ptrs:
.short cmajor_sn_orders
cmajor_sn_wavetables_ptr:
.short cmajor_sn_wavetables
cmajor_sn_sample_table_ptr:
.short cmajor_sn_sample_table
cmajor_sn_volume_macro_ptrs:
.short cmajor_sn_volume_macros
cmajor_sn_wave_macro_ptrs:
.short cmajor_sn_wave_macros
cmajor_sn_arp_macro_ptrs:
.short cmajor_sn_arp_macros
cmajor_sn_ex_macro_ptrs:
.short cmajor_sn_ex_macros
cmajor_sn_flags:
.byte 11
cmajor_sn_master_volume:
.byte 0x80
cmajor_sn_speed_1:
.byte 15
cmajor_sn_speed_2:
.byte 10
cmajor_sn_tic:
.byte 15
cmajor_sn_line:
.byte 32
cmajor_sn_order:
.byte 0
cmajor_sn_order_jump:
.byte 0xff
cmajor_sn_sound_control:
.byte 0x0f
cmajor_sn_noise_mode:
.byte 0x18


.balign 2
cmajor_sn_macros:
cmajor_sn_volume_macros:
cmajor_sn_macro_volume_0:
.byte 5 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_0_data #ptr 

cmajor_sn_macro_volume_1:
.byte 7 # len 
.byte 255 # loop 
.byte 5 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_1_data #ptr 

cmajor_sn_macro_volume_2:
.byte 10 # len 
.byte 6 # loop 
.byte 7 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_2_data #ptr 

cmajor_sn_macro_volume_3:
.byte 7 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_3_data #ptr 

cmajor_sn_macro_volume_4:
.byte 8 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_4_data #ptr 

cmajor_sn_macro_volume_5:
.byte 10 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_5_data #ptr 



cmajor_sn_wave_macros:
cmajor_sn_macro_wave_2:
.byte 7 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_2_data #ptr 


cmajor_sn_arp_macros:
cmajor_sn_macro_arp_0:
.byte 4 # len 
.byte 255 # loop 
.byte 129 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_0_data #ptr 
cmajor_sn_macro_arp_5:
.byte 6 # len 
.byte 255 # loop 
.byte 150 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_5_data #ptr 


cmajor_sn_ex_macros:
cmajor_sn_macro_ex_0:
.byte 4 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_ex_0_data #ptr 
cmajor_sn_macro_ex_3:
.byte 3 # len 
.byte 255 # loop 
.byte 2 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_ex_3_data #ptr 
cmajor_sn_macro_ex_5:
.byte 4 # len 
.byte 255 # loop 
.byte 4 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_ex_5_data #ptr 


cmajor_sn_volume_macros_data:
cmajor_sn_macro_volume_0_data:
.byte 13, 10, 6, 4, 0
cmajor_sn_macro_volume_1_data:
.byte 15, 15, 15, 14, 13, 12, 5
cmajor_sn_macro_volume_2_data:
.byte 1, 3, 6, 8, 10, 12, 8, 9, 8, 7
cmajor_sn_macro_volume_3_data:
.byte 13, 8, 5, 2, 2, 1, 0
cmajor_sn_macro_volume_4_data:
.byte 8, 8, 8, 7, 6, 5, 3, 0
cmajor_sn_macro_volume_5_data:
.byte 15, 15, 13, 9, 6, 5, 4, 3, 2, 0


cmajor_sn_wave_macros_data:
cmajor_sn_macro_wave_2_data:
.byte 2, 2, 2, 1, 1, 1, 0


cmajor_sn_arp_macros_data:
cmajor_sn_macro_arp_0_data:
.byte 161, 150, 139, 129
cmajor_sn_macro_arp_5_data:
.byte 194, 183, 183, 172, 161, 150


cmajor_sn_ex_macros_data:
cmajor_sn_macro_ex_0_data:
.byte 7, 6, 3, 0
cmajor_sn_macro_ex_3_data:
.byte 5, 4, 2
cmajor_sn_macro_ex_5_data:
.byte 1, 2, 3, 4


.balign 2
cmajor_sn_instrument_data:
cmajor_sn_instrument_0:
	.byte 0 # ex num
	.byte 0 # vol num
	.byte 255 # wave num
	.byte 0 # arp num
	.byte 0x15 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_1:
	.byte 255 # ex num
	.byte 1 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x1 # flags 
	.byte 0 # wave 
cmajor_sn_instrument_2:
	.byte 255 # ex num
	.byte 2 # vol num
	.byte 0 # wave num
	.byte 255 # arp num
	.byte 0x3 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_3:
	.byte 1 # ex num
	.byte 3 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x11 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_4:
	.byte 255 # ex num
	.byte 4 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x1 # flags 
	.byte 3 # wave 
cmajor_sn_instrument_5:
	.byte 2 # ex num
	.byte 5 # vol num
	.byte 255 # wave num
	.byte 1 # arp num
	.byte 0x15 # flags 
	.byte 255 # wave 


.balign 2
cmajor_sn_wavetables:
cmajor_sn_wavetable_0:
.byte 0xe8, 0xff, 0xdf, 0x99, 0xeb, 0xae, 0x35, 0x53, 0xa7, 0xcc, 0x5a, 0x11, 0x64, 0x26, 0x0, 0x10
cmajor_sn_wavetable_1:
.byte 0xb8, 0x11, 0x9c, 0x30, 0x61, 0xe, 0x95, 0x6, 0xf7, 0x69, 0xfa, 0x91, 0xce, 0x6f, 0xe3, 0x4e
cmajor_sn_wavetable_2:
.byte 0xb8, 0xd, 0x15, 0x61, 0x34, 0xd5, 0x92, 0xb3, 0x88, 0x68, 0xc, 0xd8, 0xab, 0xbe, 0xfa, 0x27
cmajor_sn_wavetable_3:
.byte 0x0, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff
cmajor_sn_wavetable_4:
.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff


.balign 2
cmajor_sn_order_pointers:
	.short cmajor_sn_orders_channel_0
	.short cmajor_sn_orders_channel_1
	.short cmajor_sn_orders_channel_2
	.short cmajor_sn_orders_channel_3


.balign 2
cmajor_sn_orders:
cmajor_sn_orders_channel_0:
	.short cmajor_sn_patterns_0_0, cmajor_sn_patterns_0_0, cmajor_sn_patterns_0_3, cmajor_sn_patterns_0_0
	.short cmajor_sn_patterns_0_1, cmajor_sn_patterns_0_2
cmajor_sn_orders_channel_1:
	.short cmajor_sn_patterns_1_0, cmajor_sn_patterns_1_0, cmajor_sn_patterns_1_0, cmajor_sn_patterns_1_0
	.short cmajor_sn_patterns_1_1, cmajor_sn_patterns_1_2
cmajor_sn_orders_channel_2:
	.short cmajor_sn_patterns_2_0, cmajor_sn_patterns_2_0, cmajor_sn_patterns_2_0, cmajor_sn_patterns_2_0
	.short cmajor_sn_patterns_2_1, cmajor_sn_patterns_2_2
cmajor_sn_orders_channel_3:
	.short cmajor_sn_patterns_3_0, cmajor_sn_patterns_3_0, cmajor_sn_patterns_3_0, cmajor_sn_patterns_3_0
	.short cmajor_sn_patterns_3_0, cmajor_sn_patterns_3_0


cmajor_sn_patterns:
cmajor_sn_patterns_0_0:
.byte 2, 2, 0, 26, (128 | 0), 8, 51, 0, 50, (128 | 2), 12, 85, 0, 48, (128 | 1), 13, 0, 47, (128 | 0), 0, 48, (128 | 0), 0, 45, (128 | 0), 0, 43, (128 | 0), 12, 85, 0, 41, (128 | 1), 0, 43, (128 | 2), 1, (128 | 0), 13, 0, 41, (128 | 0), 0, 43, (128 | 0), 0, 41, (128 | 0), 0, 38, (128 | 0), 0, 43, (128 | 1), 0, 41, (128 | 0), 12, 85, 0, 38, (128 | 4), 1, (128 | 3)
cmajor_sn_patterns_0_3:
.byte 2, 2, 13, 0, 50, (128 | 1), 0, 48, (128 | 0), 0, 50, (128 | 0), 0, 53, (128 | 1), 0, 57, (128 | 1), 0, 55, (128 | 0), 0, 52, (128 | 0), 12, 85, 0, 50, (128 | 3), 13, 0, 48, (128 | 0), 0, 50, (128 | 0), 0, 53, (128 | 0), 0, 55, (128 | 0), 0, 52, (128 | 0), 1, (128 | 0), 0, 50, (128 | 0), 1, (128 | 0), 0, 48, (128 | 0), 1, (128 | 0), 12, 85, 0, 50, (128 | 2), 0, 48, (128 | 0), 13, 0, 47, (128 | 0), 0, 45, (128 | 0), 0, 41, (128 | 0), 1, (128 | 0)
cmajor_sn_patterns_0_1:
.byte 2, 2, 12, 85, 0, 41, (128 | 3), 13, 0, 36, (128 | 0), 0, 38, (128 | 0), 0, 40, (128 | 0), 0, 41, (128 | 0), 12, 85, 0, 43, (128 | 3), 13, 0, 38, (128 | 0), 0, 40, (128 | 0), 0, 41, (128 | 0), 0, 43, (128 | 0), 0, 45, (128 | 0), 8, 34, 0, 57, (128 | 2), 0, 55, (128 | 1), 0, 48, (128 | 1), 12, 85, 0, 50, (128 | 2), 13, 0, 52, (128 | 0), 0, 47, (128 | 0), 0, 45, (128 | 0), 0, 43, (128 | 1)
cmajor_sn_patterns_0_2:
.byte 2, 2, 12, 85, 0, 48, (128 | 2), 13, 0, 48, (128 | 0), 0, 47, (128 | 0), 0, 48, (128 | 0), 0, 50, (128 | 0), 0, 52, (128 | 0), 12, 85, 0, 53, (128 | 2), 13, 0, 52, (128 | 0), 0, 50, (128 | 0), 1, (128 | 0), 0, 48, (128 | 0), 1, (128 | 0), 0, 43, (128 | 1), 8, 51, 0, 55, (128 | 1), 0, 52, (128 | 1), 0, 50, (128 | 1), 12, 85, 0, 49, (128 | 2), 1, (128 | 0), 12, 85, 0, 45, (128 | 2), 13, 1, (128 | 0)
cmajor_sn_patterns_1_0:
.byte 2, 4, 29, 1, 0, 26, (128 | 1), 0, 29, (128 | 1), 0, 33, (128 | 1), 0, 36, (128 | 1), 0, 31, (128 | 1), 0, 35, (128 | 1), 0, 38, (128 | 1), 0, 41, (128 | 1), 0, 26, (128 | 1), 0, 29, (128 | 1), 0, 31, (128 | 1), 0, 35, (128 | 1), 0, 26, (128 | 1), 0, 29, (128 | 1), 0, 31, (128 | 1), 0, 33, (128 | 1)
cmajor_sn_patterns_1_1:
.byte 2, 4, 0, 26, (128 | 1), 0, 29, (128 | 1), 0, 33, (128 | 1), 0, 36, (128 | 1), 0, 28, (128 | 1), 0, 31, (128 | 1), 0, 35, (128 | 1), 0, 38, (128 | 1), 0, 33, (128 | 1), 0, 36, (128 | 1), 0, 40, (128 | 1), 0, 43, (128 | 1), 0, 26, (128 | 1), 0, 29, (128 | 1), 0, 33, (128 | 1), 0, 35, (128 | 1)
cmajor_sn_patterns_1_2:
.byte 2, 4, 0, 24, (128 | 1), 0, 28, (128 | 1), 0, 31, (128 | 1), 0, 36, (128 | 1), 0, 29, (128 | 1), 0, 33, (128 | 1), 0, 36, (128 | 1), 0, 41, (128 | 1), 0, 28, (128 | 1), 0, 31, (128 | 1), 0, 35, (128 | 1), 0, 40, (128 | 1), 0, 33, (128 | 1), 0, 37, (128 | 1), 0, 40, (128 | 1), 0, 45, (128 | 1)
cmajor_sn_patterns_2_0:
.byte 2, 1, 29, 2, 0, 14, (128 | 0), 0, 17, (128 | 0), 0, 21, (128 | 0), 0, 24, (128 | 0), 0, 26, (128 | 1), 0, 24, (128 | 0), 0, 26, (128 | 0), 0, 23, (128 | 0), 0, 21, (128 | 0), 0, 19, (128 | 2), 0, 19, (128 | 0), 0, 23, (128 | 0), 0, 21, (128 | 0), 0, 19, (128 | 0), 0, 14, (128 | 0), 0, 16, (128 | 0), 0, 19, (128 | 0), 0, 23, (128 | 1), 0, 16, (128 | 0), 0, 19, (128 | 0), 0, 23, (128 | 0), 0, 24, (128 | 0), 0, 26, (128 | 2), 0, 29, (128 | 0), 0, 33, (128 | 1)
cmajor_sn_patterns_2_1:
.byte 2, 1, 0, 14, (128 | 0), 0, 17, (128 | 0), 0, 21, (128 | 0), 0, 24, (128 | 0), 0, 26, (128 | 3), 0, 16, (128 | 0), 0, 19, (128 | 0), 0, 23, (128 | 0), 0, 26, (128 | 0), 0, 28, (128 | 3), 0, 9, (128 | 0), 0, 12, (128 | 0), 0, 16, (128 | 0), 0, 19, (128 | 0), 0, 21, (128 | 3), 0, 11, (128 | 0), 0, 14, (128 | 0), 0, 17, (128 | 0), 0, 21, (128 | 0), 0, 23, (128 | 3)
cmajor_sn_patterns_2_2:
.byte 2, 1, 0, 12, (128 | 0), 0, 16, (128 | 0), 0, 19, (128 | 0), 0, 21, (128 | 0), 0, 24, (128 | 3), 0, 17, (128 | 0), 0, 21, (128 | 0), 0, 24, (128 | 0), 0, 28, (128 | 0), 0, 29, (128 | 3), 0, 16, (128 | 0), 0, 19, (128 | 0), 0, 23, (128 | 0), 0, 26, (128 | 0), 0, 28, (128 | 3), 0, 21, (128 | 0), 0, 25, (128 | 0), 0, 28, (128 | 0), 0, 31, (128 | 0), 0, 33, (128 | 3)
cmajor_sn_patterns_3_0:
.byte 2, 0, 0, 0, (128 | 1), 2, 3, 0, 62, (128 | 0), 0, 62, (128 | 0), 2, 5, 0, 48, (128 | 1), 2, 3, 0, 62, (128 | 0), 0, 62, (128 | 0), 2, 0, 0, 0, (128 | 1), 2, 3, 0, 62, (128 | 0), 0, 62, (128 | 0), 2, 5, 0, 48, (128 | 1), 2, 3, 0, 62, (128 | 0), 0, 62, (128 | 0), 2, 0, 0, 0, (128 | 1), 2, 3, 0, 62, (128 | 0), 0, 62, (128 | 0), 2, 5, 0, 48, (128 | 1), 2, 3, 0, 62, (128 | 0), 0, 62, (128 | 0), 2, 0, 0, 0, (128 | 1), 2, 3, 0, 62, (128 | 0), 0, 62, (128 | 0), 2, 5, 0, 48, (128 | 1), 0, 48, (128 | 0), 0, 48, (128 | 0)
.balign 2
cmajor_sn_sample_table:
cmajor_sn_sample_data:
