#generate predict and retrain with predicted dataset
rm -rf stub_image

echo -e "\n\n\n****************************run stub *********************************"
python3 -m src.reflective_learning.tools.mini --mode stub --output stub.json --samples 50000 --image stub_image --max-success-steps 15

echo -e "\n\n\n****************************run prefix *********************************"
python3 -m reflective_learning.tools.main preprocess --input stub.json --mapping ../jack_bot/motion_path/mapping_state16.txt --output stub_preprocess.json  --context-dir context --image stub_image --prefix-only

echo -e "\n\n\n****************************run predict *********************************"
python3 -m reflective_learning.tools.mini --mode predict --input stub_preprocess.json --output predicted.json --model reflective --state-weights "0=0.1,1=0.1,2=0.1,3=0.1,4=0.1,5=0.1,6=0.1,7=0.1,8=0.1,9=0.1,10=0.1,11=0.1,12=0.1,13=0.1,14=0.1,15=0.01" --checkpoint checkpoint/mp_model.pth --max-success-steps 15

echo -e "\n\n\n****************************run verify *********************************"
python3 -m reflective_learning.tools.mini --mode verify --input predicted.json --output verified.json --image stub_image --max-success-steps 15

echo -e "\n\n\n****************************run verify filter*********************************"
python3 filter3.py --filename verified.json

echo -e "\n\n\n****************************run preprocess on verified *********************************"
python3 -m reflective_learning.tools.main preprocess --input verified.json --mapping ../jack_bot/motion_path/mapping_state16.txt --output verified_preprocess.json  --context-dir context --image stub_image 

python3 filter3.py --filename verified_preprocess.json

echo -e "\n\n\n****************************run train *********************************"
python3 -m reflective_learning.tools.main train --input verified_preprocess.json --mapping ../jack_bot/motion_path/mapping_state16.txt --save-path checkpoint/mp_model2.pth
