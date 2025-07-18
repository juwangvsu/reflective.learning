# given verified from last cycle , assume verified$1.json
# usage $@ 3|4
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 num unique960"
  exit 1
fi

echo $1
cnum=$1
next=$1

if [ "$1" -ge 10 ]; then
  echo "The number is greater than 10."
  cnum=10
  next=$cnum
else
  echo "The number is not greater than 10."
  ((next++))
fi

#((next++))
echo "preprocess input verified${cnum}_$2.json"
echo "		output verified${cnum}_$2_preproces.json"
echo "train input verified${cnum}_$2_preproces.json"
echo "		checkpoint/mp_model${next}_$2.pth"
echo "predict input seed_$2_preproces.json"
echo "		output predicted${next}_$2.json"
echo "		checkpoint/mp_model${next}_$2.pth"
echo "verify  input predicted${next}_$2.json"
echo "		output verified${next}_$2.json"
echo "filter3 input verified${next}_$2.json"
echo "		output verified${next}_$2_noprefix.json"
#exit 0
echo -e "current succ rate "

echo -e "\n\n\n****************************run preprocess on verified *********************************"
python3 -m reflective_learning.tools.main preprocess --input verified${cnum}_$2.json --mapping ../jack_bot/motion_path/mapping_state16.txt --output verified${cnum}_$2_preprocess.json  --context-dir context --image seed_image

echo -e "\n run check result"
grep state verified${cnum}\_$2\_noprefix.json|grep -v "\"16" | wc

echo -e "\n\n\n****************************run train *********************************"
python3 -m reflective_learning.tools.main train --input verified${cnum}_$2_preprocess.json --mapping ../jack_bot/motion_path/mapping_state16.txt --save-path checkpoint/mp_model${next}_$2.pth

echo -e "\n run predict"
python3 -m reflective_learning.tools.mini --mode predict --input seed_$2_preprocess.json --output predicted${next}_$2.json --model reflective --state-weights "0=0.1,1=0.1,2=0.1,3=0.1,4=0.1,5=0.1,6=0.1,7=0.1,8=0.1,9=0.1,10=0.1,11=0.1,12=0.1,13=0.1,14=0.1,15=0.01" --checkpoint checkpoint/mp_model${next}_$2.pth --max-success-steps 15

echo -e "\n run verify"
python3 -m reflective_learning.tools.mini --mode verify --input predicted${next}_$2.json --output verified${next}_$2.json --image seed_image --max-success-steps 15

echo -e "\n run filter"
python3 filter3.py --filename verified${next}_$2.json

echo -e "\n run check result"
grep state verified${next}\_$2\_noprefix.json|grep -v "\"16"|wc


