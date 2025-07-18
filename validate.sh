python3 -m reflective_learning.tools.mini --mode predict --input seed_preprocess.json --output predicted.json --model reflective --state-weights "0=0.1,1=0.1,2=0.1,3=0.1,4=0.1,5=0.1,6=0.1,7=0.1,8=0.1,9=0.02" --checkpoint checkpoint/mp_model.pth --max-success-steps 8
python3 -m reflective_learning.tools.mini --mode verify --input predicted.json --output verified.json --image stub_image --max-success-steps 8
python3 filter3.py --filename verified.json
