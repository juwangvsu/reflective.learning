rm -rf seed_image
python3 -m src.reflective_learning.tools.mini --mode seed --output seed.json --samples 50000 --image seed_image --max-success-steps 15
python3 -m reflective_learning.tools.main preprocess --input seed.json --mapping ../jack_bot/motion_path/mapping_state16.txt --output seed_preprocess.json  --context-dir context --image seed_image
python3 -m reflective_learning.tools.main train --input seed_preprocess.json --mapping ../jack_bot/motion_path/mapping_state16.txt --save-path checkpoint/mp_model.pth
