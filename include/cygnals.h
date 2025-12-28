// Cygnals - Joe Kennedy 2025

#ifndef _SOUND_DEFINES_H
#define _SOUND_DEFINES_H

#define CYG_STATE_FLAG_PROCESS_NEW_LINE 0x1
#define CYG_STATE_FLAG_LOOP 0x2
#define CYG_STATE_FLAG_SFX 0x4
#define CYG_STATE_FLAG_PLAYING 0x8
#define CYG_STATE_FLAG_SAMPLE_PLAYING 0x10
#define CYG_STATE_FLAG_NOISE_ON 0x20


#ifndef __ASSEMBLER__

typedef struct {
	unsigned char ex_macro_ptr;
	unsigned char volume_macro_ptr;
	unsigned char wave_macro_ptr;
	unsigned char arp_macro_ptr;
	unsigned char macro_flags;
	unsigned char wave;
} instrument_t;

typedef struct {
	unsigned char len;
	unsigned char loop;
	unsigned char last;
	unsigned char pad;
	unsigned char * data_ptr;
} macro_t;

typedef struct {
	unsigned long data_ptr;
	unsigned long length;
	unsigned char flags;
	unsigned char pad;
} sample_table_t;

typedef struct {
	unsigned char flags;
	unsigned char flags2;
	unsigned char * pattern_ptr;
	unsigned short freq;
	unsigned short target_freq;
	unsigned char number;
	unsigned char pan;
	unsigned char volume;
	unsigned char instrument_num;
	unsigned char wavetable_num;
	unsigned char wait;
	unsigned char arp_vib_pos;
	unsigned char arp_vib;
	unsigned char ex_macro_pos;
	unsigned char ex_macro_ptr;
	unsigned char volume_macro_pos;
	unsigned char volume_macro_ptr;
	unsigned char wave_macro_pos;
	unsigned char wave_macro_ptr;
	unsigned char arp_macro_pos;
	unsigned char arp_macro_ptr;
} channel_t;

typedef struct {
	unsigned char magic_byte;
	unsigned char bank;
	unsigned char channels;
	unsigned char sfx_subchannel;
	unsigned char pattern_length;
	unsigned char orders_length;
	instrument_t * instrument_ptrs;
	unsigned short * order_ptrs;
	unsigned char * wavetables_ptr;
	unsigned char * sample_table_ptr;
	unsigned char * volume_macro_ptrs;
	unsigned char * wave_macro_ptrs;
	unsigned char * arp_macro_ptrs;
	unsigned char * ex_macro_ptrs;
} song_header_t;

typedef struct {
	unsigned char flags;
	unsigned char master_volume;
	unsigned char speed_1;
	unsigned char speed_2;
	unsigned char tic;
	unsigned char line;
	unsigned char order;
	unsigned char order_jump;
	unsigned char sound_ch_control;
	unsigned char noise_mode;
	unsigned short segment;
	channel_t * channels_ptr;
} music_state_t;

void cygnals_play(const unsigned char __far *song, music_state_t *song_state, channel_t *song_channels);
void cygnals_update(music_state_t *song_state);
void cygnals_stop(music_state_t *song_state);
void cygnals_resume(music_state_t *song_state);

unsigned char cygnals_get_channels(music_state_t *song_state);
void cygnals_mute_channel(music_state_t *song_state, unsigned char channel);
void cygnals_mute_channels(music_state_t *song_state, unsigned char channels);
void cygnals_unmute_channel(music_state_t *song_state, unsigned char channel);
void cygnals_unmute_all(music_state_t *song_state);

void cygnals_set_master_volume(music_state_t *song_state, unsigned char volume);

void cygnals_enable_looping(music_state_t *song_state);
void cygnals_disable_looping(music_state_t *song_state);

void cygnals_set_wavetable_ram_address(unsigned char *address);

#endif

#ifdef __ASSEMBLER__

	#define SLIDE_UP_MAX 0xd00

	#define CHAN_FLAG_MUTED 0x1
	#define CHAN_FLAG_NOTE_ON 0x2
	#define CHAN_FLAG_TIC_WAIT 0x4
	#define CHAN_FLAG_EMPTY 0x8
	#define CHAN_FLAG_VIBRATO 0x10
	#define CHAN_FLAG_ARPEGGIO 0x20
	#define CHAN_FLAG_SLIDE_UP 0x40
	#define CHAN_FLAG_SLIDE_DOWN 0x80
	#define CHAN_FLAG_SLIDE_PORTA 0xc0
	#define CHAN_FLAG_PITCH_EFFECT_MASK 0xf0

	#define CHAN_FLAG2_VOLUME_MACRO 0x1
	#define CHAN_FLAG2_WAVE_MACRO 0x2
	#define CHAN_FLAG2_ARP_MACRO 0x4
	#define CHAN_FLAG2_PITCH_MACRO 0x8
	#define CHAN_FLAG2_DUTY_MACRO 0x10
	#define CHAN_FLAG2_EMPTY 0x20
	#define CHAN_FLAG2_PITCH_CHANGED 0x40
	#define CHAN_FLAG2_VOLUME_CHANGE 0x80

	#define CYG_MAGIC_BYTE 0xba

	#ifdef __WONDERFUL_WWITCH__
		#define WAVETABLE_WRAM 0x180
	#else
		#define WAVETABLE_WRAM 0xec0
	#endif

	#define INSTRUMENT_EX_MACRO_PTR 0
	#define INSTRUMENT_VOLUME_MACRO_PTR 1
	#define INSTRUMENT_WAVE_MACRO_PTR 2
	#define INSTRUMENT_ARP_MACRO_PTR 3
	#define INSTRUMENT_MACRO_FLAGS 4
	#define INSTRUMENT_WAVE 5
	#define INSTRUMENT_SIZE 6

	#define MACRO_LEN 0
	#define MACRO_LOOP 1
	#define MACRO_LAST 2
	#define MACRO_PAD 3
	#define MACRO_DATA_PTR 4
	#define MACRO_SIZE 6

	#define SAMPLE_TABLE_DATA_PTR 0
	#define SAMPLE_TABLE_LENGTH 4
	#define SAMPLE_TABLE_FLAGS 8
	#define SAMPLE_TABLE_PAD 9
	#define SAMPLE_TABLE_SIZE 10

	#define CHANNEL_FLAGS 0
	#define CHANNEL_FLAGS2 1
	#define CHANNEL_PATTERN_PTR 2		// pointer to the current pattern
	#define CHANNEL_FREQ 4		// current fnum/tone of the voice
	#define CHANNEL_TARGET_FREQ 6		// target fnum/tone used for portamento
	#define CHANNEL_NUMBER 8		// channel number
	#define CHANNEL_PAN 9		// channel panning
	#define CHANNEL_VOLUME 10
	#define CHANNEL_INSTRUMENT_NUM 11
	#define CHANNEL_WAVETABLE_NUM 12
	#define CHANNEL_WAIT 13		// wait for this many lines/tics
	#define CHANNEL_ARP_VIB_POS 14
	#define CHANNEL_ARP_VIB 15
	#define CHANNEL_EX_MACRO_POS 16
	#define CHANNEL_EX_MACRO_PTR 17
	#define CHANNEL_VOLUME_MACRO_POS 18
	#define CHANNEL_VOLUME_MACRO_PTR 19
	#define CHANNEL_WAVE_MACRO_POS 20
	#define CHANNEL_WAVE_MACRO_PTR 21
	#define CHANNEL_ARP_MACRO_POS 22
	#define CHANNEL_ARP_MACRO_PTR 23
	#define CHANNEL_SIZE 24

	#define SONG_HEADER_MAGIC_BYTE 0		// should be 0xba for a valid song
	#define SONG_HEADER_BANK 1
	#define SONG_HEADER_CHANNELS 2		// upper nibble: channel count. lower nibble: channels in use where bit 0 = ch 0 ...
	#define SONG_HEADER_SFX_SUBCHANNEL 3
	#define SONG_HEADER_PATTERN_LENGTH 4
	#define SONG_HEADER_ORDERS_LENGTH 5
	#define SONG_HEADER_INSTRUMENT_PTRS 6
	#define SONG_HEADER_ORDER_PTRS 8
	#define SONG_HEADER_WAVETABLES_PTR 10
	#define SONG_HEADER_SAMPLE_TABLE_PTR 12
	#define SONG_HEADER_VOLUME_MACRO_PTRS 14
	#define SONG_HEADER_WAVE_MACRO_PTRS 16
	#define SONG_HEADER_ARP_MACRO_PTRS 18
	#define SONG_HEADER_EX_MACRO_PTRS 20
	#define SONG_HEADER_SIZE 22

	#define MUSIC_STATE_FLAGS 0
	#define MUSIC_STATE_MASTER_VOLUME 1
	#define MUSIC_STATE_SPEED_1 2
	#define MUSIC_STATE_SPEED_2 3
	#define MUSIC_STATE_TIC 4		// tic must be followed by line
	#define MUSIC_STATE_LINE 5
	#define MUSIC_STATE_ORDER 6
	#define MUSIC_STATE_ORDER_JUMP 7
	#define MUSIC_STATE_SOUND_CH_CONTROL 8
	#define MUSIC_STATE_NOISE_MODE 9
	#define MUSIC_STATE_SEGMENT 10
	#define MUSIC_STATE_CHANNELS_PTR 12
	#define MUSIC_STATE_SIZE 14

#endif

#endif
