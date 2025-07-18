# given verified from last cycle , assume verified$1.json
# usage $@ 3|4
echo $1
next=$1
((next++))
echo "current verified$1.json"
echo "generate (next) : "
echo verified$1_preproces.json
echo checkpoint/mp_model$next.pth
echo "verified$next.json"
echo verified$next\_noprefix.json
#exit 0
echo -e "current succ rate "

echo -e "\n\n\n****************************run preprocess on verified *********************************"
python3 -m reflective_learning.tools.main preprocess --input verified$1.json --mapping ../jack_bot/motion_path/mapping_state16.txt --output verified$1_preprocess.json  --context-dir context --image seed_image

echo -e "\n run check result"
grep state verified$1\_noprefix.json|grep -v "\"16" | wc

echo -e "\n\n\n****************************run train *********************************"
python3 -m reflective_learning.tools.main train --input verified$1_preprocess.json --mapping ../jack_bot/motion_path/mapping_state16.txt --save-path checkpoint/mp_model$next.pth

echo -e "\n run predict"
python3 -m reflective_learning.tools.mini --mode predict --input seed_preprocess.json --output predicted$next.json --model reflective --state-weights "0=0.1,1=0.1,2=0.1,3=0.1,4=0.1,5=0.1,6=0.1,7=0.1,8=0.1,9=0.1,10=0.1,11=0.1,12=0.1,13=0.1,14=0.1,15=0.01" --checkpoint checkpoint/mp_model$next.pth --max-success-steps 15

echo -e "\n run verify"
python3 -m reflective_learning.tools.mini --mode verify --input predicted$next.json --output verified$next.json --image seed_image --max-success-steps 15

echo -e "\n run filter"
python3 filter3.py --filename verified$next.json

echo -e "\n run check result"
grep state verified$next\_noprefix.json|grep -v "\"16"|wc


