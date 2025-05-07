//
// Builds defines_sdas.inc and defines_wladx.inc for the different asm dialects
// 
// Joe Kennedy 2024
//

const fs = require('fs');

var common_defines = [
    [
        { name: "STATE_FLAG_PROCESS_NEW_LINE", value: 0x01 },
        { name: "STATE_FLAG_LOOP", value: 0x02 },
        { name: "STATE_FLAG_SFX", value: 0x04 },
        { name: "STATE_FLAG_PLAYING", value: 0x08 },
        { name: "STATE_FLAG_SAMPLE_PLAYING", value: 0x10 },
        { name: "STATE_FLAG_NOISE_ON", value: 0x20 },
    ],
];

var asm_defines = [
    /*
    [
        { name: "NOTE_ON", value: 0x00 },
        { name: "NOTE_OFF", value: 0x01 },
        { name: "INSTRUMENT_CHANGE", value: 0x02 },
        { name: "VOLUME_CHANGE", value: 0x03 },
        { name: "WAVETABLE_CHANGE", value: 0x04 },
        { name: "NOISE_MODE", value: 0x05 },
        { name: "SLIDE_UP", value: 0x06 },
        { name: "SLIDE_DOWN", value: 0x07 },
        { name: "SLIDE_PORTA", value: 0x08 },
        { name: "SLIDE_OFF", value: 0x09 },
        { name: "ARPEGGIO", value: 0x0a },
        { name: "ARPEGGIO_OFF", value: 0x0b },
        { name: "VIBRATO", value: 0x0c },
        { name: "VIBRATO_OFF", value: 0x0d },
        { name: "LEGATO_ON", value: 0x0e },
        { name: "LEGATO_OFF", value: 0x0f },
        { name: "PANNING", value: 0x10 },
        { name: "PANNING_LEFT", value: 0x11 },
        { name: "PANNING_RIGHT", value: 0x12 },
        { name: "AY_ENV_SHAPE", value: 0x13 },
        { name: "AY_ENV_PERIOD_HI", value: 0x14 },
        { name: "AY_ENV_PERIOD_LO", value: 0x15 },
        { name: "AY_CHANNEL_MIX", value: 0x16 },
        { name: "AY_NOISE_PITCH", value: 0x17 },
        { name: "AY_ENV_PERIOD_WORD", value: 0x18 },
        { name: "ORDER_JUMP", value: 0x19 },
        { name: "SET_SPEED_1", value: 0x1a },
        { name: "SET_SPEED_2", value: 0x1b },
        { name: "ORDER_NEXT", value: 0x1c },
        { name: "NOTE_DELAY", value: 0x1d },
        { name: "END_LINE", value: 0x80 },
    ],
    */
    [
        { name: "SLIDE_UP_MAX", value: 3328 },
    ],
    [
        { name: "CHAN_FLAG_MUTED", value: 0x01 },
        { name: "CHAN_FLAG_NOTE_ON", value: 0x02 },
        { name: "CHAN_FLAG_TIC_WAIT", value: 0x04 },
        { name: "CHAN_FLAG_EMPTY", value: 0x08 },
        { name: "CHAN_FLAG_VIBRATO", value: 0x10 },
        { name: "CHAN_FLAG_ARPEGGIO", value: 0x20 },
        { name: "CHAN_FLAG_SLIDE_UP", value: 0x40 },
        { name: "CHAN_FLAG_SLIDE_DOWN", value: 0x80 },
        { name: "CHAN_FLAG_SLIDE_PORTA", value: 0xC0 },
    ],
    [
        { name: "CHAN_FLAG2_VOLUME_MACRO", value: 0x01 },
        { name: "CHAN_FLAG2_WAVE_MACRO", value: 0x2 },
        { name: "CHAN_FLAG2_ARP_MACRO", value: 0x4 },
        { name: "CHAN_FLAG2_PITCH_MACRO", value: 0x8 },
        { name: "CHAN_FLAG2_DUTY_MACRO", value: 0x10 },
        { name: "CHAN_FLAG2_EMPTY", value: 0x20 },
        { name: "CHAN_FLAG2_PITCH_CHANGED", value: 0x40 },
        { name: "CHAN_FLAG2_VOLUME_CHANGE", value: 0x80 },
    ],
    [
        { name: "BANJO_MAGIC_BYTE", value: 0xba },
    ],
    [
        { name: "WAVETABLE_WRAM", value: 0xec0}
    ]
];

var structs = [
    {
        name: "instrument",
        members: [
            { name: "ex_macro_ptr", size: "db", csize: "unsigned char"},
            { name: "volume_macro_ptr", size: "db", csize: "unsigned char"},
            { name: "wave_macro_ptr", size: "db", csize: "unsigned char"},
            { name: "arp_macro_ptr", size: "db", csize: "unsigned char"},
            { name: "macro_flags", size: "db", csize: "unsigned char"},
            { name: "wave", size: "db", csize: "unsigned char"},
        ]
    },
    {
        name: "macro",
        members: [
            { name: "len", size: "db", csize: "unsigned char"},
            { name: "loop", size: "db", csize: "unsigned char"},
            { name: "last", size: "db", csize: "unsigned char"},
            { name: "pad", size: "db", csize: "unsigned char"},
            { name: "data_ptr", size: "dw", csize: "unsigned char *"},
        ]
    },
    {
        name: "sample_table",
        members: [
            { name: "data_ptr", size: "dl", csize: "unsigned long"},
            { name: "length", size: "dl", csize: "unsigned long"},
            { name: "flags", size: "db", csize: "unsigned char"},
            { name: "pad", size: "db", csize: "unsigned char"},
        ]
    },
    {
        name: "channel",
        members: [
            { name: "flags", size: "db", csize: "unsigned char" },
            { name: "flags2", size: "db", csize: "unsigned char" },

            { name: "pattern_ptr", size: "dw", csize: "unsigned char *", comment: "pointer to the current pattern" },

            { name: "freq", size: "dw", csize: "unsigned short", comment: "current fnum/tone of the voice" },
            { name: "target_freq", size: "dw", csize: "unsigned short", comment: "target fnum/tone used for portamento" },

            { name: "number", size: "db", csize: "unsigned char", comment: "channel number" },
            { name: "pan", size: "db", csize: "unsigned char", comment: "channel panning" },
            { name: "volume", size: "db", csize: "unsigned char" },
            
            { name: "instrument_num", size: "db", csize: "unsigned char" },
            { name: "wavetable_num", size: "db", csize: "unsigned char" },
            
            //{ name: "slide_amount", size: "db", csize: "unsigned char", comment: "how much to add/subtract per tic" },
            
            { name: "wait", size: "db", csize: "unsigned char", comment: "wait for this many lines/tics"},

            // we want these ones to be word aligned!
            { name: "arp_vib_pos", size: "db", csize: "unsigned char" },
            { name: "arp_vib", size: "db", csize: "unsigned char" },

            { name: "ex_macro_pos", size: "db", csize: "unsigned char"},
            { name: "ex_macro_ptr", size: "db", csize: "unsigned char"},

            { name: "volume_macro_pos", size: "db", csize: "unsigned char"},
            { name: "volume_macro_ptr", size: "db", csize: "unsigned char"},

            { name: "wave_macro_pos", size: "db", csize: "unsigned char"},
            { name: "wave_macro_ptr", size: "db", csize: "unsigned char"},

            { name: "arp_macro_pos", size: "db", csize: "unsigned char"},
            { name: "arp_macro_ptr", size: "db", csize: "unsigned char"},

            //{ name: "pad", size: "db", csize: "unsigned char"},
        ]
    },
    {
        name: "song_header",
        members: [
            { name: "magic_byte", size: "db", csize: "unsigned char", comment: "should be 0xba for a valid song" },
            { name: "bank", size: "db", csize: "unsigned char" },

            { name: "channels", size: "db", csize: "unsigned char", comment: "upper nibble: channel count. lower nibble: channels in use where bit 0 = ch 0 ..." },
            { name: "sfx_subchannel", size: "db", csize: "unsigned char" },
                
            { name: "pattern_length", size: "db", csize: "unsigned char" },
            { name: "orders_length", size: "db", csize: "unsigned char" },

            { name: "instrument_ptrs", size: "dw", csize: "instrument_t *" },
            { name: "order_ptrs", size: "dw", csize: "unsigned short *", },
            { name: "wavetables_ptr", size: "dw", csize: "unsigned char *" },
            { name: "sample_table_ptr", size: "dw", csize: "unsigned char *"  },

            { name: "volume_macro_ptrs", size: "dw", csize: "unsigned char *"  },
            { name: "wave_macro_ptrs", size: "dw", csize: "unsigned char *"  },
            { name: "arp_macro_ptrs", size: "dw", csize: "unsigned char *"  },
            { name: "ex_macro_ptrs", size: "dw", csize: "unsigned char *"  },

        ]
    },
    {
        name: "music_state",
        members: [
            { name: "flags", size: "db", csize: "unsigned char" },

            { name: "master_volume", size: "db", csize: "unsigned char" },

            { name: "speed_1", size: "db", csize: "unsigned char" },
            { name: "speed_2", size: "db", csize: "unsigned char" },

            //{ name: "subtic", size: "db", },
            { name: "tic", size: "db", csize: "unsigned char", comment: "tic must be followed by line" },
            { name: "line", size: "db", csize: "unsigned char" },
            { name: "order", size: "db", csize: "unsigned char" },
            
            { name: "order_jump", size: "db", csize: "unsigned char" },
            
            { name: "sound_ch_control", size: "db", csize: "unsigned char" },
            { name: "noise_mode", size: "db", csize: "unsigned char" },
            
            { name: "segment", size: "dw", csize: "unsigned short" },
            { name: "channels_ptr", size: "dw", csize: "channel_t *" },

        ]
    },
];

// output define file
let out_sdas = fs.openSync("include/cygnals.h", "w+");

fs.writeSync(out_sdas, "#ifndef _SOUND_DEFINES_H\n");
fs.writeSync(out_sdas, "#define _SOUND_DEFINES_H\n\n");

//
// Common definitions
//

for (let i = 0; i < common_defines.length; i++)
{
    for (let j = 0; j < common_defines[i].length; j++)
    {
        let define = common_defines[i][j];

        // sdas defines
        fs.writeSync(out_sdas, "#define " + define.name + " 0x" + define.value.toString(16) + "\n");
    }

    fs.writeSync(out_sdas, "\n");
}

//
// C definitions
//
fs.writeSync(out_sdas, "\n#ifndef __ASSEMBLER__\n\n")

// write out structs
for (let i = 0; i < structs.length; i++)
{
    let struct = structs[i];

    fs.writeSync(out_sdas, "typedef struct {\n");

    for (let j = 0; j < struct.members.length; j++)
    {
        let member = struct.members[j];

        fs.writeSync(out_sdas, "\t" + member.csize + " " + member.name + ";\n");
    }

    fs.writeSync(out_sdas, "} " + struct.name + "_t;" + "\n\n");
}

// variables and functions
let c_definitions = [
    "void sound_play(const unsigned char __far *song, music_state_t *song_state, channel_t *song_channels);",
    "void sound_update(music_state_t *song_state);",
    "void sound_stop(music_state_t *song_state);",
    "void sound_resume(music_state_t *song_state);",
    "",
    "unsigned char sound_get_channels(music_state_t *song_state);",
    "void sound_mute_channel(music_state_t *song_state, unsigned char channel);",
    "void sound_mute_channels(music_state_t *song_state, unsigned char channels);",
    "void sound_unmute_channel(music_state_t *song_state, unsigned char channel);",
    "void sound_unmute_all(music_state_t *song_state);",
    "",
    "void sound_set_master_volume(music_state_t *song_state, unsigned char volume);",
    "",
    "void sound_enable_looping(music_state_t *song_state);",
    "void sound_disable_looping(music_state_t *song_state);",
    "",
    "void sound_set_wavetable_ram_address(unsigned char *address);"
];

for (let i = 0; i < c_definitions.length; i++)
{
    fs.writeSync(out_sdas, c_definitions[i] + "\n")
}

fs.writeSync(out_sdas, "\n#endif\n")


//
// Asm definitions
//

fs.writeSync(out_sdas, "\n#ifdef __ASSEMBLER__\n\n")

for (let i = 0; i < asm_defines.length; i++)
{
    for (let j = 0; j < asm_defines[i].length; j++)
    {
        let define = asm_defines[i][j];

        // sdas defines
        fs.writeSync(out_sdas, "\t#define " + define.name + " 0x" + define.value.toString(16) + "\n");
    }

    fs.writeSync(out_sdas, "\n");
}

// write out asm structs
for (let i = 0; i < structs.length; i++)
{
    let struct = structs[i];
    let byte_offset = 0;

    for (let j = 0; j < struct.members.length; j++)
    {
        let member = struct.members[j];
        let comment = member.hasOwnProperty("comment") ? ("\t\t// " + member.comment) : "";

        let name = (struct.name + "_" + member.name).toUpperCase();

        if (member.size == "db")
        {
            fs.writeSync(out_sdas, "\t#define " + name + " " + byte_offset + comment + "\n");

            byte_offset += 1;
        }
        else if (member.size == "dw")
        {
            fs.writeSync(out_sdas, "\t#define " + name + " " + byte_offset + comment + "\n");

            byte_offset += 2;
        }
        else if (member.size == "dl")
            {
                fs.writeSync(out_sdas, "\t#define " + name + " " + byte_offset + comment + "\n");
    
                byte_offset += 4;
            }
        else
        {
            fs.writeSync(out_sdas, "\t#define " + name + " " + byte_offset + comment + "\n");

            byte_offset += member.size;
        }
        
    }

    fs.writeSync(out_sdas, "\t#define " + struct.name.toUpperCase() + "_SIZE " + byte_offset + "\n");
    fs.writeSync(out_sdas, "\n");
}

fs.writeSync(out_sdas, "#endif\n\n");

fs.writeSync(out_sdas, "#endif\n");

// close files
fs.closeSync(out_sdas);
