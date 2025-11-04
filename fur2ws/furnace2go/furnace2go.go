
// furnace2go
// Joe Kennedy 2025

package furnace2go

import (
	"io"
	"os"
	//"log"
	"fmt"
	//"bytes"
	"compress/zlib"
	"encoding/binary"
	//"encoding/json"
)

var chip_channels = map[uint8]uint8 {
	0x00:  0, // end of list
	0x01: 17, // YMU759 - 17 channels
	0x02: 10, // Genesis - 10 channels (compound!)
	0x03:  4, // SMS (SN76489) - 4 channels
	0x04:  4, // Game Boy - 4 channels
	0x05:  6, // PC Engine - 6 channels
	0x06:  5, // NES - 5 channels
	0x07:  3, // C64 (8580) - 3 channels
	0x08: 13, // Arcade (YM2151+SegaPCM) - 13 channels (compound!)
	0x09: 13, // Neo Geo CD (YM2610) - 13 channels
	0x42: 13, // Genesis extended - 13 channels
	0x43: 13, // SMS (SN76489) + OPLL (YM2413) - 13 channels (compound!)
	0x46: 11, // NES + VRC7 - 11 channels (compound!)
	0x47:  3, // C64 (6581) - 3 channels
	0x49: 16, // Neo Geo CD extended - 16 channels
	0x80:  3, // AY-3-8910 - 3 channels
	0x81:  4, // Amiga - 4 channels
	0x82:  8, // YM2151 - 8 channels
	0x83:  6, // YM2612 - 6 channels
	0x84:  2, // TIA - 2 channels
	0x85:  4, // VIC-20 - 4 channels
	0x86:  1, // PET - 1 channel
	0x87:  8, // SNES - 8 channels
	0x88:  3, // VRC6 - 3 channels
	0x89:  9, // OPLL (YM2413) - 9 channels
	0x8a:  1, // FDS - 1 channel
	0x8b:  3, // MMC5 - 3 channels
	0x8c:  8, // Namco 163 - 8 channels
	0x8d:  6, // YM2203 - 6 channels
	0x8e: 16, // YM2608 - 16 channels
	0x8f:  9, // OPL (YM3526) - 9 channels
	0x90:  9, // OPL2 (YM3812) - 9 channels
	0x91: 18, // OPL3 (YMF262) - 18 channels
	0x92: 28, // MultiPCM - 28 channels (UNAVAILABLE)
	0x93:  1, // Intel 8253 (beeper) - 1 channel
	0x94:  4, // POKEY - 4 channels
	0x95:  8, // RF5C68 - 8 channels
	0x96:  4, // WonderSwan - 4 channels
	0x97:  6, // Philips SAA1099 - 6 channels
	0x98:  8, // OPZ (YM2414) - 8 channels
	0x99:  1, // Pokemon Mini - 1 channel
	0x9a:  3, // AY8930 - 3 channels
	0x9b: 16, // SegaPCM - 16 channels
	0x9c:  6, // Virtual Boy - 6 channels
	0x9d:  6, // VRC7 - 6 channels
	0x9e: 16, // YM2610B - 16 channels
	0x9f:  6, // ZX Spectrum (beeper, tildearrow engine) - 6 channels
	0xa0:  9, // YM2612 extended - 9 channels
	0xa1:  5, // Konami SCC - 5 channels
	0xa2: 11, // OPL drums (YM3526) - 11 channels
	0xa3: 11, // OPL2 drums (YM3812) - 11 channels
	0xa4: 20, // OPL3 drums (YMF262) - 20 channels
	0xa5: 14, // Neo Geo (YM2610) - 14 channels
	0xa6: 17, // Neo Geo extended (YM2610) - 17 channels
	0xa7: 11, // OPLL drums (YM2413) - 11 channels
	0xa8:  4, // Atari Lynx - 4 channels
	0xa9:  5, // SegaPCM (for DefleMask compatibility) - 5 channels
	0xaa:  4, // MSM6295 - 4 channels
	0xab:  1, // MSM6258 - 1 channel
	0xac: 17, // Commander X16 (VERA) - 17 channels
	0xad:  2, // Bubble System WSG - 2 channels
	0xae: 42, // OPL4 (YMF278B) - 42 channels (UNAVAILABLE)
	0xaf: 44, // OPL4 drums (YMF278B) - 44 channels (UNAVAILABLE)
	0xb0: 16, // Seta/Allumer X1-010 - 16 channels
	0xb1: 32, // Ensoniq ES5506 - 32 channels
	0xb2: 10, // Yamaha Y8950 - 10 channels
	0xb3: 12, // Yamaha Y8950 drums - 12 channels
	0xb4:  5, // Konami SCC+ - 5 channels
	0xb5:  8, // tildearrow Sound Unit - 8 channels
	0xb6:  9, // YM2203 extended - 9 channels
	0xb7: 19, // YM2608 extended - 19 channels
	0xb8:  8, // YMZ280B - 8 channels
	0xb9:  3, // Namco WSG - 3 channels
	0xba:  8, // Namco C15 - 8 channels
	0xbb:  8, // Namco C30 - 8 channels
	0xbc:  8, // MSM5232 - 8 channels
	0xbd: 11, // YM2612 DualPCM extended - 11 channels
	0xbe:  7, // YM2612 DualPCM - 7 channels
	0xbf:  4, // T6W28 - 4 channels
	0xc0:  1, // PCM DAC - 1 channel
	0xc1: 10, // YM2612 CSM - 10 channels
	0xc2: 18, // Neo Geo CSM (YM2610) - 18 channels (UNAVAILABLE)
	0xc3: 10, // YM2203 CSM - 10 channels (UNAVAILABLE)
	0xc4: 20, // YM2608 CSM - 20 channels (UNAVAILABLE)
	0xc5: 20, // YM2610B CSM - 20 channels (UNAVAILABLE)
	0xc6:  2, // K007232 - 2 channels
	0xc7:  4, // GA20 - 4 channels
	0xc8:  3, // SM8521 - 3 channels
	0xc9: 16, // M114S - 16 channels (UNAVAILABLE)
	0xca:  5, // ZX Spectrum (beeper, QuadTone engine) - 5 channels
	0xcb:  3, // Casio PV-1000 - 3 channels
	0xcc:  4, // K053260 - 4 channels
	0xcd:  2, // TED - 2 channels
	0xce: 24, // Namco C140 - 24 channels
	0xcf: 16, // Namco C219 - 16 channels
	0xd0: 32, // Namco C352 - 32 channels (UNAVAILABLE)
	0xd1: 18, // ESFM - 18 channels
	0xd2: 32, // Ensoniq ES5503 (hard pan) - 32 channels (UNAVAILABLE)
	0xd4:  4, // PowerNoise - 4 channels
	0xde: 19, // YM2610B extended - 19 channels
	0xe0: 19, // QSound - 19 channels
	0xfc:  1, // Pong - 1 channel
	0xfd:  8, // Dummy System - 8 channels
	0xfe:  0, // reserved for development
	0xff:  0, // reserved for development
}


type Song struct {

    FormatVersion uint16
    SongInfoPointer uint32
    SongName string
    SongAuthor string

    TimeBase uint8
    Speed1 uint8
    Speed2 uint8
    TicsPerSecond float32

    PatternLength uint16
    OrdersLength uint16

    SoundChips []byte
    ChannelCount uint8

    InstrumentCount uint16
    InstrumentPointers []uint32
    Instruments []Instrument

    WavetableCount uint16
    WavetablePointers []uint32
    Wavetables []Wavetable

    SampleCount uint16
    SamplePointers []uint32
    Samples []Sample

    PatternCount uint32
    PatternPointers []uint32
    Patterns []Pattern

    Orders [][]uint8
}

type Macro struct {
	Code uint8
	Length uint8
	Loop uint8
	Release uint8
	Mode uint8
	Info uint8
	Delay uint8
	Speed uint8
	Data []any
}

type InstSampleMap struct {
	Note uint16
	Sample uint16
}

type InstSample struct {
	Sample uint16
	Flags uint8
	Length uint8
	SampleMap []InstSampleMap
}

type Instrument struct {
    Name string
    InstType uint16
	Sample InstSample
    Macros []Macro
}

type Wavetable struct {
    Name string
    Width uint32
    Data []uint32
}

type Sample struct {
    Name string
    Length uint32
    CompatRate uint32
    C4Rate uint32
    Depth uint8
    LoopDir uint8
	Flags1 uint8
	Flags2 uint8
    LoopStart uint32
    LoopEnd uint32
    Data []any   
}

type Line struct {
	Note uint8
	Octave int8
	Instrument uint8
	Volume uint8
	Skip uint8
	Effects []Effect
}

type Effect struct {
	Effect uint8
	Value uint8
}

type Pattern struct {
	Name string
	Channel uint8
	Index uint16
	Lines []Line
}

func Convert(filename string) (song Song) {

	var i, j, k uint32
	var p, r uint32
	var data []byte
	var err error

	// read furnace file
	infile, err := os.Open(filename)
	
	if err != nil {
		panic(err)
	}
	
	// get first byte
	buffer := make([]byte, 1)
	io.ReadFull(infile, buffer)
	
	// return reader to start of file
	infile.Seek(0,0)
	
	// does it need to be zlib decompressed?
	if (buffer[0] == 0x78) {
	
		fmt.Print("furnace file is compressed\n")
	
		// read file and zlib decompress
		zr, err := zlib.NewReader(infile)
		
		if err != nil {
			panic(err)
		}
		
		// read decompressed data
		data, err = io.ReadAll(zr)
		
		if err != nil {
			panic(err)
		}
		
	} else {
	
		fmt.Print("furnace file is not compressed\n")
	
		// not compressed, read data straight from file
		data, err = io.ReadAll(infile)
		
		if err != nil {
			panic(err)
		}

	}
	
	fmt.Printf("read %v bytes\n", len(data))
	
	infile.Close()
	
	// ensure this is a valid furnace file
	if (string(data[0:16]) != "-Furnace module-") {
		panic("invalid file type")
	}
	
	song.FormatVersion = binary.LittleEndian.Uint16(data[16:20])
	song.SongInfoPointer = binary.LittleEndian.Uint32(data[20:24])
	
	if song.FormatVersion < 157 {
		panic("furnace file format versions < 157 are not supported")
	}
	
	// skip "INFO" and block size
	p = song.SongInfoPointer + 8
	song.TimeBase = uint8(data[p])
	song.Speed1 = uint8(data[p + 1])
	song.Speed2 = uint8(data[p + 2])
	p += 4
	
	// tics per second
	binary.Decode(data[p:p+4], binary.LittleEndian, &song.TicsPerSecond)
	p += 4
	
	// pattern length
	binary.Decode(data[p:p+2], binary.LittleEndian, &song.PatternLength)
	p += 2
	
	// orders length
	binary.Decode(data[p:p+2], binary.LittleEndian, &song.OrdersLength)
	p += 2
	
	// skip highlight a/b
	p += 2
	
	// instrument_count
	binary.Decode(data[p:p+2], binary.LittleEndian, &song.InstrumentCount)
	p += 2
	
	// wavetable_count
	binary.Decode(data[p:p+2], binary.LittleEndian, &song.WavetableCount)
	p += 2
	
	// sample_count
	binary.Decode(data[p:p+2], binary.LittleEndian, &song.SampleCount)
	p += 2

	// pattern_count
	binary.Decode(data[p:p+4], binary.LittleEndian, &song.PatternCount)
	p += 4
	
	// sound chips
	song.SoundChips = data[p:p+32]
	p += 32
	
	song.ChannelCount = 0
	
	for i = 0; i < 32; i++ {
	
		if song.SoundChips[i] == 0 {
			break;
		}
		
		song.ChannelCount += chip_channels[song.SoundChips[i]]
	}
	
	// skip sound chip volumes, sound chip panning, sound chip flag pointers
	p += 32
	p += 32
	p += 128
	
	// song name
	r = p
	for (data[r] != 0) {
		r += 1
	}
	
	song.SongName = string(data[p:r])
	p = r + 1
	
	// song author
	r = p
	for (data[r] != 0) {
		r += 1
	}
	
	song.SongAuthor = string(data[p:r])
	p = r + 1
	
	// skip A-4 tuning and flags
	p += 24
		
	// instrument pointers
	for i = 0; i < uint32(song.InstrumentCount); i++ {
		song.InstrumentPointers = append(song.InstrumentPointers, binary.LittleEndian.Uint32(data[p:p+4]))
		p += 4
	}
	
	// wavetable pointers
	for i = 0; i < uint32(song.WavetableCount); i++ {
		song.WavetablePointers = append(song.WavetablePointers, binary.LittleEndian.Uint32(data[p:p+4]))
		p += 4
	}
	
	// sample pointers
	for i = 0; i < uint32(song.SampleCount); i++ {
		song.SamplePointers = append(song.SamplePointers, binary.LittleEndian.Uint32(data[p:p+4]))
		p += 4
	}
	
	// pattern pointers
	for i = 0; i < uint32(song.PatternCount); i++ {
		song.PatternPointers = append(song.PatternPointers, binary.LittleEndian.Uint32(data[p:p+4]))
		p += 4
	}

	// orders
    for i = 0; i < uint32(song.ChannelCount); i++ {
        order_array_start := p
        order_array_end := p + uint32(song.OrdersLength)
        song.Orders = append(song.Orders, data[order_array_start:order_array_end])
		
		p = order_array_end
	}
	
	// load instruments (>= v127)
	for i = 0; i < uint32(song.InstrumentCount); i++ {
	
		var ins Instrument
		var ins_end uint32
		
		ins.Sample = InstSample{Sample: 0xffff, Flags: 0, Length: 0}

        p = song.InstrumentPointers[i]
		
		// instrument header
		// skip "INS2"
		p += 4
		
		// get address of end of instrument data by adding instrument size to the instrument pointer
		ins_end = song.InstrumentPointers[i] + binary.LittleEndian.Uint32(data[p:p+4])
		p += 4
		
		// skip format version
		p += 2
		
		// instrument type
		ins.InstType = binary.LittleEndian.Uint16(data[p:p+2])
		p += 2
		
		// start reading features
		for (p < ins_end) {
			
			// get feature code and length
			feature_code := string(data[p:p+2])
			feature_length := binary.LittleEndian.Uint16(data[p+2:p+4])
			p += 4
			
			// end of features
			if (feature_code == "EN") {
				break;
				
			// name
			} else if (feature_code == "NA") {
				
				// read string
				r = p
				
				for (data[r] != 0) {
					r++
				}
				
				ins.Name = string(data[p:r])
				
				p = r + 1
				
			// sample ins data
			} else if (feature_code == "SM") {
				
				// initial sample
				binary.Decode(data[p:p+2], binary.LittleEndian, &ins.Sample.Sample)
				p += 2
				
				// sample flags
				ins.Sample.Flags = data[p]
				p++
				
				// "waveform length"
				ins.Sample.Length = data[p]
				p++
				
				// sample map?
				if (ins.Sample.Flags & 0x1) != 0 {
					
					for j = 0; j < 120; j++ {
					
						// load sample map entry
						var entry InstSampleMap
						
						// note
						binary.Decode(data[p:p+2], binary.LittleEndian, &entry.Note)
						p += 2
						
						// sample
						binary.Decode(data[p:p+2], binary.LittleEndian, &entry.Sample)
						p += 2
						
						ins.Sample.SampleMap = append(ins.Sample.SampleMap, entry)
					}
				}
				
			// macros
			} else if (feature_code == "MA") {
								
				macros_end := p + 2 + uint32(feature_length)

				// skip macros header length
				p += 2

				for p < macros_end {

					var macro Macro

					// load properties
					macro.Code = data[p+0]
					
					if macro.Code == 255 {
						p++
						break
					}

					macro.Length = data[p+1]
					macro.Loop = data[p+2]
					macro.Release = data[p+3]
					macro.Mode = data[p+4]
					macro.Info = data[p+5]
					macro.Delay = data[p+6]
					macro.Speed = data[p+7]
					p += 8

					// load data
					for j = 0; j < uint32(macro.Length); j++ {
						
						switch ((macro.Info >> 6) & 0x3) {
							case 0:
								macro.Data = append(macro.Data, uint8(data[p]))
								p++
							case 1:
								macro.Data = append(macro.Data, int8(data[p]))
								p++
							case 2:
								macro.Data = append(macro.Data, int16(binary.LittleEndian.Uint16(data[p:p+2])))
								p+=2
							case 3:
								macro.Data = append(macro.Data, int32(binary.LittleEndian.Uint32(data[p:p+4])))
								p+=4
						}
						
					}
					
					ins.Macros = append(ins.Macros, macro)
				}
				
			// skip past other features
			} else {
			
			
				p += uint32(feature_length)
			}
		}
		
		// add instrument to song
		song.Instruments = append(song.Instruments, ins)
	}

    // load wavetables
    for i = 0; i < uint32(song.WavetableCount); i++ {

        var wt Wavetable

        p = song.WavetablePointers[i]

        // skip "WAVE" and size
        p += 4
        p += 4

        // read name string
        r = p

        for (data[r] != 0) {
            r++
        }

        wt.Name = string(data[p:r])

        p = r + 1

        // wavetable width
        wt.Width = binary.LittleEndian.Uint32(data[p:p+4])
        p += 4

        // skip reserved and height
        p += 4
        p += 4

        // load data
        for j = 0; j < wt.Width; j ++ {
            wt.Data = append(wt.Data, binary.LittleEndian.Uint32(data[p:p+4]))
            p += 4
        }

		// add wavetable to song
        song.Wavetables = append(song.Wavetables, wt)
    }

    // load samples
    for i = 0; i < uint32(song.SampleCount); i++ {

        var sa Sample

        p = song.SamplePointers[i]

        // skip "SMP2" and size
        p += 4
        p += 4

        // read name string
        r = p

        for (data[r] != 0) {
            r++
        }

        sa.Name = string(data[p:r])

        p = r + 1

        // sample length
        sa.Length = binary.LittleEndian.Uint32(data[p:p+4])
        p += 4

        // compatibility rate
        sa.CompatRate = binary.LittleEndian.Uint32(data[p:p+4])
        p += 4

        // c4 rate
        sa.C4Rate = binary.LittleEndian.Uint32(data[p:p+4])
        p += 4

        // depth
        sa.Depth = data[p]
        p += 1

        // loop direction
        sa.LoopDir = data[p]
        p += 1

        // flags
		sa.Flags1 = data[p]
		sa.Flags2 = data[p+1]
        p += 2

        // loop start
        sa.LoopStart = binary.LittleEndian.Uint32(data[p:p+4])
        p += 4
 
        // loop end
        sa.LoopEnd = binary.LittleEndian.Uint32(data[p:p+4])
        p += 4 

        // skip sample presence bitfields
        p += 16    

        // load data
        for j = 0; j < sa.Length; j ++ {
            
            // 16 bit samples
            if sa.Depth == 14 || sa.Depth == 16 {

                sa.Data = append(sa.Data, int16(binary.LittleEndian.Uint16(data[p:p+2])))
                p += 2

            // 8 bit samples
            } else {

                sa.Data = append(sa.Data, int8(data[p]))
                p += 1

            }
        }

		// add sample to song
        song.Samples = append(song.Samples, sa)
    }
	
	// load patterns
	for i = 0; i < song.PatternCount; i++ {
		
		var pat Pattern
		
		p = song.PatternPointers[i]
		
		// skip "PATN"
		p += 4
		
		// pattern size
		pat_end := song.PatternPointers[i] + 8 + binary.LittleEndian.Uint32(data[p:p+4])
		p += 4
		
		// skip subsong
		p++
		
		// channel
		pat.Channel = data[p]
		p++
		
		// index
		binary.Decode(data[p:p+2], binary.LittleEndian, &pat.Index)
		p += 2
		
        // read name string
        r = p

        for (data[r] != 0) {
            r++
        }

        pat.Name = string(data[p:r])

        p = r + 1
		
		// read pattern data
		for p < pat_end {
		
			// get next byte
			read_byte := data[p]
			p++
			
			// done
			if (read_byte == 0xff) {
				break
			}
			
			line := Line{ Note: 0xff, Octave: -1, Instrument: 0xff, Volume: 0xff, Skip:0}
			
			// if bit 7 is set, then read bit 0-6 as "skip N+2 rows".
			if ((read_byte & 0x80) != 0) {
			
				line.Skip = (read_byte & 0x7f) + 2
				
			// this line has something on it
			} else {
			
				// read the extra effect bytes if they're present
				//
				// - if bit 5 is set, read another byte:
				// extra effects 0-3
				// - if bit 6 is set, read another byte:
				// extra effects 4-7
				var effect_bytes []byte
				var extra_effect_byte_count uint32 = 0

				if ((read_byte & 0x20) != 0) {
					extra_effect_byte_count += 1
				}

				if ((read_byte & 0x40) != 0) {
					extra_effect_byte_count += 1
				}

				// get effect specification bytes
				effect_bytes = data[p:p + extra_effect_byte_count]
				p += extra_effect_byte_count

				// bit 0: note present
				if ((read_byte & 0x1) != 0) {

					line.Note = data[p]
					p++

					// convert note data to version compatible with older (< 157) pattern
					if ((line.Note >= 0) && (line.Note < 180)) {

						line.Octave = int8(line.Note / 12) - 5
						line.Note = line.Note % 12

					} else {

						line.Note = line.Note - 80
						
					}
					
				}

				// bit 1: ins present
				if ((read_byte & 0x2) != 0) {

					line.Instrument = data[p]
					p++
				
				}

				// bit 2: volume present
				if ((read_byte & 0x4) != 0) {

					line.Volume = data[p]
					p++
					
				}

				// if bit 5 is present, we'll get the bytes for effect 0 at the next stage
				// otherwise load effect 0 now if it's present
				if ((read_byte & 0x20) == 0) {
				
					var eff Effect = Effect{Effect: 0xff, Value: 0}
					var effect_valid = false

					// bit 3: effect 0 present
					// bit 4: effect value 0 present
					if (((read_byte & 0x8) != 0) && ((read_byte & 0x10) != 0)) {
					
						effect_valid = true

						eff.Effect = data[p]
						eff.Value = data[p+1]
						p += 2
					
					} else if ((read_byte & 0x8) != 0) {

						effect_valid = true
						
						eff.Effect = data[p]
						p++

					} else if ((read_byte & 0x10) != 0) {

						// ignore effects which are value-only
						p++
						
					}
					
					if effect_valid {
						line.Effects = append(line.Effects, eff)
					}
				}


				// get effect data
				for j = 0; j < extra_effect_byte_count; j++ {

					// byte says which extra effects are in use
					fx_byte := effect_bytes[j]

					// parse them in pairs
					for k = 0; k < 8; k += 2 {
					
						var eff Effect = Effect{Effect: 0xff, Value: 0}
						var effect_valid = true

						// bit 0: effect number present
						// bit 1: effect value present
						if ((fx_byte & 0x3) == 0x3) {

							effect_valid = true

							eff.Effect = data[p]
							eff.Value = data[p+1]
							p += 2

						} else if ((fx_byte & 0x1) != 0) {

							effect_valid = true

							eff.Effect = data[p]
							p++
							
						} else if ((fx_byte & 0x2) != 0) {
					
							// ignore effects which are value-only
							p++
							
						}

						if effect_valid {
							line.Effects = append(line.Effects, eff)
						}

						fx_byte = fx_byte >> 2
					}
				}
			}
			
			// append completed line
			pat.Lines = append(pat.Lines, line)
			
		}

		song.Patterns = append(song.Patterns, pat)
	}
	
	return song
}
