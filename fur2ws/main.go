
// fur2ws
// Joe Kennedy 2025


package main

import (
	//"io"
	//"log"
	//"bytes"
	//"compress/zlib"
	//"encoding/binary"
	//"encoding/json"
	"os"
	"flag"
	"math"
	"strings"
	"fmt"
	"path/filepath"
	"fur2ws/fur2ws/furnace2go"
)

const MAGIC_BYTE          = 0xba

const NOTE_ON             = 0x00
const NOTE_OFF            = 0x01
const INSTRUMENT_CHANGE   = 0x02
const VOLUME_CHANGE       = 0x03
const WAVETABLE_CHANGE    = 0x04
const NOISE_MODE          = 0x05
const SLIDE_UP            = 0x06
const SLIDE_DOWN          = 0x07
const SLIDE_PORTA         = 0x08
const SLIDE_OFF           = 0x09
const ARPEGGIO            = 0x0a
const ARPEGGIO_OFF        = 0x0b
const VIBRATO             = 0x0c
const VIBRATO_OFF         = 0x0d
const LEGATO_ON           = 0x0e
const LEGATO_OFF          = 0x0f
const PANNING             = 0x10
const PANNING_LEFT        = 0x11
const PANNING_RIGHT       = 0x12
const SAMPLE_NOTE_ON      = 0x13
const SAMPLE_NOTE_OFF     = 0x14
const SPEAKER_LOUDNESS    = 0x15
const AY_CHANNEL_MIX      = 0x16
const AY_NOISE_PITCH      = 0x17
const AY_ENV_PERIOD_WORD  = 0x18
const ORDER_JUMP          = 0x19
const SET_SPEED_1         = 0x1a
const SET_SPEED_2         = 0x1b
const ORDER_NEXT          = 0x1c
const NOTE_DELAY          = 0x1d
const END_LINE            = 0x80

const STATE_FLAG_PROCESS_NEW_LINE = 0x01
const STATE_FLAG_LOOP = 0x02
const STATE_FLAG_SFX = 0x04
const STATE_FLAG_PLAYING = 0x08

const MACRO_TYPE_VOLUME   = 0
const MACRO_TYPE_ARP      = 1
const MACRO_TYPE_DUTY     = 2
const MACRO_TYPE_WAVE     = 3
const MACRO_TYPE_PITCH    = 4
const MACRO_TYPE_EX1      = 5

const CHAN_FLAG_WAVE_MACRO    = 0x4
const CHAN_FLAG_VOLUME_MACRO  = 0x8
const CHAN_FLAG_VIBRATO       = 0x10
const CHAN_FLAG_ARPEGGIO      = 0x20
const CHAN_FLAG_SLIDE         = 0x40
const CHAN_FLAG_EX_MACRO      = 0x80

var macro_type_lookup = map[uint8]uint8 {
    MACRO_TYPE_VOLUME: 0x01,
    MACRO_TYPE_ARP: 0x4,
    MACRO_TYPE_DUTY: 0x10,
    MACRO_TYPE_WAVE: 0x2,
    MACRO_TYPE_PITCH: 0x8,
    MACRO_TYPE_EX1: 0,
}

var sample_rates = []uint32{4000, 6000, 12000, 24000}

var resample_cache = map[string]uint16 {}

// write out macro structure
func write_macros(outfile *os.File, macros []furnace2go.Macro, song_prefix string, macro_prefix string) {

	outfile.WriteString(song_prefix + "_" + macro_prefix + "_macros:\n")
	
	for i, macro := range macros {
	
		var macro_loop uint8
		var macro_length uint8
		
		// ensure loop length makes sense
		if (macro.Loop != 0xff) && (macro.Loop >= macro.Length) {
			macro_loop = 0xff
		} else {
			macro_loop = macro.Loop
		}

		// scale and offset loop position
		if macro_loop != 0xff {
			macro_loop = (macro_loop * macro.Speed) + macro.Delay
		}

		// if there's a delay it sort of counts as the first step and its length isn't scaled
		if macro.Delay > 0 {
			macro_length = macro.Delay + ((macro.Length - 1) * macro.Speed)
		} else {
			macro_length = macro.Length * macro.Speed
		}

		outfile.WriteString(song_prefix + "_" + macro_prefix + "_macro_" + fmt.Sprint(i) + ":\n")
		outfile.WriteString("\t.byte " + fmt.Sprint(macro_length) + " # length\n")
		outfile.WriteString("\t.byte " + fmt.Sprint(macro_loop) + " # loop\n")
		outfile.WriteString("\t.byte " + fmt.Sprint(macro.Data[macro.Length - 1].(uint8)) + " # last\n")
		outfile.WriteString("\t.byte 0xff # pad\n")
		outfile.WriteString("\t.word " + song_prefix + "_" + macro_prefix + "_macro_data_" + fmt.Sprint(i) + " - " + song_prefix + " # ptr\n")

		outfile.WriteString("\n")
	}
	
	outfile.WriteString("\n")
}

// write out macro data
func write_macro_data(outfile *os.File, macros []furnace2go.Macro, song_prefix string, macro_prefix string) {

	outfile.WriteString(song_prefix + "_" + macro_prefix + "_macro_data:\n")
	
	for i, macro := range macros {

		var d uint8
		
		var j int
		var j_start int = 0

		var out []any = []any{}

		// macro delay
		if macro.Delay > 0 {

			for d = 0; d < macro.Delay; d++ {
				out = append(out, macro.Data[0]) 
			}

			j_start = 1;
		}

		// macro data
		for j = j_start; j < len(macro.Data); j++ {

			// repeat each step macro.Speed times
			for d = 0; d < macro.Speed; d++ {
				out = append(out, macro.Data[j])
			}

		}

		outfile.WriteString(song_prefix + "_" + macro_prefix + "_macro_data_" + fmt.Sprint(i) + ":\n")
		outfile.WriteString(fmt.Sprintf("\t.byte " + strings.Trim(strings.Replace(fmt.Sprintf("%d", out), " ", ", ", -1 ), "[]") + "\n"))
	}
	
	outfile.WriteString("\n")
}

func resample_data(in []any, ratio float64, looping bool) (out []any) {

    var vnew float64
    var ptr float64 = 0

	// linear interpolation through sample
    for (ptr < float64(len(in))) {

		// offsets of two points to interpolate
        var p0 uint32 = uint32(math.Floor(ptr))
		var p1 uint32 = uint32(math.Floor(ptr + ratio))

		// values at two offsets
		var v0 float64
		var v1 float64

		// first value
        v0 = float64(in[p0].(int8))

		// check if second sample offset is outside bounds of source 
        if p1 >= uint32(len(in)) {

            // this doesn't loop, set second value to 0
            if !looping {
				
                v1 = float64(0)

            // this does loop, set second value to wrapped sample
            } else {

                v1 = float64(in[p1 % uint32(len(in))].(int8))

            }

		// sample offset is inside bounds of source
        } else {
            v1 = float64(in[p1].(int8))
        }

        vnew = (v0 * (1.0 - math.Mod(ptr, 1))) + (v1 * math.Mod(ptr, 1))

        out = append(out, int8(vnew))
        ptr = ptr + ratio
	}

    return out
}

func resample(sample furnace2go.Sample, note_number uint8) (outsample furnace2go.Sample) {

    var c4_freq float64 = 130
    var frequency float64 = math.Pow(2, (float64(note_number) - 69.0) / 12.0) * 440.0
    var ratio float64 = frequency/c4_freq

	// new sample
	outsample = furnace2go.Sample{
		Name: sample.Name,
        Length: 0,
        CompatRate: sample.CompatRate,
        C4Rate: sample.C4Rate,
        Depth: sample.Depth,
        //'flags': sample["flags"],
        //'flags2': sample["flags"],
		LoopDir: sample.LoopDir,
        LoopStart: sample.LoopStart, 
        LoopEnd: sample.LoopEnd,
        Data: []any{},
    }

    outsample.Data = resample_data(sample.Data, ratio, sample.LoopStart != 0xffffffff)    
    outsample.Length = uint32(len(outsample.Data))

	return outsample
}

func main() {
	
	var i uint32
	
	var infilename, outfilename string
	var sfx string
	var song_prefix, song_data_prefix, sample_data_prefix string

	flag.StringVar(&outfilename, "o", "", "output file name")
	flag.StringVar(&song_prefix, "i", "", "variable name")
	flag.StringVar(&sfx, "s", "", "SFX channels; auto to autodetect or string of channel numbers e.g. 12 for channels 1 & 2")
	flag.StringVar(&song_data_prefix, "p", "farrodata", "name used as .section prefix for song data")
	flag.StringVar(&sample_data_prefix, "q", "farrodata", "name used as .section prefix for sample data")

	flag.Parse()

	infilename = flag.Arg(0)

	// outfilename not specified
	// default to infilename with .fur extension replaced
	if outfilename == "" {
		outfilename = infilename[0:len(infilename)-4] + ".s"
	}

	// song_prefix variable name not specified
	// replace with name of file with .fur extension removed
	if song_prefix == "" {
		song_prefix = filepath.Base(infilename)
		song_prefix = song_prefix[0:len(song_prefix)-4]
	}
	
	// convert furnace file to Go structs
	song := furnace2go.Convert(infilename)
	
	// open output file
	outfile, err := os.Create(outfilename)
	
	if err != nil {
		panic(err)
	}

	// default flags
	song_flags := STATE_FLAG_PLAYING | STATE_FLAG_PROCESS_NEW_LINE

	// handle sfx mode
	sfx_channel := 0

    if sfx != "" {

		// flag as sfx
        song_flags = song_flags | STATE_FLAG_SFX
        sfx_channel = 0
        channel_count := 0

		// autodetect sfx channels
		if strings.ToLower(sfx) == "auto" {

			// figure out which patterns have content in them
			for _, pat := range song.Patterns {
				if len(pat.Lines) > 0 {
					sfx_channel = sfx_channel | (1 << pat.Channel)
				}
			}

			// count up the number of channels
			for i = 0; i < 4; i++ {
				if (sfx_channel & (1 << i)) != 0 {
					channel_count++
				}
			}

			// channel count in upper nibble
			sfx_channel = sfx_channel | (channel_count << 4)

		// specified sfx channels
		} else {

			// build sfx info byte
			for i = 0; i < 4; i++ {

				// bit to denote presence of each specified channel in lower nibble
				if strings.Contains(sfx, fmt.Sprint(i + 1)) {
					sfx_channel = sfx_channel | (1 << i)
					channel_count++
				}

				// channel count in upper nibble
				sfx_channel = sfx_channel | (channel_count << 4)
			}

		}
			
	} else {

        song_flags = song_flags | STATE_FLAG_LOOP
        sfx_channel = 0x4f
	}
	
	// include wf header files
    outfile.WriteString("#include <wonderful.h>\n")
    outfile.WriteString("#include <ws.h>\n")
	outfile.WriteString("\n")

	// assembler directives for ws
    outfile.WriteString(".code16\n")
    outfile.WriteString(".arch i186\n")
    outfile.WriteString(".intel_syntax noprefix\n")
	outfile.WriteString("\n")

	// export symbol for song data
    outfile.WriteString(".global " + song_prefix + "\n")

    // export symbol for sample data
    if (song.SampleCount > 0) {
        outfile.WriteString(".global " + song_prefix + "_sample_data\n")
	}

	// open song data section
    outfile.WriteString("\n")
    outfile.WriteString(".section ." + song_data_prefix + "." + song_prefix + ", \"a\"\n")
    outfile.WriteString("\n")

    outfile.WriteString(".balign 16\n")
    //outfile.WriteString(".org 0\n")
	outfile.WriteString("\n")

    bank_number := fmt.Sprint(0)

    // initial label
    outfile.WriteString(song_prefix + ":" + "\n")

    // basic song data
    outfile.WriteString(song_prefix + "_" + "magic_byte:\n")
    outfile.WriteString(".byte " + fmt.Sprintf("%#x", MAGIC_BYTE) + "\n")
	
    outfile.WriteString(song_prefix + "_" + "bank:\n")
    outfile.WriteString(".byte " + bank_number + "\n")
	
    outfile.WriteString(song_prefix + "_" + "sfx_channel:\n")
    outfile.WriteString(".byte " + fmt.Sprintf("%#x", sfx_channel) + "\n")
	
    outfile.WriteString(song_prefix + "_" + "sfx_subchannel:\n")
    outfile.WriteString(".byte " + fmt.Sprint(0xff) + "\n")
	
    outfile.WriteString(song_prefix + "_" + "pattern_length:\n")
    outfile.WriteString(".byte " + fmt.Sprint(song.PatternLength) + "\n")
	
    outfile.WriteString(song_prefix + "_" + "orders_length:\n")
    outfile.WriteString(".byte " + fmt.Sprint(song.OrdersLength) + "\n")
	
    outfile.WriteString(song_prefix + "_" + "instrument_ptrs:\n")
    outfile.WriteString(".short " + song_prefix + "_instrument_data" + " - " + song_prefix + "\n")
	
    outfile.WriteString(song_prefix + "_" + "order_ptrs:\n")
    outfile.WriteString(".short " + song_prefix + "_orders" + " - " + song_prefix + "\n")
	
    outfile.WriteString(song_prefix + "_" + "wavetables_ptr:\n")
    outfile.WriteString(".short " + song_prefix + "_wavetables" + " - " + song_prefix + "\n")
	
    outfile.WriteString(song_prefix + "_" + "sample_table_ptr:\n")
    outfile.WriteString(".short " + song_prefix + "_sample_table" + " - " + song_prefix + "\n")
	
    outfile.WriteString(song_prefix + "_" + "volume_macro_ptrs:\n")
    outfile.WriteString(".short " + song_prefix + "_volume_macros" + " - " + song_prefix + "\n")
	
    outfile.WriteString(song_prefix + "_" + "wave_macro_ptrs:\n")
    outfile.WriteString(".short " + song_prefix + "_wave_macros" + " - " + song_prefix + "\n")
	
    outfile.WriteString(song_prefix + "_" + "arp_macro_ptrs:\n")
    outfile.WriteString(".short " + song_prefix + "_arp_macros" + " - " + song_prefix + "\n")
	
    outfile.WriteString(song_prefix + "_" + "ex_macro_ptrs:\n")
    outfile.WriteString(".short " + song_prefix + "_ex_macros" + " - " + song_prefix + "\n")
	
    outfile.WriteString(song_prefix + "_" + "flags:\n")
    outfile.WriteString(".byte " + fmt.Sprint(song_flags) + "\n")
	
    outfile.WriteString(song_prefix + "_" + "master_volume:\n")
    outfile.WriteString(".byte 0x80\n")
	
    outfile.WriteString(song_prefix + "_" + "speed_1:\n")
    outfile.WriteString(".byte " + fmt.Sprint(song.Speed1 * (song.TimeBase + 1)) + "\n")
	
    outfile.WriteString(song_prefix + "_" + "speed_2:\n")
    outfile.WriteString(".byte " + fmt.Sprint(song.Speed2 * (song.TimeBase + 1)) + "\n")
	
    outfile.WriteString(song_prefix + "_" + "tic:\n")
    outfile.WriteString(".byte " + fmt.Sprint(song.Speed1 * (song.TimeBase + 1)) + "\n")
	
    outfile.WriteString(song_prefix + "_" + "line:\n")
    outfile.WriteString(".byte " + fmt.Sprint(song.PatternLength) + "\n")
	
    outfile.WriteString(song_prefix + "_" + "order:\n")
    outfile.WriteString(".byte 0\n")
	
    outfile.WriteString(song_prefix + "_" + "order_jump:\n")
    outfile.WriteString(".byte 0xff\n")
	
    outfile.WriteString(song_prefix + "_" + "sound_control:\n")
    outfile.WriteString(".byte 0x0f\n")
	
    outfile.WriteString(song_prefix + "_" + "noise_mode:\n")
    outfile.WriteString(".byte 0x18\n")

    outfile.WriteString("\n" + "\n")
	
	
    // process samples
    for i, sample := range song.Samples {

		// check if this sample rate is a native WS one
		sample_rate_found := false
		
		for _, rate := range sample_rates {
			if rate == sample.C4Rate {
				sample_rate_found = true
				break
			}
		}
		
        // convert 16-bit to 8-bit
        if sample.Depth == 16 {

            print(" * sample " + fmt.Sprint(i) + " converting from 16 bit sample to 8 bit sample\n")

            for j := 0; j < len(sample.Data); j++ {
                sample.Data[j] = int8(sample.Data[j].(int16) >> 8)
			}
		}

        // convert to a standard WS sample rate
        if !sample_rate_found {
            
			var new_rate float64 = 4000
			
            // pick a close sample rate
            if (sample.C4Rate > 18000) {
                new_rate = 24000
            } else if (sample.C4Rate > 9000) {
                new_rate = 12000
            } else if (sample.C4Rate > 5000) {
                new_rate = 6000
			}
			
            // linear interpolation
            var ratio = float64(sample.C4Rate)/new_rate

            sample.Data = resample_data(sample.Data, ratio, sample.LoopStart != 0xffffffff)    

            print(" * sample " + fmt.Sprint(i) + " resampling from " + fmt.Sprint(sample.C4Rate) + "hz to " + fmt.Sprint(new_rate) + "hz\n")

            sample.Length = uint32(len(sample.Data))
            sample.C4Rate = uint32(new_rate)
            sample.CompatRate = uint32(new_rate)
			
		}

        // warn for 24000hz samples
        if sample.C4Rate == 24000 {
            print(" * mono warning: sample " + fmt.Sprint(i) + " rate is 24000hz and will not play on mono\n")
		}
		
        // warn for big samples
        if sample.Length > 65536 {
            print(" * mono warning: sample " + fmt.Sprint(i) + " length is > 64kb (" + fmt.Sprint(sample.Length) + " bytes) and will not loop properly on mono\n")
		}
	}
	
	// output instrument data
	outfile.WriteString(".balign 2\n")
	outfile.WriteString(song_prefix + "_instrument_data:\n")
	
	volume_macros := []furnace2go.Macro{}
	arp_macros := []furnace2go.Macro{}
	wave_macros := []furnace2go.Macro{}
	ex_macros := []furnace2go.Macro{}
	
	for i, inst := range song.Instruments {
	
		outfile.WriteString(fmt.Sprintf(song_prefix + "_instrument_%d:\n", i))
	
		var volume_macro_idx, wave_macro_idx, arp_macro_idx, ex_macro_idx, fixed_wave uint8
		var macro_flags uint8 = 0
	
		volume_macro_idx = 0xff
		wave_macro_idx = 0xff
		arp_macro_idx = 0xff
		ex_macro_idx = 0xff
		fixed_wave = 0xff
		
		for j, macro := range inst.Macros {
		
			switch macro.Code {
			
				case MACRO_TYPE_VOLUME:
				
					macro_flags |= macro_type_lookup[macro.Code]
					volume_macro_idx = uint8(len(volume_macros))
					volume_macros = append(volume_macros, macro)
				
				case MACRO_TYPE_ARP:

					// handle arp macro data types
					// 32 bit ones are absolute values rather than offsets from the current note
					switch macro.Data[0].(type) {

						case int8:

							for k := 0; k < int(macro.Length); k++ {
								// constrain the arp amount to 7 bits
								inst.Macros[j].Data[k] = uint8(inst.Macros[j].Data[k].(int8)) & 0x7f
							}

						case int32:

							for k := 0; k < int(macro.Length); k++ {

								value := inst.Macros[j].Data[k].(int32)

								// get the absolute/relative flag from bit 31 of the full value into bit 7
								// constrain the arp amount to 7 bits
								inst.Macros[j].Data[k] = uint8(value & 0x7f) | uint8((max(value, -value) >> 23) & 0x80)
							}
					}

					macro_flags |= macro_type_lookup[macro.Code]
					arp_macro_idx = uint8(len(arp_macros))
					arp_macros = append(arp_macros, macro)

				case MACRO_TYPE_WAVE:
				
					if macro.Length == 1 {
						fixed_wave = macro.Data[0].(uint8)
					} else {
						macro_flags |= macro_type_lookup[macro.Code]
						wave_macro_idx = uint8(len(wave_macros))
						wave_macros = append(wave_macros, macro)
					}
				
				default:

					_, typecode_found := macro_type_lookup[macro.Code]
				
					if typecode_found {
					
                        // value needs to be divided by 4 to scale properly with pitch tables
						if macro.Code == MACRO_TYPE_PITCH {
							for k := 0; k < int(macro.Length); k++ {
								inst.Macros[j].Data[k] = uint8(inst.Macros[j].Data[k].(int8) / 4)
							}
						}
					
						macro_flags |= macro_type_lookup[macro.Code]
						ex_macro_idx = uint8(len(ex_macros))
						ex_macros = append(ex_macros, macro)
					}
			}
		}
		
		outfile.WriteString("\t.byte " + fmt.Sprint(ex_macro_idx) + " # ex_macro_idx\n")
		outfile.WriteString("\t.byte " + fmt.Sprint(volume_macro_idx) + " # volume_macro_idx\n")
		outfile.WriteString("\t.byte " + fmt.Sprint(wave_macro_idx) + " # wave_macro_idx\n")
		outfile.WriteString("\t.byte " + fmt.Sprint(arp_macro_idx) + " # arp_macro_idx\n")
		outfile.WriteString("\t.byte " + fmt.Sprint(macro_flags) + " # macro_flags\n")
		outfile.WriteString("\t.byte " + fmt.Sprint(fixed_wave) + " # fixed_wave\n")
		outfile.WriteString("\n")
	}
	
	outfile.WriteString("\n" + "\n")

	// macros
	outfile.WriteString(".balign 2\n")
	outfile.WriteString(song_prefix + "_macros:\n\n")

	write_macros(outfile, volume_macros, song_prefix, "volume")
	write_macros(outfile, arp_macros, song_prefix, "arp")
	write_macros(outfile, wave_macros, song_prefix, "wave")
	write_macros(outfile, ex_macros, song_prefix, "ex")

	outfile.WriteString("\n" + "\n")
	
	// macro data
	outfile.WriteString(song_prefix + "_macro_data:\n\n")
	
	write_macro_data(outfile, volume_macros, song_prefix, "volume")
	write_macro_data(outfile, arp_macros, song_prefix, "arp")
	write_macro_data(outfile, wave_macros, song_prefix, "wave")
	write_macro_data(outfile, ex_macros, song_prefix, "ex")
	
	outfile.WriteString("\n" + "\n")

	// output wavetable data
	outfile.WriteString(".balign 2\n")
	outfile.WriteString(song_prefix + "_wavetables:\n")
	
	for i, wt := range song.Wavetables {
		
		wt_out := []uint8{}
		
		for j := 0; j < 32; j += 2 {
		
			// get wavetable values
			s0 := wt.Data[j]
			s1 := wt.Data[j + 1]
			
			// clamp them to 0-15
			if s0 > 15 {
				s0 = 15
			}
			
			if s1 > 15 {
				s1 = 15
			}
			
			// combine them in upper/lower nibbles
			wt_out = append(wt_out, uint8(s0 | (s1 << 4)))
		}
		
		outfile.WriteString(fmt.Sprintf(song_prefix + "_wavetable_%d:\n", i))
		outfile.WriteString(fmt.Sprintf(".byte " + strings.Trim(strings.Replace(fmt.Sprintf("% #x", wt_out), " ", ", ", -1 ), "[]") + "\n"))
	}

	outfile.WriteString("\n\n")
	
	// output order data
	outfile.WriteString(".balign 2\n")
	outfile.WriteString(song_prefix + "_orders:\n")
	
	for i, orders := range song.Orders {
	
		// only process orders which are specified
		// by flags in the lower nibble of sfx_channel
		// for regular songs all of these flags will be 1
        if (sfx_channel & (1 << i)) == 0 {
            continue
		}

		outfile.WriteString(song_prefix + "_orders_ch_" + fmt.Sprintf("%d", i) + ":\n")
	
		for _, idx := range orders {		
			outfile.WriteString("\t.short " + song_prefix + "_pattern_" + fmt.Sprintf("%d_%d", i, idx) + " - " + song_prefix + "\n")
		}
	}
	
	outfile.WriteString("\n\n")
		
	// parse pattern data
	outfile.WriteString(song_prefix + "_patterns:\n")
	for i = 0; i < song.PatternCount; i++ {
	
		var line_count uint16 = 0
		
		pattern := song.Patterns[i]

		// only process channels which are specified
		// by flags in the lower nibble of sfx_channel
		// for regular songs all of these flags will be 1
        if (sfx_channel & (1 << pattern.Channel)) == 0 {
            continue
		}

		// keep track of the current instrument
		// so we don't have multiple INSTRUMENT_CHANGEs per note
		// when the instrument is exactly the same
		// reset at a pattern level as patterns may appear out of order
		// or be jumped to
		var current_inst uint8 =  0xff
		var current_vol uint8 = 0xff

		pattern_bin := []uint8{}

		// go through every line
		for _, line := range pattern.Lines {

			// instrument has changed
			if (current_inst != line.Instrument) && (line.Instrument != 0xff) {

				current_inst = line.Instrument

				// ensure the instrument exists so we don't load
				// other data as an instrument
				if uint16(current_inst) < song.InstrumentCount {
					pattern_bin = append(pattern_bin, INSTRUMENT_CHANGE)
					pattern_bin = append(pattern_bin, current_inst)
				}
			}

			// check effects
			for _, eff := range line.Effects {

				// wavetable change
				if (eff.Effect == 0x10) {

					pattern_bin = append(pattern_bin, WAVETABLE_CHANGE)
					pattern_bin = append(pattern_bin, eff.Value)

				// Arpeggio
				} else if (eff.Effect == 0x00) {

					if (eff.Value > 0) {
						pattern_bin = append(pattern_bin, ARPEGGIO)
						pattern_bin = append(pattern_bin, eff.Value)
					} else {
						pattern_bin = append(pattern_bin, ARPEGGIO_OFF)
					}

				// Pitch slide up
				} else if (eff.Effect == 0x01) {

					if (eff.Value > 0) {
						pattern_bin = append(pattern_bin, SLIDE_UP)
						pattern_bin = append(pattern_bin, eff.Value)
					} else {
						pattern_bin = append(pattern_bin, SLIDE_OFF)
					}
				
				// Pitch slide down
				} else if (eff.Effect == 0x02) {

					if (eff.Value > 0) {
						pattern_bin = append(pattern_bin, SLIDE_DOWN)
						pattern_bin = append(pattern_bin, eff.Value)
					} else {
						pattern_bin = append(pattern_bin, SLIDE_OFF)
					}

				// Portamento
				} else if (eff.Effect == 0x03) {

					if (eff.Value > 0) {
						pattern_bin = append(pattern_bin, SLIDE_PORTA)
						pattern_bin = append(pattern_bin, eff.Value)
					} else {
						pattern_bin = append(pattern_bin, SLIDE_OFF)
					}
				
				// Vibrato
				} else if (eff.Effect == 0x04) {

					vibrato_speed := eff.Value >> 4
					vibrato_amount := eff.Value & 0xf
					
					if (vibrato_speed == 0 || vibrato_amount == 0) {
						pattern_bin = append(pattern_bin, VIBRATO_OFF)
					} else {
						pattern_bin = append(pattern_bin, VIBRATO)
						pattern_bin = append(pattern_bin, vibrato_speed | (vibrato_amount << 4))
					}
				
				// legato
				} else if (eff.Effect == 0xea) {

					if (eff.Value > 0){
						pattern_bin = append(pattern_bin, LEGATO_ON)
					} else {
						pattern_bin = append(pattern_bin, LEGATO_OFF)
					}
				
				// order jump
				} else if (eff.Effect == 0x0b) {
					
					pattern_bin = append(pattern_bin, ORDER_JUMP)
					pattern_bin = append(pattern_bin, eff.Value)
				
				// order next
				} else if (eff.Effect == 0x0d) {
					
					pattern_bin = append(pattern_bin, ORDER_NEXT)
				
				// set speed 1
				} else if (eff.Effect == 0x09) {
					
					pattern_bin = append(pattern_bin, SET_SPEED_1)
					pattern_bin = append(pattern_bin, eff.Value * (song.TimeBase + 1))
				
				// set speed 2
				} else if (eff.Effect == 0x0f) {
					
					pattern_bin = append(pattern_bin, SET_SPEED_2)
					pattern_bin = append(pattern_bin, eff.Value * (song.TimeBase + 1))
				
				// noise mode
				} else if (eff.Effect == 0x11) {
					
					pattern_bin = append(pattern_bin, NOISE_MODE)
					pattern_bin = append(pattern_bin, eff.Value)
				
				// note delay
				} else if (eff.Effect == 0xed) {

					pattern_bin = append(pattern_bin, NOTE_DELAY)
					pattern_bin = append(pattern_bin, eff.Value)
				
				// speaker loudness control
				} else if (eff.Effect == 0x20) {

					val := eff.Value

					// convert loudness value
					if val < 2 {
						val = 3 << 1
					} else if val < 4 {
						val = 2 << 1
					} else if val < 8 {
						val = 1 << 1
					} else {
						val = 0 << 1
					}

					pattern_bin = append(pattern_bin, SPEAKER_LOUDNESS)
					pattern_bin = append(pattern_bin, val)
				
				// Panning
				} else if (eff.Effect == 0x80) {

					pattern_bin = append(pattern_bin, PANNING)

					var pan, pan_left, pan_right uint8
					pan = eff.Value

					if (pan == 0x80) {
						pan_left = 0
						pan_right = 0
					} else if (pan < 0x80) {
						pan_left = 0
						pan_right = 0xf - ((pan >> 3) & 0xf)
					} else {
						pan_left = 0xf - (((^pan) >> 3) & 0xf)
						pan_right = 0
					}

					pattern_bin = append(pattern_bin, (pan_left << 4) | (pan_right))

				// Panning
				} else if (eff.Effect == 0x08) {

					pattern_bin = append(pattern_bin, PANNING)
					pattern_bin = append(pattern_bin, (^eff.Value) & 0xff)

				// Panning Left
				} else if (eff.Effect == 0x81) {

					// make into a 4 bit number then into an attenuation
					var pan uint8 
					pan = 15 - (eff.Value >> 4)

					pattern_bin = append(pattern_bin, PANNING_LEFT)
					pattern_bin = append(pattern_bin, pan << 4)

				// Panning Right
				} else if (eff.Effect == 0x82) {

					// make into a 4 bit number then into an attenuation
					var pan uint8 
					pan = 15 - (eff.Value >> 4)

					pattern_bin = append(pattern_bin, PANNING_RIGHT)
					pattern_bin = append(pattern_bin, pan)
				}
			}

			// volume
			// if the volume has been specified on the line, or we haven't provided a volume command yet
			if (line.Volume != 0xff) {

				volume := line.Volume

				// volume has changed
				if volume != current_vol {

					pattern_bin = append(pattern_bin, VOLUME_CHANGE)
					pattern_bin = append(pattern_bin, volume)
				}
				
				current_vol = volume
			}

			// empty
			if (line.Note == 0xff && line.Octave == -1) {

			// note on
			} else if (line.Note >= 0 && line.Note < 12) {

				// sample instrument?
				if (pattern.Channel == 1) && (current_inst != 0xff) && ((song.Instruments[current_inst].Sample.Sample & 0xff) != 0xff) {
					
					sample_ok := true

					note_number := uint8(int8(line.Note) + (line.Octave * 12))
					sample_num := song.Instruments[current_inst].Sample.Sample
					
					// use sample map
					if (song.Instruments[current_inst].Sample.Flags & 0x1) != 0{
						
						// get new sample number
						sample_num = song.Instruments[current_inst].Sample.SampleMap[note_number].Sample

						// don't resample when using sample maps
						note_number = 48

						// sample not found for this note
						if sample_num == 0xffff {
							sample_ok = false
						}

					// check whether this sample exists
					} else {
						if song.SampleCount <= sample_num {
							sample_ok = false
						}
					}

					// resample sample if it's not a C4 note
					if note_number != 48 {

						cache_id := fmt.Sprint(sample_num) + "_" + fmt.Sprint(note_number)
						
						_, cache_check_found := resample_cache[cache_id]

						// has this sample already been generated?
						if cache_check_found {

							sample_num = resample_cache[cache_id]
							print("\tResample_cache lookup " + cache_id + ": " + fmt.Sprint(sample_num) + "\n")
						
						// if not generate it
						} else {

							new_sample := resample(song.Samples[sample_num], note_number)

							song.Samples = append(song.Samples, new_sample)
							song.SampleCount = song.SampleCount + 1
							
							sample_num = song.SampleCount - 1
							resample_cache[cache_id] = sample_num

							print("\tResample_cache add " + cache_id + ": " + fmt.Sprint(sample_num) + "\n")
						}
					}

					if sample_ok {
						pattern_bin = append(pattern_bin, SAMPLE_NOTE_ON)
						pattern_bin = append(pattern_bin, uint8(sample_num))
					}

				} else {

					// add note-on
					pattern_bin = append(pattern_bin, NOTE_ON)
					pattern_bin = append(pattern_bin, uint8(int8(line.Note) + (line.Octave * 12)) & 0x7f)
				}

			// note off
			} else if (line.Note == 100 || line.Note == 101) {

				
				// sample channel & instrument?
				if (pattern.Channel == 1) && (current_inst != 0xff) && ((song.Instruments[current_inst].Sample.Sample & 0xff) != 0xff) {

					pattern_bin = append(pattern_bin, SAMPLE_NOTE_OFF)

				} else {

					pattern_bin = append(pattern_bin, NOTE_OFF)
				
				}
			}

			// check effects which we want to happen post-note
			for _, eff := range line.Effects {

				// note cut
				if (eff.Effect == 0xec) {

					pattern_bin = append(pattern_bin, NOTE_DELAY)
					pattern_bin = append(pattern_bin, eff.Value)

					// sample instrument?
					if (pattern.Channel == 1) && ((song.Instruments[current_inst].Sample.Sample & 0xff) != 0xff) {
						pattern_bin = append(pattern_bin, SAMPLE_NOTE_OFF)
					} else {
						pattern_bin = append(pattern_bin, NOTE_OFF)
					}
				}
			}
			
			// end line marker
			last_i := len(pattern_bin) - 1

			// if skip value > 0, skip value should be -1
			// as this line will count as one of the skips
			skip := line.Skip

			if skip > 0 {
				skip--
			}

			// check if the last byte in pattern_bin is an end line wait
			// if so we can merge the wait times
			if (last_i >= 0) && ((pattern_bin[last_i] & END_LINE) == END_LINE) {
				pattern_bin[last_i] = pattern_bin[last_i] + 1 + skip
			} else {
				pattern_bin = append(pattern_bin, END_LINE | skip)
			}
			
			line_count += uint16(skip) + 1
		}
		
		// wait commands for any remaining lines
		if line_count < song.PatternLength {
		
			// if this pattern is empty add a new wait count
			if len(pattern_bin) == 0 {
				pattern_bin = append(pattern_bin, END_LINE | uint8(song.PatternLength - line_count - 1))
				
			// otherwise add this wait count to the last wait count
			} else {
			
				last_i := len(pattern_bin) - 1
				pattern_bin[last_i] = pattern_bin[last_i] + uint8(song.PatternLength - line_count)
			}
		}
		
		outfile.WriteString(fmt.Sprintf(song_prefix + "_pattern_%v_%v:\n", pattern.Channel, pattern.Index))
		outfile.WriteString(fmt.Sprintf(".byte " + strings.Trim(strings.Replace(fmt.Sprintf("% #x", pattern_bin), " ", ", ", -1 ), "[]") + "\n"))
	}

	outfile.WriteString("\n\n")

    // sample table
    outfile.WriteString(".balign 2\n")
    outfile.WriteString(song_prefix + "_sample_table:\n")

    // ensure the last sample is 0 when the sample is not looping
    for i = 0; i < uint32(len(song.Samples)); i++ {

        if song.Samples[i].LoopStart == 0xffffffff {
            song.Samples[i].Length += 1
            song.Samples[i].Data = append(song.Samples[i].Data, int8(-128))
        }
	}

    // sample table with addresses and lengths
    for i = 0; i < uint32(song.SampleCount); i++ {

        sample := song.Samples[i]

		outfile.WriteString(song_prefix + "_sample_" + fmt.Sprint(i) + ":\n")
        outfile.WriteString("\t.long " + song_prefix + "_sample_data_" + fmt.Sprint(i) + "\n")
        outfile.WriteString("\t.long " + fmt.Sprint(sample.Length) + "\n")

        sample_flags := "WS_SDMA_CTRL_ENABLE"

        if sample.LoopStart != 0xffffffff {
            sample_flags += " | WS_SDMA_CTRL_REPEAT"
		}

        if sample.C4Rate >= 18000 {
            sample_flags = sample_flags + " | WS_SDMA_CTRL_RATE_24000"
		} else if sample.C4Rate >= 9000 {
            sample_flags = sample_flags + " | WS_SDMA_CTRL_RATE_12000"
		} else if sample.C4Rate >= 5000 {
            sample_flags = sample_flags + " | WS_SDMA_CTRL_RATE_6000"
		} else {
            sample_flags = sample_flags + " | WS_SDMA_CTRL_RATE_4000"
		}

        outfile.WriteString("\t.byte " + sample_flags + "\n")

        outfile.WriteString("\t.byte 0xff #pad\n")
	}

	outfile.WriteString("\n\n")

	// open sample data section
    outfile.WriteString(".section ." + sample_data_prefix + "." + song_prefix + "_samples, \"a\"\n")
    outfile.WriteString("\n")

	// raw sample data
	outfile.WriteString(song_prefix + "_sample_data:\n")

    sample_size_total := 0

    for i, sample := range song.Samples {

        outfile.WriteString(song_prefix + "_sample_data_" + fmt.Sprint(i) + ":\n")

		// write out sample data in 32 byte chunks
        for j := 0; j < len(sample.Data); j += 32 {

			j_end := j + 32

			// ensure we don't read data from outside of array bounds
			if j_end > len(sample.Data) {
				j_end = j + (len(sample.Data) - j)
			}

			// convert data from int8 -> uint8
			samples_u := []uint8{}

			for k := j; k < j_end; k++ {

				val := int16(sample.Data[k].(int8)) + 128

				if val > 255 {
					val = 255
				}

				samples_u = append(samples_u, uint8(val))
			}

			outfile.WriteString(fmt.Sprintf(".byte " + strings.Trim(strings.Replace(fmt.Sprintf("%v", samples_u), " ", ", ", -1 ), "[]") + "\n"))
		}

        sample_size_total += len(sample.Data)

		outfile.WriteString("\n")
	}

    print(" samples: " + fmt.Sprint(song.SampleCount) + " samples\n")
    print(" samples size: " + fmt.Sprint(sample_size_total) + " bytes\n")
}
