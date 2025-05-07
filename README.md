
# Cygnals Sound driver for the Bandai Wonderswan

+ Written in 186 assembly
+ Intended for use with Wonderful Toolchain homebrew projects
+ Converts Furnace .fur files

A subset of Furnace's features are supported:

## Tempo

The "Speeds" tempo mode (with separate Speed 1 and Speed 2 parameters) is supported

## Effects

+ 00 - Arpeggio (*)
+ 01 - Slide up (*)
+ 02 - Slide down (*)
+ 03 - Portamento (*)
+ 04 - Vibrato (*)
+ 08 - Set Panning
+ 09 - Set Speed 1
+ 0B - Jump to Pattern
+ 0D - Jump to Next Pattern (parameter ignored)
+ 0F - Set Speed 2
+ 10 - Set Waveform
+ 11 - Set Noise Mode
+ 20 - Set Speaker Loudness
+ 80 - Set Panning
+ 81 - Set Panning (left channel)
+ 82 - Set Panning (right channel)
+ EC - Note Cut
+ ED - Note Delay

(*) Arpeggio, Slides, Portamento and Vibrato share memory and only one of them can be used at one time on a given channel

## Macros
Volume, Arpeggio, Wave, Pitch and Noise Macros can be used in Sequence mode - ADSR and LFO modes are not supported.

Volume, Arpeggio and Wave Macros can all be used simultaneously.
Pitch and Noise macros share memory and only one can be used at a time.

Wave macros which are only 1 entry long will not be run as macros and will instead update the wavetable once when the instrument changes.

## Using the driver

Your makefile should be updated to add `-lcygnals` to the list of libraries on the line starting with `LIBS := `

The `build/wswan/medium/libcygnals.a` file should be placed in `/opt/wonderful/target/wswan/medium/lib/` and the `cygnals.h` should be in your project include directory.

### Converting

You can convert a furnace song into an assembly language file as below:

```
python3 json2ws.py -o src/mysong.s -i mysong ./song.fur
```

In this example, `-o` sets the output filename, `-i` sets the name of the variable which can be used to refer to the song, and the input furnace filename comes last.

You can convert a sound effect as below:

```
python3 ../json2ws.py --sfx 2 -o src/mysfx.s -i mysfx ./mysfx.fur 
```

The main difference here is `--sfx 2` which tells the converter to only look at channel 2 (indexed starting at 1). You can specify multiple channels like `--sfx 124` will export channels 1, 3 and 4.

### Variables

Use extern variable definitions as below to refer to the song data.

```
extern const unsigned char __far mysong[];
```

For playback you will need to make variables for the song's state (which contains the current line, pattern, and other information) and for the four channels:

```
music_state_t song_state __attribute__ ((aligned (2)));
channel_t song_channels[4] __attribute__ ((aligned (2)));
```

Note that `__attribute__ ((aligned (2)))` is used so that the variables are allocated on a word (2 byte) boundary which results in faster execution in places.

You can then play back a song using the state, the channels and a far pointer to the song data like this: `sound_play(song_ptr, &song_state, song_channels);`

Most functions require the song's state to be passed in, but the channels pointer only needs to be passed in that once.

Every frame, you should run `sound_update(&song_state);` which will move the song's state along, update all of the channels and write updates to the Wonderswan's sound chip.

By default songs will loop, but this can be changed with the `sound_enable_looping(music_state_t *song_state);` and `sound_disable_looping(music_state_t *song_state);` functions.

A song can be stopped with `sound_stop(&song_state);` which will mute the sound channels and further executions of `sound_update(&song_state);` will do nothing.

A stopped song can be resumed from where it was with `sound_resume(&song_state);`.

### Sound effects (sfx)
Sound effects (i.e. for scoring, jumping or weapon shots) can be played back in the same way as songs. You need to make variables for the sfx's state and for the maximum number of channels you will be using for effects. The number of channels should be stuck to, as an sfx playing back on more channels than there is RAM allocated could cause some big issues! This allocates space for the sfx's state and one channel:

```
music_state_t sfx_state __attribute__ ((aligned (2)));
channel_t sfx_channels[1] __attribute__ ((aligned (2)));
```

You can then play back the sfx like this: `sound_play(sfx_test, &sfx_state, sfx_channels);`

By default sfx do not loop but this can be changed as above.

When music is already playing, you will need to mute the channels which the sfx uses
+ If your sfx will always be on a given channel, you can do `sound_mute_channel(&song_state, 3);` which will mute the fourth channel (channels are zero-indexed for this function).
+ If your sfx uses variable or multiple channels, you can do `sound_mute_channels(&song_state, sound_get_channels(&sfx_state));` which will mute the song state's channels which are used by the sfx state. `sound_mute_channels` takes a byte which has the number of channels in the upper nibble, and the channels to mute in the lower nibble, each one being represented by one bit of the nibble.

To update the sfx and unmute the song's channels when it's finished, you can do something like this once per frame:

```
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
```

### Master Volume
The Master Volume parameter can globally change a song's volume (e.g. for fading in and out) e.g.

`sound_set_master_volume(song_state, 72);`

Values above 128 (0x80) are treated as maximum volume, values below that will make the volume quieter.

### Wavetables
The location of the Wavetables in ram defaults to address 0x0EC0 but can be changed with the `sound_set_wavetable_ram_address` function e.g. `sound_set_wavetable_ram_address((unsigned char *)0xf00);`

## Sample Playback
Samples can be played back on both Mono and Colour Wonderswans.

Samples can be one-shot or looped. When looping is enabled, the entire sample will loop i.e. it is not possible to loop sub-regions of the sample.

Samples can be played back at one of four sample rates: 24000hz (Colour only), 12000hz, 6000hz or 4000hz. Samples which are not at one of these sample rates are first resampled to the nearest compatible rate.

### Effect compatibility
* Only the Note Cut and Note Delay effects currently work with samples
* Macros are not currently supported
* Panning is not currently supported

### Sample Instruments
When creating an instrument in Furnace which uses samples you can either
+ use the "WonderSwan" instrument type
    + the "Use Sample" checkbox should be ticked on the Sample tab
    + the desired sample should be selected in the dropdown box on the Sample tab
+ use the "Generic Sample" instrument type
    + the desired sample should be selected in the dropdown box on the Sample tab
The "Sample Map" and "Use Wavetable" features are not supported.

### ROM Usage
To play back samples at pitches other than the basic C4 pitch, a new copy of the sample must be created which plays back at the correct speed for one of these sample rates. 

This means that playing a sample at the pitches `C-4, D-4, E-4` will result in three slightly different samples in ROM, one for each pitch. The pitch shifted copies will play back at the same sample rate as the original sample. The total number of samples and the size of all of the samples in bytes will be reported by the conversion script.

### Mono vs. Colour Wonderswans
Depending on whether the Colour Mode Enabled bit of the System Control 2 register is set, samples will be played back using either Sound DMA or HBlank Timer Interrupts.

### Mono limitations
+ The HBlank Timer interrupt is used for sample playback as the Mono console does not have Sound DMA
+ The interrupt's playback routine will use up a lot more CPU cycles than would be taken using Sound DMA
+ Sample playback rates are limited to 12000hz, 6000hz and 4000hz. 24000hz samples will not play at all.
+ Samples can be a maximum of 64kb in size (this is a driver choice rather than hardware limitation)
