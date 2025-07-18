echo -e "\n run predict"
python3 -m reflective_learning.tools.mini --mode predict --input seed_preprocess.json --output predicted1.json --model reflective --state-weights "0=0.1,1=0.1,2=0.1,3=0.1,4=0.1,5=0.1,6=0.1,7=0.1,8=0.1,9=0.1,10=0.1,11=0.1,12=0.1,13=0.1,14=0.1,15=0.02" --checkpoint checkpoint/mp_model.pth --max-success-steps 15

echo -e "\n run verify"
python3 -m reflective_learning.tools.mini --mode verify --input predicted1.json --output verified1.json --image stub_image --max-success-steps 15
python3 filter3.py --filename verified1.json

grep state verified1_noprefix.json|grep -v "\"16"|wc
