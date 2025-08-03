python3 ../json2ws.py -o src/cmajor_sna.s -i cmajor_sn ./TABLES.fur -j test.json
python3 ../json2ws.py -o src/test.s -i cmajor_sn ./test.fur -j test.json
python3 ../json2ws.py --sfx 2 -o src/sfx_test.s -i sfx_test ./sfx_test_sample.fur 
