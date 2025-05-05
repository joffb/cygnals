python3 ../furnace2json.py -o ./cmajor_sn.json "TABLES.fur"
python3 ../json2ws.py -o src/cmajor_sn.s -i cmajor_sn ./cmajor_sn.json 

python3 ../furnace2json.py -o ./sfx_test.json sfx_test_sample.fur
python3 ../json2ws.py --sfx 2 -o src/sfx_test.s -i sfx_test ./sfx_test.json 
