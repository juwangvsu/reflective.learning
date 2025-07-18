# usage $@ unique960
echo $1
echo "preprocess input seed_$1.json"
echo "		output seed_$1_preprocess.json"
echo "train	input seed_$1_preprocess.json"
echo "	model output mp_model_$1.pth"
rm -rf seed_unique_image
#python3 -m src.reflective_learning.tools.mini --mode seed --output seed.json --samples 50000 --image seed_image --max-success-steps 15
python3 -m reflective_learning.tools.main preprocess --input seed_$1.json --mapping ../jack_bot/motion_path/mapping_state16.txt --output seed_$1_preprocess.json  --context-dir context --image seed_image
python3 -m reflective_learning.tools.main train --input seed_$1_preprocess.json --mapping ../jack_bot/motion_path/mapping_state16.txt --save-path checkpoint/mp_model_$1.pth
