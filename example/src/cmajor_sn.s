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
.byte 64
cmajor_sn_orders_length:
.byte 36
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
.byte 4
cmajor_sn_speed_2:
.byte 3
cmajor_sn_tic:
.byte 4
cmajor_sn_line:
.byte 64
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
.byte 16 # len 
.byte 255 # loop 
.byte 6 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_0_data #ptr 

cmajor_sn_macro_volume_1:
.byte 3 # len 
.byte 255 # loop 
.byte 12 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_1_data #ptr 

cmajor_sn_macro_volume_2:
.byte 3 # len 
.byte 255 # loop 
.byte 12 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_2_data #ptr 

cmajor_sn_macro_volume_3:
.byte 3 # len 
.byte 255 # loop 
.byte 12 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_3_data #ptr 

cmajor_sn_macro_volume_4:
.byte 3 # len 
.byte 255 # loop 
.byte 12 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_4_data #ptr 

cmajor_sn_macro_volume_5:
.byte 3 # len 
.byte 255 # loop 
.byte 12 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_5_data #ptr 

cmajor_sn_macro_volume_6:
.byte 7 # len 
.byte 255 # loop 
.byte 3 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_6_data #ptr 

cmajor_sn_macro_volume_7:
.byte 1 # len 
.byte 255 # loop 
.byte 6 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_7_data #ptr 

cmajor_sn_macro_volume_9:
.byte 9 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_9_data #ptr 

cmajor_sn_macro_volume_10:
.byte 10 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_10_data #ptr 

cmajor_sn_macro_volume_11:
.byte 5 # len 
.byte 255 # loop 
.byte 9 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_11_data #ptr 

cmajor_sn_macro_volume_12:
.byte 5 # len 
.byte 255 # loop 
.byte 9 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_12_data #ptr 

cmajor_sn_macro_volume_13:
.byte 16 # len 
.byte 255 # loop 
.byte 6 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_13_data #ptr 

cmajor_sn_macro_volume_14:
.byte 3 # len 
.byte 255 # loop 
.byte 7 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_14_data #ptr 

cmajor_sn_macro_volume_16:
.byte 3 # len 
.byte 255 # loop 
.byte 13 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_16_data #ptr 

cmajor_sn_macro_volume_17:
.byte 3 # len 
.byte 255 # loop 
.byte 13 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_17_data #ptr 

cmajor_sn_macro_volume_18:
.byte 3 # len 
.byte 255 # loop 
.byte 13 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_18_data #ptr 

cmajor_sn_macro_volume_19:
.byte 3 # len 
.byte 255 # loop 
.byte 13 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_19_data #ptr 

cmajor_sn_macro_volume_20:
.byte 3 # len 
.byte 255 # loop 
.byte 13 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_20_data #ptr 

cmajor_sn_macro_volume_21:
.byte 3 # len 
.byte 255 # loop 
.byte 13 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_21_data #ptr 

cmajor_sn_macro_volume_22:
.byte 3 # len 
.byte 255 # loop 
.byte 13 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_22_data #ptr 

cmajor_sn_macro_volume_23:
.byte 20 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_23_data #ptr 

cmajor_sn_macro_volume_24:
.byte 3 # len 
.byte 255 # loop 
.byte 12 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_24_data #ptr 

cmajor_sn_macro_volume_25:
.byte 3 # len 
.byte 255 # loop 
.byte 12 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_25_data #ptr 

cmajor_sn_macro_volume_26:
.byte 3 # len 
.byte 255 # loop 
.byte 12 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_26_data #ptr 

cmajor_sn_macro_volume_27:
.byte 3 # len 
.byte 255 # loop 
.byte 12 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_volume_27_data #ptr 



cmajor_sn_wave_macros:
cmajor_sn_macro_wave_1:
.byte 32 # len 
.byte 0 # loop 
.byte 1 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_1_data #ptr 
cmajor_sn_macro_wave_2:
.byte 32 # len 
.byte 0 # loop 
.byte 1 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_2_data #ptr 
cmajor_sn_macro_wave_3:
.byte 32 # len 
.byte 0 # loop 
.byte 1 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_3_data #ptr 
cmajor_sn_macro_wave_4:
.byte 32 # len 
.byte 0 # loop 
.byte 1 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_4_data #ptr 
cmajor_sn_macro_wave_5:
.byte 32 # len 
.byte 0 # loop 
.byte 1 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_5_data #ptr 
cmajor_sn_macro_wave_6:
.byte 7 # len 
.byte 255 # loop 
.byte 13 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_6_data #ptr 
cmajor_sn_macro_wave_9:
.byte 2 # len 
.byte 255 # loop 
.byte 15 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_9_data #ptr 
cmajor_sn_macro_wave_10:
.byte 3 # len 
.byte 255 # loop 
.byte 18 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_10_data #ptr 
cmajor_sn_macro_wave_11:
.byte 2 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_11_data #ptr 
cmajor_sn_macro_wave_12:
.byte 2 # len 
.byte 255 # loop 
.byte 19 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_12_data #ptr 
cmajor_sn_macro_wave_14:
.byte 32 # len 
.byte 0 # loop 
.byte 8 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_14_data #ptr 
cmajor_sn_macro_wave_23:
.byte 5 # len 
.byte 255 # loop 
.byte 28 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_23_data #ptr 
cmajor_sn_macro_wave_24:
.byte 16 # len 
.byte 0 # loop 
.byte 8 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_24_data #ptr 
cmajor_sn_macro_wave_25:
.byte 16 # len 
.byte 0 # loop 
.byte 8 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_25_data #ptr 
cmajor_sn_macro_wave_26:
.byte 16 # len 
.byte 0 # loop 
.byte 8 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_26_data #ptr 
cmajor_sn_macro_wave_27:
.byte 16 # len 
.byte 0 # loop 
.byte 8 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_wave_27_data #ptr 


cmajor_sn_arp_macros:
cmajor_sn_macro_arp_2:
.byte 6 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_2_data #ptr 
cmajor_sn_macro_arp_3:
.byte 16 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_3_data #ptr 
cmajor_sn_macro_arp_4:
.byte 3 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_4_data #ptr 
cmajor_sn_macro_arp_5:
.byte 8 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_5_data #ptr 
cmajor_sn_macro_arp_6:
.byte 2 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_6_data #ptr 
cmajor_sn_macro_arp_9:
.byte 8 # len 
.byte 255 # loop 
.byte 117 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_9_data #ptr 
cmajor_sn_macro_arp_10:
.byte 8 # len 
.byte 255 # loop 
.byte 113 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_10_data #ptr 
cmajor_sn_macro_arp_11:
.byte 2 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_11_data #ptr 
cmajor_sn_macro_arp_12:
.byte 2 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_12_data #ptr 
cmajor_sn_macro_arp_23:
.byte 5 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_23_data #ptr 
cmajor_sn_macro_arp_25:
.byte 3 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_25_data #ptr 
cmajor_sn_macro_arp_26:
.byte 6 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_26_data #ptr 
cmajor_sn_macro_arp_27:
.byte 3 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_arp_27_data #ptr 


cmajor_sn_ex_macros:
cmajor_sn_macro_ex_15:
.byte 1 # len 
.byte 255 # loop 
.byte 1 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_ex_15_data #ptr 
cmajor_sn_macro_ex_16:
.byte 1 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_ex_16_data #ptr 
cmajor_sn_macro_ex_20:
.byte 1 # len 
.byte 255 # loop 
.byte 0 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_ex_20_data #ptr 
cmajor_sn_macro_ex_23:
.byte 6 # len 
.byte 255 # loop 
.byte 2 # last 
.byte 0xff # pad 
.word cmajor_sn_macro_ex_23_data #ptr 


cmajor_sn_volume_macros_data:
cmajor_sn_macro_volume_0_data:
.byte 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 8, 8, 7, 7, 6, 6
cmajor_sn_macro_volume_1_data:
.byte 14, 13, 12
cmajor_sn_macro_volume_2_data:
.byte 14, 13, 12
cmajor_sn_macro_volume_3_data:
.byte 14, 13, 12
cmajor_sn_macro_volume_4_data:
.byte 14, 13, 12
cmajor_sn_macro_volume_5_data:
.byte 14, 13, 12
cmajor_sn_macro_volume_6_data:
.byte 14, 13, 11, 8, 5, 4, 3
cmajor_sn_macro_volume_7_data:
.byte 6
cmajor_sn_macro_volume_9_data:
.byte 13, 15, 13, 11, 9, 8, 6, 3, 0
cmajor_sn_macro_volume_10_data:
.byte 15, 15, 15, 13, 10, 7, 5, 3, 2, 0
cmajor_sn_macro_volume_11_data:
.byte 15, 14, 12, 11, 9
cmajor_sn_macro_volume_12_data:
.byte 15, 14, 12, 11, 9
cmajor_sn_macro_volume_13_data:
.byte 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 8, 8, 7, 7, 6, 6
cmajor_sn_macro_volume_14_data:
.byte 14, 12, 7
cmajor_sn_macro_volume_16_data:
.byte 15, 14, 13
cmajor_sn_macro_volume_17_data:
.byte 15, 14, 13
cmajor_sn_macro_volume_18_data:
.byte 15, 14, 13
cmajor_sn_macro_volume_19_data:
.byte 15, 14, 13
cmajor_sn_macro_volume_20_data:
.byte 15, 14, 13
cmajor_sn_macro_volume_21_data:
.byte 15, 14, 13
cmajor_sn_macro_volume_22_data:
.byte 15, 14, 13
cmajor_sn_macro_volume_23_data:
.byte 15, 14, 15, 14, 13, 8, 9, 8, 7, 6, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0
cmajor_sn_macro_volume_24_data:
.byte 14, 13, 12
cmajor_sn_macro_volume_25_data:
.byte 14, 13, 12
cmajor_sn_macro_volume_26_data:
.byte 14, 13, 12
cmajor_sn_macro_volume_27_data:
.byte 14, 13, 12


cmajor_sn_wave_macros_data:
cmajor_sn_macro_wave_1_data:
.byte 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1
cmajor_sn_macro_wave_2_data:
.byte 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1
cmajor_sn_macro_wave_3_data:
.byte 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1
cmajor_sn_macro_wave_4_data:
.byte 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1
cmajor_sn_macro_wave_5_data:
.byte 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1
cmajor_sn_macro_wave_6_data:
.byte 11, 9, 10, 11, 12, 12, 13
cmajor_sn_macro_wave_9_data:
.byte 14, 15
cmajor_sn_macro_wave_10_data:
.byte 16, 17, 18
cmajor_sn_macro_wave_11_data:
.byte 16, 0
cmajor_sn_macro_wave_12_data:
.byte 16, 19
cmajor_sn_macro_wave_14_data:
.byte 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8
cmajor_sn_macro_wave_23_data:
.byte 27, 28, 27, 28, 28
cmajor_sn_macro_wave_24_data:
.byte 8, 7, 6, 5, 4, 3, 2, 1, 1, 2, 3, 4, 5, 6, 7, 8
cmajor_sn_macro_wave_25_data:
.byte 8, 7, 6, 5, 4, 3, 2, 1, 1, 2, 3, 4, 5, 6, 7, 8
cmajor_sn_macro_wave_26_data:
.byte 8, 7, 6, 5, 4, 3, 2, 1, 1, 2, 3, 4, 5, 6, 7, 8
cmajor_sn_macro_wave_27_data:
.byte 8, 7, 6, 5, 4, 3, 2, 1, 1, 2, 3, 4, 5, 6, 7, 8


cmajor_sn_arp_macros_data:
cmajor_sn_macro_arp_2_data:
.byte 126, 126, 126, 127, 127, 0
cmajor_sn_macro_arp_3_data:
.byte 126, 126, 126, 126, 126, 126, 126, 127, 127, 127, 127, 127, 127, 127, 127, 0
cmajor_sn_macro_arp_4_data:
.byte 126, 127, 0
cmajor_sn_macro_arp_5_data:
.byte 2, 2, 2, 2, 1, 1, 1, 0
cmajor_sn_macro_arp_6_data:
.byte 12, 0
cmajor_sn_macro_arp_9_data:
.byte 122, 0, 127, 125, 123, 121, 119, 117
cmajor_sn_macro_arp_10_data:
.byte 0, 0, 125, 122, 119, 116, 114, 113
cmajor_sn_macro_arp_11_data:
.byte 152, 0
cmajor_sn_macro_arp_12_data:
.byte 152, 0
cmajor_sn_macro_arp_23_data:
.byte 6, 7, 5, 3, 0
cmajor_sn_macro_arp_25_data:
.byte 127, 127, 0
cmajor_sn_macro_arp_26_data:
.byte 123, 124, 125, 126, 127, 0
cmajor_sn_macro_arp_27_data:
.byte 2, 1, 0


cmajor_sn_ex_macros_data:
cmajor_sn_macro_ex_15_data:
.byte 1
cmajor_sn_macro_ex_16_data:
.byte 0
cmajor_sn_macro_ex_20_data:
.byte 0
cmajor_sn_macro_ex_23_data:
.byte 4, 0, 0, 0, 0, 2


.balign 2
cmajor_sn_instrument_data:
cmajor_sn_instrument_0:
	.byte 255 # ex num
	.byte 0 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x1 # flags 
	.byte 0 # wave 
cmajor_sn_instrument_1:
	.byte 255 # ex num
	.byte 1 # vol num
	.byte 0 # wave num
	.byte 255 # arp num
	.byte 0x3 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_2:
	.byte 255 # ex num
	.byte 2 # vol num
	.byte 1 # wave num
	.byte 0 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_3:
	.byte 255 # ex num
	.byte 3 # vol num
	.byte 2 # wave num
	.byte 1 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_4:
	.byte 255 # ex num
	.byte 4 # vol num
	.byte 3 # wave num
	.byte 2 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_5:
	.byte 255 # ex num
	.byte 5 # vol num
	.byte 4 # wave num
	.byte 3 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_6:
	.byte 255 # ex num
	.byte 6 # vol num
	.byte 5 # wave num
	.byte 4 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_7:
	.byte 255 # ex num
	.byte 7 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x1 # flags 
	.byte 19 # wave 
cmajor_sn_instrument_8:
	.byte 255 # ex num
	.byte 255 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x0 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_9:
	.byte 255 # ex num
	.byte 8 # vol num
	.byte 6 # wave num
	.byte 5 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_10:
	.byte 255 # ex num
	.byte 9 # vol num
	.byte 7 # wave num
	.byte 6 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_11:
	.byte 255 # ex num
	.byte 10 # vol num
	.byte 8 # wave num
	.byte 7 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_12:
	.byte 255 # ex num
	.byte 11 # vol num
	.byte 9 # wave num
	.byte 8 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_13:
	.byte 255 # ex num
	.byte 12 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x1 # flags 
	.byte 19 # wave 
cmajor_sn_instrument_14:
	.byte 255 # ex num
	.byte 13 # vol num
	.byte 10 # wave num
	.byte 255 # arp num
	.byte 0x3 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_15:
	.byte 0 # ex num
	.byte 255 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x10 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_16:
	.byte 1 # ex num
	.byte 14 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x11 # flags 
	.byte 20 # wave 
cmajor_sn_instrument_17:
	.byte 255 # ex num
	.byte 15 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x1 # flags 
	.byte 21 # wave 
cmajor_sn_instrument_18:
	.byte 255 # ex num
	.byte 16 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x1 # flags 
	.byte 22 # wave 
cmajor_sn_instrument_19:
	.byte 255 # ex num
	.byte 17 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x1 # flags 
	.byte 23 # wave 
cmajor_sn_instrument_20:
	.byte 2 # ex num
	.byte 18 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x11 # flags 
	.byte 24 # wave 
cmajor_sn_instrument_21:
	.byte 255 # ex num
	.byte 19 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x1 # flags 
	.byte 25 # wave 
cmajor_sn_instrument_22:
	.byte 255 # ex num
	.byte 20 # vol num
	.byte 255 # wave num
	.byte 255 # arp num
	.byte 0x1 # flags 
	.byte 26 # wave 
cmajor_sn_instrument_23:
	.byte 3 # ex num
	.byte 21 # vol num
	.byte 11 # wave num
	.byte 9 # arp num
	.byte 0x17 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_24:
	.byte 255 # ex num
	.byte 22 # vol num
	.byte 12 # wave num
	.byte 255 # arp num
	.byte 0x3 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_25:
	.byte 255 # ex num
	.byte 23 # vol num
	.byte 13 # wave num
	.byte 10 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_26:
	.byte 255 # ex num
	.byte 24 # vol num
	.byte 14 # wave num
	.byte 11 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 
cmajor_sn_instrument_27:
	.byte 255 # ex num
	.byte 25 # vol num
	.byte 15 # wave num
	.byte 12 # arp num
	.byte 0x7 # flags 
	.byte 255 # wave 


.balign 2
cmajor_sn_wavetables:
cmajor_sn_wavetable_0:
.byte 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0x0, 0xff, 0xff, 0xff, 0x0, 0x0, 0x0, 0x0, 0x0
cmajor_sn_wavetable_1:
.byte 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
cmajor_sn_wavetable_2:
.byte 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
cmajor_sn_wavetable_3:
.byte 0x0, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
cmajor_sn_wavetable_4:
.byte 0x0, 0x0, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
cmajor_sn_wavetable_5:
.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
cmajor_sn_wavetable_6:
.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
cmajor_sn_wavetable_7:
.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
cmajor_sn_wavetable_8:
.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
cmajor_sn_wavetable_9:
.byte 0x55, 0x61, 0x5b, 0x7a, 0x46, 0x47, 0x78, 0xfb, 0x9e, 0x9b, 0x86, 0x73, 0x85, 0x86, 0x7b, 0x5
cmajor_sn_wavetable_10:
.byte 0x1, 0x94, 0x45, 0x85, 0x95, 0x87, 0xb7, 0xd9, 0xdf, 0xcc, 0xc9, 0x99, 0x96, 0x65, 0x86, 0x2
cmajor_sn_wavetable_11:
.byte 0x20, 0x35, 0x67, 0x77, 0xa7, 0x99, 0xbc, 0xfd, 0xcf, 0xac, 0xba, 0x99, 0x77, 0x76, 0x24, 0x4
cmajor_sn_wavetable_12:
.byte 0x30, 0x44, 0x54, 0x98, 0x99, 0xc9, 0xdc, 0xfe, 0xef, 0xcc, 0xbc, 0x79, 0x77, 0x36, 0x33, 0x3
cmajor_sn_wavetable_13:
.byte 0x10, 0x23, 0x64, 0x96, 0xaa, 0xdb, 0xed, 0xff, 0xff, 0xdc, 0xcb, 0x9a, 0x87, 0x45, 0x34, 0x2
cmajor_sn_wavetable_14:
.byte 0x46, 0x58, 0x79, 0xcb, 0xba, 0xd4, 0xab, 0xa7, 0x7d, 0xb6, 0xb8, 0xbb, 0x59, 0x74, 0x36, 0x34
cmajor_sn_wavetable_15:
.byte 0xec, 0xff, 0xee, 0xfe, 0xed, 0xff, 0xde, 0x9b, 0x46, 0x2, 0x20, 0x22, 0x11, 0x11, 0x10, 0x42
cmajor_sn_wavetable_16:
.byte 0xc0, 0x69, 0x2d, 0xc9, 0x34, 0xc4, 0x8a, 0x18, 0x2, 0xa9, 0xca, 0x0, 0x35, 0xf0, 0x0, 0xaa
cmajor_sn_wavetable_17:
.byte 0x32, 0x31, 0x14, 0x30, 0x40, 0x31, 0x21, 0x20, 0xdf, 0xdc, 0xbc, 0xbe, 0xcd, 0xed, 0xeb, 0xfd
cmajor_sn_wavetable_18:
.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
cmajor_sn_wavetable_19:
.byte 0xff, 0xff, 0xf, 0x0, 0x0, 0xff, 0xff, 0xff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
cmajor_sn_wavetable_20:
.byte 0xa7, 0xeb, 0xff, 0xff, 0xff, 0xef, 0xbd, 0x9a, 0x67, 0x45, 0x33, 0x22, 0x22, 0x22, 0x32, 0x54
cmajor_sn_wavetable_21:
.byte 0xc9, 0xff, 0xff, 0xff, 0xdf, 0xac, 0x89, 0x78, 0x67, 0x56, 0x34, 0x32, 0x23, 0x22, 0x33, 0x64
cmajor_sn_wavetable_22:
.byte 0xb7, 0xfe, 0xff, 0xff, 0xcd, 0x9a, 0x99, 0xaa, 0x99, 0x58, 0x34, 0x22, 0x32, 0x43, 0x34, 0x53
cmajor_sn_wavetable_23:
.byte 0xd8, 0xff, 0xef, 0xcd, 0xcc, 0xbc, 0xaa, 0xbb, 0x8a, 0x46, 0x34, 0x23, 0x33, 0x44, 0x23, 0x32
cmajor_sn_wavetable_24:
.byte 0xe7, 0xff, 0xef, 0xdd, 0xdd, 0xcc, 0x99, 0xcb, 0x8b, 0x45, 0x54, 0x13, 0x42, 0x35, 0x22, 0x21
cmajor_sn_wavetable_25:
.byte 0xfa, 0xef, 0xfe, 0xee, 0xde, 0xbc, 0xa8, 0xcd, 0x6a, 0x54, 0x45, 0x12, 0x43, 0x23, 0x22, 0x22
cmajor_sn_wavetable_26:
.byte 0xf7, 0xfc, 0xef, 0xef, 0xde, 0xcd, 0xa8, 0xbe, 0x8b, 0x55, 0x45, 0x3, 0x44, 0x32, 0x13, 0x2
cmajor_sn_wavetable_27:
.byte 0xce, 0xba, 0x9e, 0xda, 0xe9, 0xfa, 0x7d, 0x6e, 0x15, 0x6, 0x23, 0x54, 0x30, 0x42, 0x32, 0x16
cmajor_sn_wavetable_28:
.byte 0xca, 0xee, 0xfe, 0xfe, 0xff, 0xde, 0xff, 0x2d, 0x1, 0x1, 0x0, 0x0, 0x10, 0x11, 0x30, 0x42


.balign 2
cmajor_sn_order_pointers:
	.short cmajor_sn_orders_channel_0
	.short cmajor_sn_orders_channel_1
	.short cmajor_sn_orders_channel_2
	.short cmajor_sn_orders_channel_3


.balign 2
cmajor_sn_orders:
cmajor_sn_orders_channel_0:
	.short cmajor_sn_patterns_0_0, cmajor_sn_patterns_0_1, cmajor_sn_patterns_0_0, cmajor_sn_patterns_0_1
	.short cmajor_sn_patterns_0_0, cmajor_sn_patterns_0_1, cmajor_sn_patterns_0_2, cmajor_sn_patterns_0_3
	.short cmajor_sn_patterns_0_4, cmajor_sn_patterns_0_4, cmajor_sn_patterns_0_4, cmajor_sn_patterns_0_5
	.short cmajor_sn_patterns_0_4, cmajor_sn_patterns_0_4, cmajor_sn_patterns_0_4, cmajor_sn_patterns_0_5
	.short cmajor_sn_patterns_0_6, cmajor_sn_patterns_0_7, cmajor_sn_patterns_0_6, cmajor_sn_patterns_0_7
	.short cmajor_sn_patterns_0_6, cmajor_sn_patterns_0_7, cmajor_sn_patterns_0_6, cmajor_sn_patterns_0_8
	.short cmajor_sn_patterns_0_9, cmajor_sn_patterns_0_4, cmajor_sn_patterns_0_9, cmajor_sn_patterns_0_4
	.short cmajor_sn_patterns_0_9, cmajor_sn_patterns_0_4, cmajor_sn_patterns_0_9, cmajor_sn_patterns_0_4
	.short cmajor_sn_patterns_0_0, cmajor_sn_patterns_0_1, cmajor_sn_patterns_0_2, cmajor_sn_patterns_0_3
cmajor_sn_orders_channel_1:
	.short cmajor_sn_patterns_1_0, cmajor_sn_patterns_1_1, cmajor_sn_patterns_1_2, cmajor_sn_patterns_1_1
	.short cmajor_sn_patterns_1_0, cmajor_sn_patterns_1_1, cmajor_sn_patterns_1_3, cmajor_sn_patterns_1_4
	.short cmajor_sn_patterns_1_5, cmajor_sn_patterns_1_5, cmajor_sn_patterns_1_5, cmajor_sn_patterns_1_6
	.short cmajor_sn_patterns_1_5, cmajor_sn_patterns_1_5, cmajor_sn_patterns_1_5, cmajor_sn_patterns_1_7
	.short cmajor_sn_patterns_1_8, cmajor_sn_patterns_1_9, cmajor_sn_patterns_1_8, cmajor_sn_patterns_1_9
	.short cmajor_sn_patterns_1_8, cmajor_sn_patterns_1_9, cmajor_sn_patterns_1_8, cmajor_sn_patterns_1_9
	.short cmajor_sn_patterns_1_10, cmajor_sn_patterns_1_11, cmajor_sn_patterns_1_12, cmajor_sn_patterns_1_11
	.short cmajor_sn_patterns_1_10, cmajor_sn_patterns_1_11, cmajor_sn_patterns_1_12, cmajor_sn_patterns_1_11
	.short cmajor_sn_patterns_1_10, cmajor_sn_patterns_1_11, cmajor_sn_patterns_1_13, cmajor_sn_patterns_1_14
cmajor_sn_orders_channel_2:
	.short cmajor_sn_patterns_2_0, cmajor_sn_patterns_2_1, cmajor_sn_patterns_2_2, cmajor_sn_patterns_2_1
	.short cmajor_sn_patterns_2_0, cmajor_sn_patterns_2_1, cmajor_sn_patterns_2_2, cmajor_sn_patterns_2_3
	.short cmajor_sn_patterns_2_4, cmajor_sn_patterns_2_4, cmajor_sn_patterns_2_4, cmajor_sn_patterns_2_4
	.short cmajor_sn_patterns_2_4, cmajor_sn_patterns_2_4, cmajor_sn_patterns_2_4, cmajor_sn_patterns_2_4
	.short cmajor_sn_patterns_2_5, cmajor_sn_patterns_2_6, cmajor_sn_patterns_2_5, cmajor_sn_patterns_2_6
	.short cmajor_sn_patterns_2_5, cmajor_sn_patterns_2_6, cmajor_sn_patterns_2_5, cmajor_sn_patterns_2_6
	.short cmajor_sn_patterns_2_7, cmajor_sn_patterns_2_4, cmajor_sn_patterns_2_7, cmajor_sn_patterns_2_4
	.short cmajor_sn_patterns_2_7, cmajor_sn_patterns_2_4, cmajor_sn_patterns_2_7, cmajor_sn_patterns_2_4
	.short cmajor_sn_patterns_2_0, cmajor_sn_patterns_2_1, cmajor_sn_patterns_2_2, cmajor_sn_patterns_2_3
cmajor_sn_orders_channel_3:
	.short cmajor_sn_patterns_3_0, cmajor_sn_patterns_3_1, cmajor_sn_patterns_3_2, cmajor_sn_patterns_3_1
	.short cmajor_sn_patterns_3_0, cmajor_sn_patterns_3_1, cmajor_sn_patterns_3_2, cmajor_sn_patterns_3_3
	.short cmajor_sn_patterns_3_4, cmajor_sn_patterns_3_4, cmajor_sn_patterns_3_4, cmajor_sn_patterns_3_5
	.short cmajor_sn_patterns_3_6, cmajor_sn_patterns_3_7, cmajor_sn_patterns_3_7, cmajor_sn_patterns_3_7
	.short cmajor_sn_patterns_3_8, cmajor_sn_patterns_3_9, cmajor_sn_patterns_3_8, cmajor_sn_patterns_3_9
	.short cmajor_sn_patterns_3_8, cmajor_sn_patterns_3_9, cmajor_sn_patterns_3_8, cmajor_sn_patterns_3_9
	.short cmajor_sn_patterns_3_10, cmajor_sn_patterns_3_11, cmajor_sn_patterns_3_10, cmajor_sn_patterns_3_11
	.short cmajor_sn_patterns_3_10, cmajor_sn_patterns_3_11, cmajor_sn_patterns_3_10, cmajor_sn_patterns_3_11
	.short cmajor_sn_patterns_3_0, cmajor_sn_patterns_3_1, cmajor_sn_patterns_3_2, cmajor_sn_patterns_3_3


cmajor_sn_patterns:
cmajor_sn_patterns_0_0:
.byte 2, 0, 16, 2, 3, 15, 0, 12, (128 | 11), 0, 12, (128 | 3), 0, 12, (128 | 11), 0, 12, (128 | 3), 0, 14, (128 | 5), 0, 14, (128 | 5), 0, 14, (128 | 3), 0, 14, (128 | 15)
cmajor_sn_patterns_0_1:
.byte 2, 0, 0, 16, (128 | 11), 0, 16, (128 | 3), 0, 16, (128 | 11), 0, 16, (128 | 3), 0, 16, (128 | 5), 0, 16, (128 | 5), 0, 16, (128 | 3), 0, 16, (128 | 15)
cmajor_sn_patterns_0_2:
.byte 2, 0, 0, 9, (128 | 11), 0, 9, (128 | 3), 0, 9, (128 | 11), 0, 9, (128 | 3), 0, 14, (128 | 5), 0, 14, (128 | 5), 0, 14, (128 | 3), 0, 14, (128 | 15)
cmajor_sn_patterns_0_3:
.byte 2, 13, 0, 16, (128 | 15), 2, 7, 0, 16, (128 | 0), 1, (128 | 0), 0, 16, (128 | 0), 1, (128 | 0), 0, 16, (128 | 1), 1, (128 | 1), 0, 16, (128 | 0), 1, (128 | 0), 0, 16, (128 | 1), 1, (128 | 1), 0, 16, (128 | 0), 1, (128 | 0), 0, 16, (128 | 0), 1, (128 | 0), 0, 16, (128 | 0), 1, (128 | 0), 0, 16, (128 | 1), 1, (128 | 1), 0, 16, (128 | 0), 1, (128 | 0), 0, 16, (128 | 1), 1, (128 | 1), 0, 16, (128 | 0), 1, (128 | 0), 0, 16, (128 | 0), 1, (128 | 0), 0, 16, (128 | 0), 1, (128 | 0), 0, 16, (128 | 1), 1, (128 | 1), 0, 16, (128 | 0), 1, (128 | 0), 0, 16, (128 | 1), 1, (128 | 1), 0, 16, (128 | 0), 1, (128 | 0)
cmajor_sn_patterns_0_4:
.byte 2, 10, 3, 15, 0, 24, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1)
cmajor_sn_patterns_0_5:
.byte 2, 10, 3, 15, 0, 24, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 1, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 1, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 1, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 1, (128 | 1), 2, 11, 0, 19, (128 | 1), 0, 17, (128 | 1), 0, 19, (128 | 1)
cmajor_sn_patterns_0_6:
.byte 2, 10, 3, 15, 0, 24, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 12, 0, 16, (128 | 1), 2, 11, 0, 16, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 7, (128 | 1), 0, 19, (128 | 1), 0, 7, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 19, (128 | 1), 0, 7, (128 | 1), 0, 19, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 7, (128 | 1), 0, 19, (128 | 1), 0, 7, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 19, (128 | 1), 0, 7, (128 | 1), 0, 19, (128 | 1)
cmajor_sn_patterns_0_7:
.byte 2, 10, 3, 15, 0, 24, (128 | 1), 2, 11, 0, 9, (128 | 1), 0, 21, (128 | 1), 0, 9, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 21, (128 | 1), 0, 9, (128 | 1), 0, 21, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 9, (128 | 1), 0, 21, (128 | 1), 0, 9, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 21, (128 | 1), 0, 9, (128 | 1), 0, 21, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 12, (128 | 1), 0, 24, (128 | 1), 0, 12, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 24, (128 | 1), 0, 12, (128 | 1), 0, 24, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 11, (128 | 1), 0, 23, (128 | 1), 0, 11, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 23, (128 | 1), 0, 21, (128 | 1), 0, 23, (128 | 1)
cmajor_sn_patterns_0_8:
.byte 2, 10, 3, 15, 0, 24, (128 | 1), 2, 11, 0, 9, (128 | 1), 0, 21, (128 | 1), 0, 9, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 21, (128 | 1), 0, 9, (128 | 1), 0, 21, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 9, (128 | 1), 0, 21, (128 | 1), 0, 9, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 21, (128 | 1), 0, 9, (128 | 1), 0, 21, (128 | 1), 0, 12, (128 | 5), 0, 7, (128 | 5), 0, 11, (128 | 7), 2, 12, 0, 6, (128 | 11)
cmajor_sn_patterns_0_9:
.byte 2, 10, 3, 15, 0, 24, (128 | 1), 2, 12, 0, 12, (128 | 1), 2, 11, 0, 12, (128 | 1), 2, 12, 0, 12, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 12, (128 | 1), 2, 12, 0, 12, (128 | 1), 2, 11, 0, 12, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 12, 0, 12, (128 | 1), 2, 11, 0, 12, (128 | 1), 2, 12, 0, 12, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 12, (128 | 1), 2, 12, 0, 12, (128 | 1), 2, 11, 0, 12, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 12, 0, 14, (128 | 1), 2, 11, 0, 14, (128 | 1), 2, 12, 0, 14, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 14, (128 | 1), 2, 12, 0, 14, (128 | 1), 2, 11, 0, 14, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 12, 0, 14, (128 | 1), 2, 11, 0, 14, (128 | 1), 2, 12, 0, 14, (128 | 1), 2, 10, 0, 24, (128 | 1), 2, 11, 0, 14, (128 | 1), 0, 12, (128 | 1), 0, 14, (128 | 1)
cmajor_sn_patterns_1_0:
.byte 2, 1, 16, 0, 3, 15, 0, 40, (128 | 0), 12, 44, (128 | 14), 13, 0, 36, (128 | 0), 12, 44, (128 | 2), 13, 0, 40, (128 | 0), 12, 44, (128 | 2), 13, 0, 43, (128 | 0), 12, 44, (128 | 2), 2, 2, 13, 0, 45, (128 | 0), 12, 44, (128 | 10), 2, 1, 13, 0, 43, (128 | 0), 12, 44, (128 | 6), 13, 0, 42, (128 | 0), 12, 44, (128 | 6), 13, 0, 38, (128 | 0), 12, 44, (128 | 2), 2, 3, 13, 0, 40, (128 | 0), 12, 44, (128 | 2)
cmajor_sn_patterns_1_1:
.byte (128 | 47), 3, 12, (128 | 14), 13, (128 | 0)
cmajor_sn_patterns_1_2:
.byte 2, 4, 13, 3, 15, 0, 47, (128 | 0), 12, 44, (128 | 6), 2, 1, 13, 0, 45, (128 | 0), 12, 44, (128 | 6), 13, 0, 43, (128 | 0), 12, 44, (128 | 6), 13, 0, 45, (128 | 0), 12, 44, (128 | 2), 2, 5, 13, 0, 43, (128 | 0), 12, 44, (128 | 6), 2, 1, 13, 0, 43, (128 | 0), 12, 44, (128 | 2), 13, 0, 42, (128 | 0), 12, 44, (128 | 6), 13, 0, 40, (128 | 0), 12, 44, (128 | 6), 13, 0, 38, (128 | 0), 12, 44, (128 | 2), 2, 3, 13, 0, 40, (128 | 0), 12, 44, (128 | 2)
cmajor_sn_patterns_1_3:
.byte 3, 15, 1, (128 | 7), 2, 1, 13, 0, 36, (128 | 0), 12, 44, (128 | 6), 13, 0, 40, (128 | 0), 12, 44, (128 | 6), 13, 0, 43, (128 | 0), 12, 44, (128 | 6), 13, 0, 42, (128 | 0), 12, 44, (128 | 6), 13, 0, 38, (128 | 0), 12, 44, (128 | 6), 13, 0, 35, (128 | 0), 12, 44, (128 | 6), 13, 0, 42, (128 | 0), 12, 44, (128 | 6)
cmajor_sn_patterns_1_4:
.byte 2, 2, 13, 0, 42, (128 | 0), 12, 44, (128 | 30), 3, 12, (128 | 12), 13, (128 | 0), 2, 9, 16, 96, 3, 15, 0, 36, (128 | 0), 0, 36, (128 | 0), 16, 64, 0, 31, (128 | 3), 0, 31, (128 | 1), 16, 0, 0, 28, (128 | 3), 0, 28, (128 | 3), 16, 4, 0, 24, (128 | 1)
cmajor_sn_patterns_1_5:
.byte 2, 16, 16, 8, 3, 12, 0, 28, (128 | 0), 16, 15, 3, 5, 0, 28, (128 | 0), 2, 17, 16, 4, 3, 12, 0, 31, (128 | 0), 16, 8, 3, 5, 0, 31, (128 | 0), 2, 18, 16, 0, 3, 15, 0, 40, (128 | 0), 3, 6, 0, 40, (128 | 0), 2, 19, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 20, 3, 12, 0, 31, (128 | 0), 16, 240, 3, 5, 0, 31, (128 | 0), 2, 21, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 22, 16, 0, 3, 12, 0, 35, (128 | 0), 3, 5, 0, 35, (128 | 0), 16, 4, 3, 12, 0, 40, (128 | 0), 16, 0, 3, 5, 0, 40, (128 | 2), 16, 4, 3, 12, 0, 31, (128 | 0), 16, 8, 3, 5, 0, 31, (128 | 0), 2, 21, 16, 0, 3, 14, 0, 52, (128 | 0), 3, 6, 0, 52, (128 | 0), 2, 20, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 19, 3, 12, 0, 31, (128 | 0), 16, 240, 3, 5, 0, 31, (128 | 0), 2, 18, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 17, 16, 0, 3, 12, 0, 35, (128 | 0), 3, 5, 0, 35, (128 | 0), 2, 16, 16, 4, 3, 12, 0, 40, (128 | 0), 16, 0, 3, 5, 0, 40, (128 | 2), 2, 17, 16, 4, 3, 12, 0, 31, (128 | 0), 16, 8, 3, 5, 0, 31, (128 | 0), 2, 18, 16, 0, 3, 15, 0, 40, (128 | 0), 3, 6, 0, 40, (128 | 0), 2, 19, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 20, 3, 12, 0, 31, (128 | 0), 16, 240, 3, 5, 0, 31, (128 | 0), 2, 21, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 22, 16, 0, 3, 12, 0, 35, (128 | 0), 3, 5, 0, 35, (128 | 0), 16, 4, 3, 12, 0, 40, (128 | 0), 16, 0, 3, 5, 0, 40, (128 | 2), 16, 4, 3, 12, 0, 33, (128 | 0), 16, 8, 3, 5, 0, 33, (128 | 0), 2, 21, 16, 0, 3, 14, 0, 52, (128 | 0), 3, 6, 0, 52, (128 | 0), 2, 20, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 19, 3, 12, 0, 30, (128 | 0), 16, 240, 3, 5, 0, 30, (128 | 0), 2, 18, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 17, 16, 0, 3, 12, 0, 26, (128 | 0), 3, 5, 0, 26, (128 | 0), 2, 16, 16, 4, 3, 12, 0, 40, (128 | 0), 16, 0, 3, 5, 0, 40, (128 | 0)
cmajor_sn_patterns_1_6:
.byte 2, 16, 16, 8, 3, 12, 0, 28, (128 | 0), 16, 15, 3, 5, 0, 28, (128 | 0), 2, 17, 16, 4, 3, 12, 0, 31, (128 | 0), 16, 8, 3, 5, 0, 31, (128 | 0), 2, 18, 16, 0, 3, 15, 0, 40, (128 | 0), 3, 6, 0, 40, (128 | 0), 2, 19, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 20, 3, 12, 0, 31, (128 | 0), 16, 240, 3, 5, 0, 31, (128 | 0), 2, 21, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 22, 16, 0, 3, 12, 0, 35, (128 | 0), 3, 5, 0, 35, (128 | 0), 16, 4, 3, 12, 0, 40, (128 | 0), 16, 0, 3, 5, 0, 40, (128 | 2), 16, 4, 3, 12, 0, 31, (128 | 0), 16, 8, 3, 5, 0, 31, (128 | 0), 2, 21, 16, 0, 3, 14, 0, 52, (128 | 0), 3, 6, 0, 52, (128 | 0), 2, 20, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 19, 3, 12, 0, 31, (128 | 0), 16, 240, 3, 5, 0, 31, (128 | 0), 2, 18, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 17, 16, 0, 3, 12, 0, 35, (128 | 0), 3, 5, 0, 35, (128 | 0), 2, 16, 16, 4, 3, 12, 0, 40, (128 | 0), 16, 0, 3, 5, 0, 40, (128 | 2), 2, 17, 16, 4, 3, 12, 0, 31, (128 | 0), 16, 8, 3, 5, 0, 31, (128 | 0), 2, 18, 16, 0, 3, 15, 0, 40, (128 | 0), 3, 6, 0, 40, (128 | 0), 2, 19, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 20, 3, 12, 0, 31, (128 | 0), 16, 240, 3, 5, 0, 31, (128 | 0), 2, 21, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 22, 16, 0, 3, 12, 0, 35, (128 | 0), 3, 5, 0, 35, (128 | 0), 16, 4, 3, 12, 0, 40, (128 | 0), 16, 0, 3, 5, 0, 40, (128 | 2), 16, 4, 3, 12, 0, 33, (128 | 0), 16, 8, 3, 5, 0, 33, (128 | 0), 2, 21, 16, 0, 3, 14, 0, 52, (128 | 0), 3, 6, 0, 52, (128 | 0), 2, 20, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 19, 3, 12, 0, 30, (128 | 0), 16, 240, 3, 5, 0, 30, (128 | 0), 2, 20, 16, 0, 3, 12, 0, 43, (128 | 0), 16, 240, 3, 5, 0, 43, (128 | 0), 2, 21, 16, 0, 3, 12, 0, 41, (128 | 0), 16, 15, 3, 5, 0, 41, (128 | 0), 2, 22, 16, 0, 3, 12, 0, 43, (128 | 0), 16, 240, 3, 5, 0, 43, (128 | 0)
cmajor_sn_patterns_1_7:
.byte 2, 16, 16, 8, 3, 12, 0, 28, (128 | 0), 16, 15, 3, 5, 0, 28, (128 | 0), 2, 17, 16, 4, 3, 12, 0, 31, (128 | 0), 16, 8, 3, 5, 0, 31, (128 | 0), 2, 18, 16, 0, 3, 15, 0, 40, (128 | 0), 3, 6, 0, 40, (128 | 0), 2, 19, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 20, 3, 12, 0, 31, (128 | 0), 16, 240, 3, 5, 0, 31, (128 | 0), 2, 21, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 22, 16, 0, 3, 12, 0, 35, (128 | 0), 3, 5, 0, 35, (128 | 0), 16, 4, 3, 12, 0, 40, (128 | 0), 16, 0, 3, 5, 0, 40, (128 | 2), 16, 4, 3, 12, 0, 31, (128 | 0), 16, 8, 3, 5, 0, 31, (128 | 0), 2, 21, 16, 0, 3, 14, 0, 52, (128 | 0), 3, 6, 0, 52, (128 | 0), 2, 20, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 19, 3, 12, 0, 31, (128 | 0), 16, 240, 3, 5, 0, 31, (128 | 0), 2, 18, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 17, 16, 0, 3, 12, 0, 35, (128 | 0), 3, 5, 0, 35, (128 | 0), 2, 16, 16, 4, 3, 12, 0, 40, (128 | 0), 16, 0, 3, 5, 0, 40, (128 | 2), 2, 17, 16, 4, 3, 12, 0, 31, (128 | 0), 16, 8, 3, 5, 0, 31, (128 | 0), 2, 18, 16, 0, 3, 15, 0, 40, (128 | 0), 3, 6, 0, 40, (128 | 0), 2, 19, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 20, 3, 12, 0, 31, (128 | 0), 16, 240, 3, 5, 0, 31, (128 | 0), 2, 21, 16, 64, 3, 12, 0, 28, (128 | 0), 16, (128 | 0), 3, 5, 0, 28, (128 | 0), 2, 22, 16, 0, 3, 12, 0, 35, (128 | 0), 3, 5, 0, 35, (128 | 0), 2, 9, 16, 96, 3, 15, 0, 36, (128 | 0), 0, 36, (128 | 0), 16, 64, 0, 31, (128 | 3), 0, 31, (128 | 1), 16, 0, 0, 28, (128 | 3), 0, 28, (128 | 3), 16, 4, 0, 24, (128 | 1)
cmajor_sn_patterns_1_8:
.byte 2, 24, 11, 16, 0, 3, 15, 0, 55, (128 | 0), 3, 8, 0, 55, (128 | 0), 3, 15, 0, 55, (128 | 0), 3, 8, 0, 55, (128 | 0), 3, 15, 0, 55, (128 | 0), 3, 8, 0, 55, (128 | 0), 12, 44, (128 | 0), 13, 0, 55, (128 | 0), 3, 15, 0, 55, (128 | 0), 12, 44, (128 | 0), 13, 0, 55, (128 | 0), 3, 8, 0, 55, (128 | 0), 12, 44, (128 | 5), 2, 25, 13, 3, 15, 0, 59, (128 | 0), 12, 44, (128 | 1), 2, 24, 13, 3, 8, 0, 57, (128 | 0), 3, 15, 0, 57, (128 | 0), 12, 44, (128 | 0), 13, 0, 55, (128 | 0), 3, 8, 0, 57, (128 | 0), 3, 15, 0, 54, (128 | 0), 3, 8, 0, 55, (128 | 0), 3, 15, 0, 55, (128 | 0), 3, 8, 0, 54, (128 | 0), 3, 15, 0, 54, (128 | 0), 3, 8, 0, 55, (128 | 0), 2, 26, 3, 15, 0, 57, (128 | 0), 12, 44, (128 | 1), 13, 3, 8, 0, 57, (128 | 0), 12, 44, (128 | 1), 2, 24, 13, 3, 15, 0, 55, (128 | 0), 12, 44, (128 | 1), 13, 3, 8, 0, 55, (128 | 0), 12, 44, (128 | 1), 2, 26, 13, 3, 15, 0, 54, (128 | 0), 12, 44, (128 | 1), 13, 3, 8, 0, 54, (128 | 0), 12, 44, (128 | 3), 2, 24, 13, 3, 15, 0, 55, (128 | 0), 12, 44, (128 | 1), 13, 3, 8, 0, 55, (128 | 0), 12, 44, (128 | 7)
cmajor_sn_patterns_1_9:
.byte 2, 24, 11, 16, 0, 3, 15, 0, 55, (128 | 0), 3, 8, 0, 55, (128 | 0), 3, 15, 0, 55, (128 | 0), 3, 8, 0, 55, (128 | 0), 3, 15, 0, 55, (128 | 0), 3, 8, 0, 55, (128 | 0), 12, 44, (128 | 0), 13, 0, 55, (128 | 0), 3, 15, 0, 55, (128 | 0), 12, 44, (128 | 0), 13, 0, 55, (128 | 0), 3, 8, 0, 55, (128 | 0), 12, 44, (128 | 5), 2, 25, 13, 3, 15, 0, 59, (128 | 0), 12, 44, (128 | 1), 2, 24, 13, 3, 8, 0, 57, (128 | 0), 3, 15, 0, 57, (128 | 0), 12, 44, (128 | 0), 13, 0, 55, (128 | 0), 3, 8, 0, 57, (128 | 0), 3, 15, 0, 54, (128 | 0), 3, 8, 0, 55, (128 | 0), 3, 15, 0, 55, (128 | 0), 3, 8, 0, 54, (128 | 0), 3, 15, 0, 54, (128 | 0), 3, 8, 0, 55, (128 | 0), 2, 26, 3, 15, 0, 57, (128 | 0), 12, 44, (128 | 1), 13, 3, 8, 0, 57, (128 | 0), 12, 44, (128 | 1), 2, 24, 13, 3, 15, 0, 55, (128 | 0), 12, 44, (128 | 1), 13, 3, 8, 0, 55, (128 | 0), 12, 44, (128 | 1), 2, 26, 13, 3, 15, 0, 59, (128 | 0), 12, 44, (128 | 1), 13, 3, 8, 0, 59, (128 | 0), 12, 44, (128 | 3), 2, 24, 13, 3, 15, 0, 54, (128 | 0), 12, 44, (128 | 1), 13, 3, 8, 0, 54, (128 | 0), 12, 44, (128 | 7)
cmajor_sn_patterns_1_10:
.byte 2, 24, 13, 3, 15, 0, 40, (128 | 0), 12, 44, (128 | 14), 13, 0, 36, (128 | 0), 12, 44, (128 | 2), 13, 0, 40, (128 | 0), 12, 44, (128 | 2), 13, 0, 43, (128 | 0), 12, 44, (128 | 2), 2, 26, 13, 0, 45, (128 | 0), 12, 44, (128 | 10), 2, 24, 13, 0, 43, (128 | 0), 12, 44, (128 | 6), 13, 0, 42, (128 | 0), 12, 44, (128 | 6), 13, 0, 38, (128 | 0), 12, 44, (128 | 5), 2, 26, 13, 0, 40, (128 | 0)
cmajor_sn_patterns_1_11:
.byte 12, 44, (128 | 47), 3, 12, (128 | 15)
cmajor_sn_patterns_1_12:
.byte 2, 26, 13, 3, 15, 0, 47, (128 | 0), 12, 44, (128 | 6), 2, 24, 13, 0, 45, (128 | 0), 12, 44, (128 | 6), 13, 0, 43, (128 | 0), 12, 44, (128 | 6), 13, 0, 45, (128 | 0), 12, 44, (128 | 2), 2, 27, 13, 0, 43, (128 | 0), 12, 44, (128 | 6), 2, 24, 13, 0, 43, (128 | 0), 12, 44, (128 | 2), 13, 0, 42, (128 | 0), 12, 44, (128 | 6), 13, 0, 40, (128 | 0), 12, 44, (128 | 6), 13, 0, 38, (128 | 0), 12, 44, (128 | 5), 2, 26, 13, 0, 40, (128 | 0)
cmajor_sn_patterns_1_13:
.byte 3, 15, 1, (128 | 7), 2, 24, 13, 0, 36, (128 | 0), 12, 44, (128 | 6), 13, 0, 40, (128 | 0), 12, 44, (128 | 6), 13, 0, 43, (128 | 0), 12, 44, (128 | 6), 13, 0, 42, (128 | 0), 12, 44, (128 | 6), 13, 0, 38, (128 | 0), 12, 44, (128 | 6), 13, 0, 35, (128 | 0), 12, 44, (128 | 6), 13, 0, 42, (128 | 0), 12, 44, (128 | 6)
cmajor_sn_patterns_1_14:
.byte 2, 24, 13, 0, 42, (128 | 0), 12, 44, (128 | 28), 13, 0, 42, (128 | 0), 0, 41, (128 | 0), 0, 40, (128 | 0), 12, 44, (128 | 14), 3, 12, (128 | 14), 13, 25, 8, (128 | 0)
cmajor_sn_patterns_2_0:
.byte 2, 6, 16, 48, 11, 3, 15, 0, 36, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 36, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 38, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 38, (128 | 3), 0, 43, (128 | 3), 0, 50, (128 | 3), 0, 45, (128 | 3)
cmajor_sn_patterns_2_1:
.byte 2, 6, 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 47, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 47, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 50, (128 | 3), 0, 47, (128 | 3), 0, 43, (128 | 3), 0, 52, (128 | 3), 0, 40, (128 | 3)
cmajor_sn_patterns_2_2:
.byte 2, 6, 0, 45, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 45, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 38, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 38, (128 | 3), 0, 43, (128 | 3), 0, 50, (128 | 3), 0, 45, (128 | 3)
cmajor_sn_patterns_2_3:
.byte 2, 6, 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 47, (128 | 3), 1, (128 | 47)
cmajor_sn_patterns_2_4:
.byte 2, 14, 11, 16, 64, 3, 15, 0, 28, (128 | 1), 0, 31, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 40, (128 | 1), 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 28, (128 | 1), 0, 31, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 40, (128 | 1), 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 28, (128 | 1), 0, 31, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 40, (128 | 1), 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 28, (128 | 1), 0, 31, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 40, (128 | 1), 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1)
cmajor_sn_patterns_2_5:
.byte 2, 14, 11, 16, 64, 3, 15, 0, 28, (128 | 1), 0, 31, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 40, (128 | 1), 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 28, (128 | 1), 0, 31, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 40, (128 | 1), 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 28, (128 | 1), 10, 55, 0, 40, (128 | 1), 11, 0, 31, (128 | 1), 0, 35, (128 | 1), 10, 71, 0, 43, (128 | 1), 11, 0, 43, (128 | 1), 0, 31, (128 | 1), 10, 71, 0, 43, (128 | 1), 11, 0, 31, (128 | 1), 10, 71, 0, 43, (128 | 1), 11, 0, 31, (128 | 1), 0, 35, (128 | 1), 10, 71, 0, 43, (128 | 1), 11, 0, 43, (128 | 1), 0, 31, (128 | 1), 10, 71, 0, 43, (128 | 1), 11, 0, 31, (128 | 1), 10, 71, 0, 43, (128 | 1)
cmajor_sn_patterns_2_6:
.byte 2, 14, 11, 16, 64, 3, 15, 0, 33, (128 | 1), 0, 36, (128 | 1), 10, 55, 0, 45, (128 | 1), 11, 0, 45, (128 | 1), 0, 33, (128 | 1), 10, 55, 0, 45, (128 | 1), 11, 0, 33, (128 | 1), 10, 55, 0, 45, (128 | 1), 11, 0, 33, (128 | 1), 0, 36, (128 | 1), 10, 55, 0, 45, (128 | 1), 11, 0, 45, (128 | 1), 0, 33, (128 | 1), 10, 55, 0, 45, (128 | 1), 11, 0, 33, (128 | 1), 10, 55, 0, 45, (128 | 1), 11, 0, 36, (128 | 1), 0, 40, (128 | 1), 10, 71, 0, 48, (128 | 1), 11, 0, 48, (128 | 1), 0, 36, (128 | 1), 10, 71, 0, 48, (128 | 1), 11, 0, 36, (128 | 1), 10, 71, 0, 48, (128 | 1), 11, 0, 35, (128 | 1), 0, 38, (128 | 1), 10, 55, 0, 47, (128 | 1), 11, 0, 47, (128 | 1), 0, 35, (128 | 1), 10, 55, 0, 47, (128 | 1), 11, 0, 35, (128 | 1), 10, 55, 0, 47, (128 | 1)
cmajor_sn_patterns_2_7:
.byte 2, 14, 11, 3, 15, 0, 24, (128 | 1), 0, 28, (128 | 1), 10, 71, 0, 36, (128 | 1), 11, 0, 36, (128 | 1), 0, 24, (128 | 1), 10, 71, 0, 36, (128 | 1), 11, 0, 24, (128 | 1), 10, 71, 0, 36, (128 | 1), 11, 0, 24, (128 | 1), 0, 28, (128 | 1), 10, 71, 0, 36, (128 | 1), 11, 0, 36, (128 | 1), 0, 24, (128 | 1), 10, 71, 0, 36, (128 | 1), 11, 0, 24, (128 | 1), 10, 71, 0, 36, (128 | 1), 11, 0, 26, (128 | 1), 0, 30, (128 | 1), 10, 71, 0, 38, (128 | 1), 11, 0, 38, (128 | 1), 0, 26, (128 | 1), 10, 71, 0, 38, (128 | 1), 11, 0, 26, (128 | 1), 10, 71, 0, 38, (128 | 1), 11, 0, 26, (128 | 1), 0, 30, (128 | 1), 10, 71, 0, 38, (128 | 1), 11, 0, 38, (128 | 1), 0, 26, (128 | 1), 10, 71, 0, 38, (128 | 1), 11, 0, 26, (128 | 1), 10, 71, 0, 38, (128 | 1)
cmajor_sn_patterns_3_0:
.byte 1, (128 | 5), 2, 6, 16, 96, 3, 8, 0, 36, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 36, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 38, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 38, (128 | 3), 0, 43, (128 | 3), 0, 50, (128 | 1)
cmajor_sn_patterns_3_1:
.byte (128 | 1), 2, 6, 0, 45, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 47, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 47, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 50, (128 | 3), 0, 47, (128 | 3), 0, 43, (128 | 3), 0, 52, (128 | 1)
cmajor_sn_patterns_3_2:
.byte (128 | 1), 2, 6, 0, 40, (128 | 3), 0, 45, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 45, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 38, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 38, (128 | 3), 0, 43, (128 | 3), 0, 50, (128 | 1)
cmajor_sn_patterns_3_3:
.byte (128 | 1), 2, 6, 0, 45, (128 | 3), 0, 40, (128 | 3), 0, 43, (128 | 3), 0, 45, (128 | 3), 0, 47, (128 | 3), 1, (128 | 41)
cmajor_sn_patterns_3_4:
.byte (128 | 63)
cmajor_sn_patterns_3_5:
.byte (128 | 43), 2, 15, 6, 28, 16, 0, 3, 1, 0, 6, (128 | 3), 3, 2, (128 | 2), 3, 3, (128 | 2), 3, 4, (128 | 1), 3, 5, (128 | 1), 3, 6, (128 | 1), 3, 7, (128 | 1), 3, 8, (128 | 1)
cmajor_sn_patterns_3_6:
.byte 2, 15, 7, 16, 3, 9, 0, 60, (128 | 3), 3, 8, (128 | 3), 2, 23, 9, 3, 15, 0, 28, (128 | 3), 2, 15, 7, 16, 3, 6, 0, 31, (128 | 3), 3, 5, (128 | 3), 3, 4, (128 | 3), 2, 23, 9, 3, 15, 0, 28, (128 | 3), 2, 15, 7, 16, 3, 2, 0, 19, (128 | 3), 3, 1, (128 | 7), 2, 23, 9, 3, 15, 0, 28, (128 | 15), 0, 28, (128 | 7)
cmajor_sn_patterns_3_7:
.byte (128 | 7), 2, 23, 0, 28, (128 | 15), 0, 28, (128 | 15), 0, 28, (128 | 15), 0, 28, (128 | 7)
cmajor_sn_patterns_3_8:
.byte 2, 16, 16, 9, 9, 3, 15, 0, 52, (128 | 0), 2, 17, 3, 8, 0, 54, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 55, (128 | 0), 2, 17, 3, 8, 0, 52, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 59, (128 | 0), 2, 19, 3, 8, 0, 55, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 64, (128 | 0), 2, 21, 3, 8, 0, 59, (128 | 0), 2, 23, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 52, (128 | 0), 3, 8, 0, 52, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 55, (128 | 0), 2, 19, 3, 8, 0, 52, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 52, (128 | 0), 2, 17, 3, 8, 0, 54, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 55, (128 | 0), 2, 17, 3, 8, 0, 52, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 59, (128 | 0), 2, 19, 3, 8, 0, 55, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 64, (128 | 0), 2, 21, 3, 8, 0, 59, (128 | 0), 2, 23, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 52, (128 | 0), 3, 8, 0, 52, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 57, (128 | 0), 2, 19, 3, 8, 0, 52, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 55, (128 | 0), 2, 17, 3, 8, 0, 57, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 59, (128 | 0), 2, 17, 3, 8, 0, 55, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 64, (128 | 0), 2, 19, 3, 8, 0, 59, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 67, (128 | 0), 2, 21, 3, 8, 0, 64, (128 | 0), 2, 23, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 57, (128 | 0), 3, 8, 0, 57, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 50, (128 | 0), 2, 19, 3, 8, 0, 57, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 55, (128 | 0), 2, 17, 3, 8, 0, 50, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 59, (128 | 0), 2, 17, 3, 8, 0, 55, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 64, (128 | 0), 2, 19, 3, 8, 0, 59, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 67, (128 | 0), 2, 21, 3, 8, 0, 64, (128 | 0), 2, 23, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 57, (128 | 0), 3, 8, 0, 57, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 55, (128 | 0), 2, 19, 3, 8, 0, 57, (128 | 0)
cmajor_sn_patterns_3_9:
.byte 2, 16, 16, 9, 3, 15, 0, 57, (128 | 0), 2, 17, 3, 8, 0, 55, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 60, (128 | 0), 2, 17, 3, 8, 0, 57, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 64, (128 | 0), 2, 19, 3, 8, 0, 60, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 69, (128 | 0), 2, 21, 3, 8, 0, 64, (128 | 0), 2, 23, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 57, (128 | 0), 3, 8, 0, 57, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 60, (128 | 0), 2, 19, 3, 8, 0, 57, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 57, (128 | 0), 2, 17, 3, 8, 0, 60, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 60, (128 | 0), 2, 17, 3, 8, 0, 57, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 64, (128 | 0), 2, 19, 3, 8, 0, 60, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 69, (128 | 0), 2, 21, 3, 8, 0, 64, (128 | 0), 2, 23, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 57, (128 | 0), 3, 8, 0, 57, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 62, (128 | 0), 2, 19, 3, 8, 0, 57, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 60, (128 | 0), 2, 17, 3, 8, 0, 62, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 64, (128 | 0), 2, 17, 3, 8, 0, 60, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 69, (128 | 0), 2, 19, 3, 8, 0, 64, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 72, (128 | 0), 2, 21, 3, 8, 0, 69, (128 | 0), 2, 23, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 62, (128 | 0), 3, 8, 0, 62, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 55, (128 | 0), 2, 19, 3, 8, 0, 62, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 59, (128 | 0), 2, 17, 3, 8, 0, 55, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 64, (128 | 0), 2, 17, 3, 8, 0, 59, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 67, (128 | 0), 2, 19, 3, 8, 0, 64, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 71, (128 | 0), 2, 21, 3, 8, 0, 67, (128 | 0), 2, 23, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 55, (128 | 0), 3, 8, 0, 55, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 54, (128 | 0), 2, 19, 3, 8, 0, 55, (128 | 0)
cmajor_sn_patterns_3_10:
.byte 2, 16, 16, 9, 3, 15, 0, 48, (128 | 0), 2, 17, 3, 8, 0, 45, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 52, (128 | 0), 2, 17, 3, 8, 0, 48, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 57, (128 | 0), 2, 19, 3, 8, 0, 52, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 60, (128 | 0), 2, 21, 3, 8, 0, 57, (128 | 0), 2, 23, 16, 16, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 50, (128 | 0), 3, 8, 0, 50, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 43, (128 | 0), 2, 19, 3, 8, 0, 50, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 48, (128 | 0), 2, 17, 3, 8, 0, 50, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 52, (128 | 0), 2, 17, 3, 8, 0, 48, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 57, (128 | 0), 2, 19, 3, 8, 0, 52, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 60, (128 | 0), 2, 21, 3, 8, 0, 57, (128 | 0), 2, 23, 16, 16, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 50, (128 | 0), 3, 8, 0, 50, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 43, (128 | 0), 2, 19, 3, 8, 0, 50, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 50, (128 | 0), 2, 17, 3, 8, 0, 52, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 54, (128 | 0), 2, 17, 3, 8, 0, 50, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 59, (128 | 0), 2, 19, 3, 8, 0, 54, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 62, (128 | 0), 2, 21, 3, 8, 0, 59, (128 | 0), 2, 23, 16, 16, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 52, (128 | 0), 3, 8, 0, 52, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 45, (128 | 0), 2, 19, 3, 8, 0, 52, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 50, (128 | 0), 2, 17, 3, 8, 0, 52, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 54, (128 | 0), 2, 17, 3, 8, 0, 50, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 59, (128 | 0), 2, 19, 3, 8, 0, 54, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 62, (128 | 0), 2, 21, 3, 8, 0, 59, (128 | 0), 2, 23, 16, 16, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 52, (128 | 0), 3, 8, 0, 52, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 45, (128 | 0), 2, 19, 3, 8, 0, 52, (128 | 0)
cmajor_sn_patterns_3_11:
.byte 2, 16, 16, 9, 3, 15, 0, 52, (128 | 0), 2, 17, 3, 8, 0, 45, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 55, (128 | 0), 2, 17, 3, 8, 0, 52, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 59, (128 | 0), 2, 19, 3, 8, 0, 55, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 64, (128 | 0), 2, 21, 3, 8, 0, 59, (128 | 0), 2, 23, 16, 16, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 52, (128 | 0), 3, 8, 0, 52, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 55, (128 | 0), 2, 19, 3, 8, 0, 52, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 52, (128 | 0), 2, 17, 3, 8, 0, 54, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 55, (128 | 0), 2, 17, 3, 8, 0, 52, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 59, (128 | 0), 2, 19, 3, 8, 0, 55, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 64, (128 | 0), 2, 21, 3, 8, 0, 59, (128 | 0), 2, 23, 16, 16, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 52, (128 | 0), 3, 8, 0, 52, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 57, (128 | 0), 2, 19, 3, 8, 0, 52, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 52, (128 | 0), 2, 17, 3, 8, 0, 57, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 55, (128 | 0), 2, 17, 3, 8, 0, 52, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 59, (128 | 0), 2, 19, 3, 8, 0, 55, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 64, (128 | 0), 2, 21, 3, 8, 0, 59, (128 | 0), 2, 23, 16, 16, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 52, (128 | 0), 3, 8, 0, 52, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 55, (128 | 0), 2, 19, 3, 8, 0, 52, (128 | 0), 2, 16, 16, 9, 3, 15, 0, 52, (128 | 0), 2, 17, 3, 8, 0, 54, (128 | 0), 2, 18, 16, 96, 3, 15, 0, 55, (128 | 0), 2, 17, 3, 8, 0, 52, (128 | 0), 2, 20, 16, 3, 3, 15, 0, 59, (128 | 0), 2, 19, 3, 8, 0, 55, (128 | 0), 2, 22, 16, 0, 3, 15, 0, 64, (128 | 0), 2, 21, 3, 8, 0, 59, (128 | 0), 2, 23, 16, 16, 3, 15, 0, 28, (128 | 3), 2, 20, 16, 6, 0, 52, (128 | 0), 3, 8, 0, 52, (128 | 0), 2, 18, 16, 144, 3, 15, 0, 57, (128 | 0), 2, 19, 3, 8, 0, 52, (128 | 0)
.balign 2
cmajor_sn_sample_table:
cmajor_sn_sample_data:
