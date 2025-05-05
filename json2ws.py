#!/usr/bin/env python3

# json2sms
# Joe Kennedy 2024

import sys
import json
import math
from pathlib import Path
from optparse import OptionParser

MAGIC_BYTE          = 0xba

NOTE_ON             = 0x00
NOTE_OFF            = 0x01
INSTRUMENT_CHANGE   = 0x02
VOLUME_CHANGE       = 0x03
WAVETABLE_CHANGE    = 0x04
NOISE_MODE          = 0x05
SLIDE_UP            = 0x06
SLIDE_DOWN          = 0x07
SLIDE_PORTA         = 0x08
SLIDE_OFF           = 0x09
ARPEGGIO            = 0x0a
ARPEGGIO_OFF        = 0x0b
VIBRATO             = 0x0c
VIBRATO_OFF         = 0x0d
LEGATO_ON           = 0x0e
LEGATO_OFF          = 0x0f
PANNING             = 0x10
PANNING_LEFT        = 0x11
PANNING_RIGHT       = 0x12
SAMPLE_NOTE_ON      = 0x13
SAMPLE_NOTE_OFF     = 0x14
SPEAKER_LOUDNESS    = 0x15
AY_CHANNEL_MIX      = 0x16
AY_NOISE_PITCH      = 0x17
AY_ENV_PERIOD_WORD  = 0x18
ORDER_JUMP          = 0x19
SET_SPEED_1         = 0x1a
SET_SPEED_2         = 0x1b
ORDER_NEXT          = 0x1c
NOTE_DELAY          = 0x1d
END_LINE            = 0x80

INSTRUMENT_SIZE     = 16
FM_PATCH_SIZE       = 8

STATE_FLAG_PROCESS_NEW_LINE = 0x01
STATE_FLAG_LOOP = 0x02
STATE_FLAG_SFX = 0x04
STATE_FLAG_PLAYING = 0x08

MACRO_TYPE_VOLUME   = 0
MACRO_TYPE_ARP      = 1
MACRO_TYPE_DUTY     = 2
MACRO_TYPE_WAVE     = 3
MACRO_TYPE_PITCH    = 4
MACRO_TYPE_EX1      = 5

CHAN_FLAG_WAVE_MACRO    = 0x4
CHAN_FLAG_VOLUME_MACRO  = 0x8
CHAN_FLAG_VIBRATO       = 0x10
CHAN_FLAG_ARPEGGIO      = 0x20
CHAN_FLAG_SLIDE         = 0x40
CHAN_FLAG_EX_MACRO      = 0x80

macro_type_lookup = {
    MACRO_TYPE_VOLUME: 0x01,
    MACRO_TYPE_ARP: 0x4,
    MACRO_TYPE_DUTY: 0x10,
    MACRO_TYPE_WAVE: 0x2,
    MACRO_TYPE_PITCH: 0x8,
    MACRO_TYPE_EX1: 0
}

resample_cache = {}

def resample(sample, note):

    c4_freq = 130
    frequency = pow(2, (note - 69.0) / 12.0) * 440.0
    ratio = frequency/c4_freq

    new_sample = {
        'length': 0,
        'name': sample["name"],
        'compatability_rate': sample["compatability_rate"],
        'c4_rate': sample["c4_rate"],
        'depth': sample["depth"],
        'flags': sample["flags"],
        'flags2': sample["flags"],
        'loop_start': sample["loop_start"], 
        'loop_end': sample["loop_end"],
        'loop_direction': sample["loop direction"],
        'data': []
    }

    ptr = 0
    
    while (ptr < sample["length"]):
        new_sample["data"].append(sample["data"][math.floor(ptr)])
        ptr = ptr + ratio

    new_sample["length"] = len(new_sample["data"])

    return new_sample


def int_def(v, d):
    try:
        return int(v)
    except ValueError:
        return d

def main(argv=None):
    print("json2ws - Joe Kennedy 2024")

    parser = OptionParser("Usage: json2ws.py [options] INPUT_FILE_NAME.JSON")
    parser.add_option("-o", '--out',        dest='outfilename',                                      help='output file name')
    parser.add_option("-i", '--identifier', dest='identifier',                                       help='source identifier')
    parser.add_option("-s", "--sfx",        dest='sfx',                               default="-1",  help='SFX channel')

    parser.add_option("-b", '--bank',       dest='bank',                                             help='BANK number')
    parser.add_option("-a", '--area',       dest='area',                                             help='AREA name')

    (options, args) = parser.parse_args()

    if (len(args) == 0):
        parser.print_help()
        parser.error("Input file name required\n")

    infilename = Path(args[0])

    song_flags = STATE_FLAG_PLAYING | STATE_FLAG_PROCESS_NEW_LINE

    sfx = False if (options.sfx == "-1") else options.sfx

    if (sfx):

        song_flags = song_flags | STATE_FLAG_SFX
        sfx_channel = 0
        channel_count = 0

        for i in range(0, 4):

            if (str(i + 1) in sfx):
                sfx_channel = sfx_channel | (1 << i)
                channel_count = channel_count + 1

            sfx_channel = sfx_channel | (channel_count << 4)
    else:

        song_flags = song_flags | STATE_FLAG_LOOP
        sfx_channel = 0x4f

    in_filename = Path(args[0])
    out_filename = Path(options.outfilename) if (options.outfilename) else infilename.with_suffix('.c')
    song_prefix = options.identifier if (options.identifier) else str(Path(infilename.name).with_suffix(''))

    # try to load json file
    try:
        infile = open(str(in_filename), "r")
        # read into variable
        json_text = infile.read()
        infile.close()
    except OSError:
        print("Error reading input file: " + str(in_filename), file=sys.stderr)
        sys.exit(1)

    # try to parse json
    try:
        song = json.loads(json_text)
    except ValueError:
        print("File is not a valid json file: " + in_filename, file=sys.stderr)
        sys.exit(1)

    # process samples
    for i in range(0, len(song["samples"])):

        sample = song["samples"][i]
        c4_rate = sample["c4_rate"]

        # convert to a standard WS sample rate
        if c4_rate not in [4000, 6000, 12000, 24000]:
            
            # pick a close sample rate
            if c4_rate > 18000:
                new_rate = 24000
            elif c4_rate > 9000:
                new_rate = 12000
            elif c4_rate > 5000:
                new_rate = 6000
            else:
                new_rate = 4000

            # linear interpolation
            ratio = c4_rate/new_rate
            data = []
            ptr = 0
            
            while (ptr < sample["length"]):
                data.append(sample["data"][math.floor(ptr)])
                ptr = ptr + ratio

            sample["length"] = len(data)
            sample["data"] = data
            sample["c4_rate"] = new_rate
            sample["compataility_rate"] = new_rate

        # convert 16-bit to 8-bit
        if sample["depth"] == 16:

            print("converting from 16 bit sample to 8 bit sample")

            for i in range (0, len(sample["data"])):
                sample["data"][i] = sample["data"][i] >> 8

    # process instruments
    instruments = []
    volume_macros = []
    wave_macros = []
    ex_macros = []
    arp_macros = []

    for i in range(0, len(song['instruments'])):

        instrument = song['instruments'][i]

        new_instrument = {
            "sample": instrument["sample"]["initial_sample"] if "sample" in instrument else 0xff,

            "volume_macro_len": 0,
            "volume_macro_loop": 0xff,
            "volume_macro_ptr": 0xff,

            "wave": 0xff,
            "wave_macro_len": 0,
            "wave_macro_loop": 0,
            "wave_macro_ptr": 0xff,

            "arp_macro_len": 0,
            "arp_macro_loop": 0,
            "arp_macro_ptr": 0xff,

            "ex_macro_type": 0,
            "ex_macro_len": 0,
            "ex_macro_loop": 0xff,
            "ex_macro_ptr": 0xff,
        }

        # macros
        for macro in instrument["macros"]:

            if macro["loop"] != 0xff and macro["loop"] >= macro["length"]:
                macro["loop"] = 0xff

            # volume macro
            if macro["code"] == MACRO_TYPE_VOLUME:

                new_instrument["volume_macro_len"] = macro["length"]
                new_instrument["volume_macro_loop"] = macro["loop"]

                #for j in range(0, macro["length"]):                     
                #    macro['data'][j] = 15 - macro['data'][j]

                macro["name"] = "macro_volume_" + str(i)
                volume_macros.append(macro)
                new_instrument["volume_macro_ptr"] = len(volume_macros) - 1

            # wave macro
            elif macro["code"] == MACRO_TYPE_WAVE:

                if (macro["length"] == 1):

                    new_instrument["wave"] = macro["data"][0]

                else:

                    new_instrument["wave_macro_len"] = macro["length"]
                    new_instrument["wave_macro_loop"] = macro["loop"]

                    macro["name"] = "macro_wave_" + str(i)
                    wave_macros.append(macro)
                    new_instrument["wave_macro_ptr"] = len(wave_macros) - 1

            # arp macro
            elif macro["code"] == MACRO_TYPE_ARP:

                new_instrument["arp_macro_len"] = macro["length"]
                new_instrument["arp_macro_loop"] = macro["loop"]

                for j in range(0, macro["length"]):
                    val = macro['data'][j]

                    # get the absolute/relative flag in bit 7
                    absolute = ((abs(val) >> 23) & 0x80)
                    
                    # constrain the arp amount to 7 bits
                    macro['data'][j] = (macro['data'][j] & 0x7f) | absolute

                macro["name"] = "macro_arp_" + str(i)
                arp_macros.append(macro)
                new_instrument["arp_macro_ptr"] = len(arp_macros) - 1

            # currently no ex macro for this instrument
            elif new_instrument["ex_macro_ptr"] == 0xff:

                new_instrument["ex_macro_type"] = macro_type_lookup[macro["code"]] if macro["code"] in macro_type_lookup else macro["code"]
                new_instrument["ex_macro_len"] = macro["length"]
                new_instrument["ex_macro_loop"] = macro["loop"]

                if macro["code"] == MACRO_TYPE_PITCH:

                    for j in range(0, macro["length"]):

                        # value needs to be divided by 4 to scale properly with pitch tables
                        val = macro['data'][j]
                        macro['data'][j] = int(math.floor(val / 4))

                macro["name"] = "macro_ex_" + str(i)
                ex_macros.append(macro)
                new_instrument["ex_macro_ptr"] = len(ex_macros) - 1

        instruments.append(new_instrument)

    # process patterns
    patterns = {}

    # process patterns
    # go through each channel
    for i in range(0, song['channel_count']):

        # in sfx mode, only process sfx channel
        if (sfx and (str(i + 1) not in sfx)):

            continue

        # separate pattern arrays per channel
        patterns[i] = {}

        # go through each pattern in the channel
        for j in range (0, len(song['patterns'][i])):

            # keep track of the current instrument
            # so we don't have multiple INSTRUMENT_CHANGEs per note
            # when the instrument is exactly the same
            # reset at a pattern level as patterns may appear out of order
            # or be jumped to
            current_inst = -1
            current_vol = -1

            pattern = song['patterns'][i][j]

            pattern_bin = []

            if (pattern):

                last_note = { "note": -1, "octave": -1 }
                ay_envelope_auto = False

                # go through every line
                for k in range (0, song['pattern_length']):

                    line = pattern['data'][k]

                    note = { "note": line['note'], "octave": line['octave'] }

                    # instrument has changed
                    if (current_inst != line['instrument'] and line['instrument'] != -1):

                        current_inst = line['instrument']

                        # ensure the instrument exists so we don't load
                        # other data as an instrument
                        if current_inst < len(instruments):

                            pattern_bin.append(INSTRUMENT_CHANGE)
                            pattern_bin.append(current_inst)

                    # check effects
                    for eff in range (0, len(line['effects']), 2):

                        # wavetable change
                        if (line['effects'][eff] == 0x10):

                            pattern_bin.append(WAVETABLE_CHANGE)

                            pattern_bin.append(line['effects'][eff + 1])

                        # Arpeggio
                        elif (line['effects'][eff] == 0x00):

                            if (line['effects'][eff + 1] > 0):
                                pattern_bin.append(ARPEGGIO)
                                pattern_bin.append(line['effects'][eff + 1])
                            else:
                                pattern_bin.append(ARPEGGIO_OFF)


                        # Pitch slide up
                        elif (line['effects'][eff] == 0x01):

                            if (line['effects'][eff + 1] > 0):
                                pattern_bin.append(SLIDE_UP)
                                pattern_bin.append(line['effects'][eff + 1])
                            else:
                                pattern_bin.append(SLIDE_OFF)


                        # Pitch slide down
                        elif (line['effects'][eff] == 0x02):

                            if (line['effects'][eff + 1] > 0):
                                pattern_bin.append(SLIDE_DOWN)
                                pattern_bin.append(line['effects'][eff + 1])
                            else:
                                pattern_bin.append(SLIDE_OFF)


                        # Portamento
                        elif (line['effects'][eff] == 0x03):

                            if (line['effects'][eff + 1] > 0):
                                pattern_bin.append(SLIDE_PORTA)
                                pattern_bin.append(line['effects'][eff + 1])
                            else:
                                pattern_bin.append(SLIDE_OFF)

                        # Vibrato
                        elif (line['effects'][eff] == 0x04):

                            if line['effects'][eff + 1] == -1:
                                vibrato_speed = 0
                                vibrato_amount = 0
                            else:
                                vibrato_speed = line['effects'][eff + 1] >> 4
                                vibrato_amount = line['effects'][eff + 1] & 0xf

                            if (vibrato_speed == 0 and vibrato_amount == 0):
                                pattern_bin.append(VIBRATO_OFF)

                            else:
                                pattern_bin.append(VIBRATO)
                                pattern_bin.append(vibrato_speed | (vibrato_amount << 4))

                        # legato
                        elif (line['effects'][eff] == 0xea):

                            if (line['effects'][eff + 1] > 0):

                                pattern_bin.append(LEGATO_ON)

                            else:

                                pattern_bin.append(LEGATO_OFF)

                        # order jump
                        elif (line['effects'][eff] == 0x0b):
                            
                            pattern_bin.append(ORDER_JUMP)
                            pattern_bin.append(line['effects'][eff + 1])

                        # order next
                        elif (line['effects'][eff] == 0x0d):
                            
                            pattern_bin.append(ORDER_NEXT)

                        # set speed 1
                        elif (line['effects'][eff] == 0x09):
                            
                            pattern_bin.append(SET_SPEED_1)
                            pattern_bin.append(line['effects'][eff + 1] * (song['time_base'] + 1))

                        # set speed 2
                        elif (line['effects'][eff] == 0x0f):
                            
                            pattern_bin.append(SET_SPEED_2)
                            pattern_bin.append(line['effects'][eff + 1] * (song['time_base'] + 1))

                        # noise mode
                        elif (line['effects'][eff] == 0x11):
                            
                            pattern_bin.append(NOISE_MODE)
                            pattern_bin.append(line['effects'][eff + 1])

                        # note delay
                        elif (line['effects'][eff] == 0xed):

                            pattern_bin.append(NOTE_DELAY)
                            pattern_bin.append(line['effects'][eff + 1])

                        # speaker loudness control
                        elif (line['effects'][eff] == 0x20):

                            val = line['effects'][eff + 1]

                            if val < 2:
                                val = 3 << 1
                            elif val < 4:
                                val = 2 << 1
                            elif val < 8:
                                val = 1 << 1
                            else:
                                val = 0 << 1

                            pattern_bin.append(SPEAKER_LOUDNESS)
                            pattern_bin.append(val)

                        # Panning
                        elif (line['effects'][eff] == 0x80):

                            pattern_bin.append(PANNING)

                            pan = line['effects'][eff + 1]

                            if (pan == 0x80):
                                pan_left = pan_right = 0
                            elif (pan < 0x80):
                                pan_left = 0
                                pan_right = 0xf - ((pan >> 3) & 0xf)
                            else:
                                pan_left = 0xf - (((~pan) >> 3) & 0xf)
                                pan_right = 0


                            #print ("pan " + hex(pan))
                            #print ("pan_left " + hex(pan_left))
                            #print ("pan_right " + hex(pan_right))

                            pattern_bin.append((pan_left << 4) | (pan_right))

                        # Panning
                        elif (line['effects'][eff] == 0x08):

                            pattern_bin.append(PANNING)
                            pattern_bin.append((~line['effects'][eff + 1]) & 0xff)


                        # Panning Left
                        elif (line['effects'][eff] == 0x81):

                            # make into a 4 bit number then into an attenuation
                            pan = line['effects'][eff + 1] >> 4
                            pan = 15 - pan

                            pattern_bin.append(PANNING_LEFT)
                            pattern_bin.append(pan << 4)

                        # Panning Right
                        elif (line['effects'][eff] == 0x82):

                            # make into a 4 bit number then into an attenuation
                            pan = line['effects'][eff + 1] >> 4
                            pan = 15 - pan

                            pattern_bin.append(PANNING_RIGHT)
                            pattern_bin.append(pan)

                    # volume
                    # if the volume has been specified on the line, or we haven't provided a volume command yet
                    if (line['volume'] != -1):

                        if (line['volume'] != -1):
                            volume = line['volume']

                        # volume has changed
                        if volume != current_vol:

                            pattern_bin.append(VOLUME_CHANGE)
                            pattern_bin.append(volume)

                        current_vol = volume

                    # empty
                    if (line['note'] == -1 and line['octave'] == -1):

                        False

                    # note on
                    elif (line['note'] >= 0 and line['note'] < 12):

                        # sample instrument?
                        if (i == 1) and ((instruments[current_inst]["sample"] & 0xff) != 0xff):
                            
                            note_number = note['note'] + (note['octave'] * 12)

                            sample_num = instruments[current_inst]["sample"]

                            # resample sample if it's not a C4 note
                            if note_number != 48:

                                cache_id = str(sample_num) + "_" + str(note_number)

                                # has this sample already been generated?
                                if cache_id in resample_cache:

                                    sample_num = resample_cache[cache_id]
                                    print(" resample_cache lookup " + cache_id)
                                
                                # if not generate it
                                else:

                                    sample = song["samples"][sample_num]

                                    new_sample = resample(sample, note_number)

                                    song["samples"].append(new_sample)
                                    song["sample_count"] = song["sample_count"] + 1
                                    
                                    sample_num = len(song["samples"]) - 1

                                    resample_cache[cache_id] = sample_num

                                    print(" resample_cache add " + cache_id)

                            pattern_bin.append(SAMPLE_NOTE_ON)
                            pattern_bin.append(sample_num)

                        else:

                            pattern_bin.append(NOTE_ON)

                            # note number
                            pattern_bin.append((note['note'] + (note['octave'] * 12)) & 0x7f)

                            # store in last_note
                            last_note = note

                    # note off
                    elif (line['note'] == 100 or line['note'] == 101):

                        # sample channel & instrument?
                        if (i == 1) and (instruments[current_inst]["sample"] & 0xff) != 0xff:

                            pattern_bin.append(SAMPLE_NOTE_OFF)

                        else:

                            pattern_bin.append(NOTE_OFF)

                    # check effects which we want to happen post-note
                    for eff in range (0, len(line['effects']), 2):

                        # note cut
                        if (line['effects'][eff] == 0xec):

                            pattern_bin.append(NOTE_DELAY)
                            pattern_bin.append(line['effects'][eff + 1])

                            # sample instrument?
                            if (i == 1) and ((instruments[current_inst]["sample"] & 0xff) != 0xff):
                                pattern_bin.append(SAMPLE_NOTE_OFF)
                            else:
                                pattern_bin.append(NOTE_OFF)

                    # end line marker
                    pattern_bin.append(END_LINE)


                # when a run of END_LINE ends, replace it if it's long enough
                def run_end(run_length, pattern_bin_rle):

                    if (run_length > 0):
                        pattern_bin_rle.append("(" + str(END_LINE) + " | " + str(run_length - 1) + ")")


                # run length encoding for END_LINE
                run_length = 0
                pattern_bin_rle = []


                # look through pattern_bin for runs of END_LINE
                for k in range(0, len(pattern_bin)):

                    if (pattern_bin[k] == END_LINE):

                        run_length += 1

                    else:

                        run_end(run_length, pattern_bin_rle)
                        run_length = 0
                        pattern_bin_rle.append(pattern_bin[k])

                run_end(run_length, pattern_bin_rle)

                pattern_bin = pattern_bin_rle

                # add to patterns array
                patterns[i][pattern["index"]] = pattern_bin

    # output asm/h file
    outfile = open(str(out_filename), "w")

    def writelabel(label):

        outfile.write(song_prefix + "_" + label + ":" + "\n")


    outfile.write("#include <wonderful.h>\n")
    outfile.write("#include <ws.h>\n")

    outfile.write(".code16\n")
    outfile.write(".arch i186\n")
    outfile.write(".intel_syntax noprefix\n")

    outfile.write(".global " + song_prefix + "\n")
    outfile.write(".section .fartext." + song_prefix + ", \"a\"\n")

    outfile.write(".balign 16\n")
    outfile.write(".org 0\n")

    bank_number = str(0)

    # initial label
    outfile.write(song_prefix + ":" + "\n")

    # basic song data
    writelabel("magic_byte")
    outfile.write(".byte " + str(MAGIC_BYTE) + "\n")
    writelabel("bank")
    outfile.write(".byte " + bank_number + "\n")
    writelabel("sfx_channel")
    outfile.write(".byte " + hex(sfx_channel) + "\n")
    writelabel("sfx_subchannel")
    outfile.write(".byte " + str(0xff) + "\n")
    writelabel("pattern_length")
    outfile.write(".byte " + str(song['pattern_length']) + "\n")
    writelabel("orders_length")
    outfile.write(".byte " + str(song['orders_length']) + "\n")
    writelabel("instrument_ptrs")
    outfile.write(".short " + song_prefix + "_instrument_data" + "\n")
    writelabel("order_ptrs")
    outfile.write(".short " + song_prefix + "_orders" + "\n")
    writelabel("wavetables_ptr")
    outfile.write(".short " + song_prefix + "_wavetables" + "\n")
    writelabel("sample_table_ptr")
    outfile.write(".short " + song_prefix + "_sample_table" + "\n")
    writelabel("volume_macro_ptrs")
    outfile.write(".short " + song_prefix + "_volume_macros" + "\n")
    writelabel("wave_macro_ptrs")
    outfile.write(".short " + song_prefix + "_wave_macros" + "\n")
    writelabel("arp_macro_ptrs")
    outfile.write(".short " + song_prefix + "_arp_macros" + "\n")
    writelabel("ex_macro_ptrs")
    outfile.write(".short " + song_prefix + "_ex_macros" + "\n")
    writelabel("flags")
    outfile.write(".byte " + str(song_flags) + "\n")
    writelabel("master_volume")
    outfile.write(".byte 0x80\n")
    #writelabel("master_volume_fade")
    #outfile.write(".byte 0x00\n")
    writelabel("speed_1")
    outfile.write(".byte " + str(song['speed_1'] * (song['time_base'] + 1)) + "\n")
    writelabel("speed_2")
    outfile.write(".byte " + str(song['speed_2'] * (song['time_base'] + 1)) + "\n")
    #writelabel("subtic")
    #outfile.write(".byte 0\n")
    writelabel("tic")
    outfile.write(".byte " + str(song['speed_1'] * (song['time_base'] + 1)) + "\n")
    writelabel("line")
    outfile.write(".byte " + str(song['pattern_length']) + "\n")
    writelabel("order")
    outfile.write(".byte 0\n")
    writelabel("order_jump")
    outfile.write(".byte 0xff\n")
    writelabel("sound_control")
    outfile.write(".byte 0x0f\n")
    writelabel("noise_mode")
    outfile.write(".byte 0x18\n")

    outfile.write("\n" + "\n")

    # macros
    outfile.write(".balign 2\n")
    writelabel("macros")

    # volume macro
    writelabel("volume_macros")

    for i in range(0, len(volume_macros)):

        macro = volume_macros[i]

        writelabel(macro["name"])
        outfile.write(".byte " + str(macro["length"]) + " # len \n")
        outfile.write(".byte " + str(macro["loop"]) + " # loop \n")
        outfile.write(".byte " + str(macro["data"][len(macro["data"]) - 1]) + " # last \n")
        outfile.write(".byte 0xff # pad \n")
        outfile.write(".word " + song_prefix + "_" + macro["name"] + "_data" + " #ptr \n")
        outfile.write("\n")

    outfile.write("\n" + "\n")

    # wave macro
    writelabel("wave_macros")

    for i in range(0, len(wave_macros)):

        macro = wave_macros[i]

        writelabel(macro["name"])
        outfile.write(".byte " + str(macro["length"]) + " # len \n")
        outfile.write(".byte " + str(macro["loop"]) + " # loop \n")
        outfile.write(".byte " + str(macro["data"][len(macro["data"]) - 1]) + " # last \n")
        outfile.write(".byte 0xff # pad \n")
        outfile.write(".word " + song_prefix + "_" + macro["name"] + "_data" + " #ptr \n")

    outfile.write("\n" + "\n")

    # arp macro
    writelabel("arp_macros")

    for i in range(0, len(arp_macros)):

        macro = arp_macros[i]

        writelabel(macro["name"])
        outfile.write(".byte " + str(macro["length"]) + " # len \n")
        outfile.write(".byte " + str(macro["loop"]) + " # loop \n")
        outfile.write(".byte " + str(macro["data"][len(macro["data"]) - 1]) + " # last \n")
        outfile.write(".byte 0xff # pad \n")
        outfile.write(".word " + song_prefix + "_" + macro["name"] + "_data" + " #ptr \n")

    outfile.write("\n" + "\n")

    # ex macro
    writelabel("ex_macros")

    for i in range(0, len(ex_macros)):

        macro = ex_macros[i]

        writelabel(macro["name"])
        outfile.write(".byte " + str(macro["length"]) + " # len \n")
        outfile.write(".byte " + str(macro["loop"]) + " # loop \n")
        outfile.write(".byte " + str(macro["data"][len(macro["data"]) - 1]) + " # last \n")
        outfile.write(".byte 0xff # pad \n")
        outfile.write(".word " + song_prefix + "_" + macro["name"] + "_data" + " #ptr \n")

    outfile.write("\n" + "\n")

    # macro data

    # volume macro data
    writelabel("volume_macros_data")

    for i in range(0, len(volume_macros)):

        macro = volume_macros[i]

        writelabel(macro["name"] + "_data")
        outfile.write(".byte " + ", ".join(map(str, macro["data"])) + "\n")

    outfile.write("\n" + "\n")

    # wave macro data
    writelabel("wave_macros_data")

    for i in range(0, len(wave_macros)):

        macro = wave_macros[i]

        writelabel(macro["name"] + "_data")
        outfile.write(".byte " + ", ".join(map(str, macro["data"])) + "\n")

    outfile.write("\n" + "\n")

    # arp macro data
    writelabel("arp_macros_data")

    for i in range(0, len(arp_macros)):

        macro = arp_macros[i]

        writelabel(macro["name"] + "_data")
        outfile.write(".byte " + ", ".join(map(str, macro["data"])) + "\n")

    outfile.write("\n" + "\n")

    # ex macro data
    writelabel("ex_macros_data")

    for i in range(0, len(ex_macros)):

        macro = ex_macros[i]

        writelabel(macro["name"] + "_data")
        outfile.write(".byte " + ", ".join(map(str, macro["data"])) + "\n")

    outfile.write("\n" + "\n")

    # instruments
    outfile.write(".balign 2\n")
    writelabel("instrument_data")

    for i in range (0, len(instruments)):

        instrument = instruments[i]

        writelabel("instrument_" + str(i))

        macro_flags = 0

        if (instrument["ex_macro_len"] > 0):
            macro_flags = macro_flags | instrument["ex_macro_type"]

        if (instrument["volume_macro_len"] > 0):
            macro_flags = macro_flags | macro_type_lookup[MACRO_TYPE_VOLUME]

        if (instrument["wave_macro_len"] > 0):
            macro_flags = macro_flags | macro_type_lookup[MACRO_TYPE_WAVE]

        if (instrument["arp_macro_len"] > 0):
            macro_flags = macro_flags | macro_type_lookup[MACRO_TYPE_ARP]

        # ex macro
        outfile.write("\t.byte " + str(instrument["ex_macro_ptr"]) + " # ex num\n")

        # volume macro
        outfile.write("\t.byte " + str(instrument["volume_macro_ptr"]) + " # vol num\n")

        # wave macro
        outfile.write("\t.byte " + str(instrument["wave_macro_ptr"]) + " # wave num\n")

        # arp macro
        outfile.write("\t.byte " + str(instrument["arp_macro_ptr"]) + " # arp num\n")

        # flags
        outfile.write("\t.byte " + hex(macro_flags) + " # flags \n")

        # wave
        outfile.write("\t.byte " + str(instrument["wave"]) + " # wave \n")

    outfile.write("\n" + "\n")

    # wavetables

    outfile.write(".balign 2\n")
    writelabel("wavetables")

    for i in range (0, song['wavetable_count']):

        wave_in = song['wavetables'][i]['data'][0]

        if len(wave_in) < 32:
            
            new_wave = []
            step = len(wave_in)/32
            
            s = 0
            while(s < len(wave_in)):
                new_wave.append(wave_in[math.floor(s)])
                s = s + step

            wave_in = new_wave

        wavetable = []

        for s in range (0, 32, 2):
            s0 = wave_in[s]
            s1 = wave_in[s + 1]

            s0 = 15 if s0 > 15 else s0
            s1 = 15 if s1 > 15 else s1

            samp = s0 | (s1 << 4)
            wavetable.append(samp)

        writelabel("wavetable_" + str(i))
        outfile.write(".byte " + ", ".join(map(hex, wavetable)) + "\n")

    outfile.write("\n" + "\n")

    # order pointers
    outfile.write(".balign 2\n")
    writelabel("order_pointers")

    for i in range (0, song['channel_count']):

        # in sfx mode, only process sfx channel
        if (sfx and (str(i + 1) not in sfx)):

            continue

        outfile.write("\t.short " + song_prefix + "_orders_channel_" + str(i) + "\n")

    outfile.write("\n" + "\n")

    # orders
    outfile.write(".balign 2\n")
    writelabel("orders")

    for i in range (0, song['channel_count']):

        # in sfx mode, only process sfx channel
        if (sfx and (str(i + 1) not in sfx)):

            continue

        writelabel("orders_channel_" + str(i))

        for j in range (0, len(song['orders'][i])):

            if (j == 0):
                outfile.write("\t.short ")
            elif (j % 4 == 0):
                outfile.write("\n\t.short ")

            outfile.write(song_prefix + "_patterns_" + str(i) + "_" + str(song['orders'][i][j]))

            if ((j % 4 != 3) and (j != len(song['orders'][i]) - 1)):

                outfile.write(", ")


        outfile.write("\n")


    outfile.write("\n" + "\n")

    # patterns
    writelabel("patterns")

    for i in range (0, song['channel_count']):

        # in sfx mode, only process sfx channelfs.
        if (sfx and (str(i + 1) not in sfx)):

            continue

        for j in range (0, len(song["patterns"][i])):

            pattern_index = song["patterns"][i][j]["index"]

            writelabel("patterns_" + str(i) + "_" + str(pattern_index))
            outfile.write(".byte " + ", ".join(map(str, patterns[i][pattern_index])) + "\n")

    # samples
    outfile.write(".balign 2\n")
    writelabel("sample_table")

    # ensure the last sample is 0
    for i in range (0, song['sample_count']):

        sample = song['samples'][i]
        sample["length"] += 1
        sample["data"].append(-128)

    # sample table with addresses and lengths
    for i in range (0, song['sample_count']):

        sample = song['samples'][i]

        writelabel("sample_" + str(i))
        outfile.write(".long " + song_prefix + "_sample_data_" + str(i) + "\n")
        outfile.write(".long " + str(sample["length"]) + "\n")

        sample_flags = "DMA_TRANSFER_ENABLE"

        if sample["loop_start"] != -1:
            sample_flags = sample_flags + " | SDMA_REPEAT"

        if sample["c4_rate"] >= 18000:
            sample_flags = sample_flags + " | SDMA_RATE_24000"
        elif sample["c4_rate"] >= 9000:
            sample_flags = sample_flags + " | SDMA_RATE_12000"
        elif sample["c4_rate"] >= 5000:
            sample_flags = sample_flags + " | SDMA_RATE_6000"
        else:
            sample_flags = sample_flags + " | SDMA_RATE_4000"

        outfile.write(".byte " + sample_flags + "\n")

        outfile.write(".byte 0xff #pad\n")

    # raw sample data
    writelabel("sample_data")

    sample_size_total = 0

    for i in range (0, song['sample_count']):

        sample = song['samples'][i]

        writelabel("sample_data_" + str(i))

        for j in range (0, len(sample["data"])):
            sample["data"][j] = (sample["data"][j] + 128)

            if sample["data"][j] > 255:
                sample["data"][j] = 255

        for j in range (0, len(sample["data"]), 32):
            outfile.write(".byte " + ", ".join(map(str, sample["data"][j:j+32])) + "\n")

        sample_size_total = sample_size_total + len(sample["data"])

    print(" samples: " + str(song["sample_count"]) + " samples")
    print(" samples size: " + str(sample_size_total) + " bytes")


    # close file
    outfile.close()


if __name__=='__main__':
    main()
