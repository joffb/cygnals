const fs = require('fs');
let out_sdas = fs.openSync("src/sound_driver_note_table.s", "w+");

fs.writeSync(out_sdas, '#include <wonderful.h>\n');
fs.writeSync(out_sdas, '#include <ws.h>\n');
fs.writeSync(out_sdas, '#include "cygnals.h"\n');
fs.writeSync(out_sdas, '\n');
fs.writeSync(out_sdas, '.code16\n');
fs.writeSync(out_sdas, '.arch i186\n');
fs.writeSync(out_sdas, '.intel_syntax noprefix\n');
fs.writeSync(out_sdas, '\n');
fs.writeSync(out_sdas, '.global sound_note_table\n');
fs.writeSync(out_sdas, '\n');
fs.writeSync(out_sdas, '.section .text.sound_driver\n');
fs.writeSync(out_sdas, '\n');
fs.writeSync(out_sdas, 'sound_note_table:\n');

// each note
for (var i = 24; i < 128; i++)
{
    fs.writeSync(out_sdas, "# note " + i + "\n");

    // 32 steps per note
    for (var j = 0; j < 32; j++)
    {
        // calculate the frequency of the note in hz
        frequency = Math.pow(2, (i + (j / 32.0) - 69.0) / 12.0) * 440.0;

        // calculate the value for the wonderswan registers which will result in this frequency
        wswan_frequency = Math.floor(((2048.0 * frequency) - 96000.0) / frequency);

        if (wswan_frequency < 88)
        {
            wswan_frequency = 88;
        }

        if (wswan_frequency > 2040)
        {
            wswan_frequency = 2040;
        }

        fs.writeSync(out_sdas, ".short " + wswan_frequency + "\n");
    }
}

fs.closeSync(out_sdas);