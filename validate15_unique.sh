# usage: $@ unique960
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <argument1> "
  exit 1
fi
echo $1
echo "predict input seed_$1_preprocess.json"
echo "          output predicted1_$1.json"
echo "  	model  mp_model_$1.pth"
echo "verify     input predicted1_$1.json"
echo "          output verified1_$1.json"
echo "filter3          input verified1_$1.json"
echo "          output verified1_$1_noprefix.json"
echo -e "\n run predict"
python3 -m reflective_learning.tools.mini --mode predict --input seed_$1_preprocess.json --output predicted1_$1.json --model reflective --state-weights "0=0.1,1=0.1,2=0.1,3=0.1,4=0.1,5=0.1,6=0.1,7=0.1,8=0.1,9=0.1,10=0.1,11=0.1,12=0.1,13=0.1,14=0.1,15=0.02" --checkpoint checkpoint/mp_model_$1.pth --max-success-steps 15

echo -e "\n run verify"
python3 -m reflective_learning.tools.mini --mode verify --input predicted1_$1.json --output verified1_$1.json --image stub_image --max-success-steps 15
python3 filter3.py --filename verified1_$1.json

grep state verified1_$1_noprefix.json|grep -v "\"16"|wc
