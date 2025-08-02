// SPDX-License-Identifier: CC0-1.0
//
// SPDX-FileContributor: Adrian "asie" Siekierka, 2023
#include <wonderful.h>
#include <ws.h>
#include <wsx/lzsa.h>

#include "graphics/text.h"

#include "cygnals.h"

music_state_t song_state __attribute__ ((aligned (2)));
channel_t song_channels[4] __attribute__ ((aligned (2)));

music_state_t sfx_state __attribute__ ((aligned (2)));
channel_t sfx_channels[1] __attribute__ ((aligned (2)));

extern const unsigned char __wf_rom cmajor_sn[];
extern const unsigned char __wf_rom sfx_test[];

__attribute__((section(".iramx_screen.1"))) uint16_t screen_1[32*32];
__attribute__((section(".iramx_screen.2"))) uint16_t screen_2[32*32];

volatile uint8_t vblank_fired;

__attribute__((interrupt)) void vblank(void) __wf_rom
{
	vblank_fired = 1;

	ws_int_ack(WS_INT_ACK_VBLANK);
}

void main(void) {

	unsigned char i;
	const unsigned char __wf_rom *ptr = cmajor_sn;

	uint16_t keypad, keypad_last, keypad_pushed;
	keypad_last = 0;

	i = 0;

	// attempt to set colour mode
	ws_system_set_mode(WS_MODE_COLOR_4BPP);

	//sound_set_wavetable_ram_address((unsigned char *)0xf00);

	// mono gfx, set black color
	outportw(WS_SCR_PAL_0_PORT, WS_DISPLAY_MONO_PALETTE(1, 7, 3, 0));
	outportb(WS_SCR_BASE_PORT, WS_SCR_BASE_ADDR1(screen_1) | WS_SCR_BASE_ADDR2(screen_2));

	wsx_lzsa2_decompress(WS_TILE_MEM(160), gfx_text_mono_tiles);

	// reset scroll registers to 0
	outportb(WS_SCR1_SCRL_X_PORT, 0);
	outportb(WS_SCR1_SCRL_Y_PORT, 0);
	outportb(WS_SCR2_SCRL_X_PORT, 0);
	outportb(WS_SCR2_SCRL_Y_PORT, 0);

	screen_1[0] = 0;

	// enable just screen_1
	outportw(WS_DISPLAY_CTRL_PORT, WS_DISPLAY_CTRL_SCR1_ENABLE);

	// initialize display LUT
	// colors 7,6,5,4 used by baize
	// colors 7,3,1,0 used by UI
	ws_display_set_shade_lut(WS_DISPLAY_SHADE_LUT(0, 2, 4, 6, 12, 13, 14, 15));

	sound_play(ptr, &song_state, song_channels);
	//sound_disable_looping();
	
	// acknowledge interrupt
	outportb(WS_INT_ACK_PORT, 0xFF);

	// set interrupt handler which only acknowledges the vblank interrupt
	ws_int_set_handler(WS_INT_VBLANK, vblank);

	// enable wonderswan vblank interrupt
	ws_int_enable(WS_INT_ENABLE_VBLANK);

	// enable cpu interrupts
	ia16_enable_irq();

	while(1)
	{
		while(!vblank_fired);

		vblank_fired = 0;

		sound_update(&song_state);

		// is there an sfx playing?
		if (sfx_state.flags & STATE_FLAG_PLAYING)
		{
			// update it
			sound_update(&sfx_state);

			// is the sfx no longer playing?
			if (!(sfx_state.flags & STATE_FLAG_PLAYING))
			{
				// unmute all muted channels
				sound_unmute_all(&song_state);
			}
		}

		i = i + 1;

		keypad = ws_keypad_scan();
		keypad_pushed = ((keypad ^ keypad_last) & keypad);
		keypad_last = keypad;

		if (keypad_pushed & WS_KEY_X1)
		{
			sound_set_master_volume(&song_state, song_state.master_volume + 4);
		}
		else if (keypad_pushed & WS_KEY_X3)
		{
			sound_set_master_volume(&song_state, song_state.master_volume - 4);
		}

		
		if (keypad_pushed & WS_KEY_A)
		{
			if (song_state.flags & 0x8)
			{
				sound_stop(&song_state);
			}
			else
			{
				sound_resume(&song_state);
			}
		}

		if (keypad_pushed & WS_KEY_B)
		{
			sound_play(sfx_test, &sfx_state, sfx_channels);
			sound_mute_channels(&song_state, sound_get_channels(&sfx_state));
		}


		if (keypad_pushed & WS_KEY_Y1)
		{
			if (song_channels[0].flags & 0x1)
			{
				sound_unmute_channel(&song_state, 0);
			}
			else
			{
				sound_mute_channel(&song_state, 0);
			}
		}			
		if (keypad_pushed & WS_KEY_Y2)
		{
			if (song_channels[1].flags & 0x1)
			{
				sound_unmute_channel(&song_state, 1);
			}
			else
			{
				sound_mute_channel(&song_state, 1);
			}
		}
		if (keypad_pushed & WS_KEY_Y3)
		{
			if (song_channels[2].flags & 0x1)
			{
				sound_unmute_channel(&song_state, 2);
			}
			else
			{
				sound_mute_channel(&song_state, 2);
			}
		}
		if (keypad_pushed & WS_KEY_Y4)
		{
			if (song_channels[3].flags & 0x1)
			{
				sound_unmute_channel(&song_state, 3);
			}
			else
			{
				sound_mute_channel(&song_state, 3);
			}
		}	
		
	}
}
