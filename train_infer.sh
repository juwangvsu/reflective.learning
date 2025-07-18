#!/bin/bash

# Check if a filename argument is provided
if [ -z "$1" ]; then
	  echo "Usage: $0 <filenameprefix>"
	    exit 1
fi
	    
   # Get the filename from the command line argument
fn_data="$1" #trajs_sim_0
	  
mkdir -p output
#1
echo "*******************step 1****************************"
python3 -m src.reflective_learning.tools.main preprocess --input ../jack_bot/motion_path/"$fn_data".json --mapping ../jack_bot/motion_path/xxx.txt --output "$fn_data"_preprocess.json  --context-dir context

cp "$fn_data"_preprocess.json output/

#(2)
echo "*******************step 2****************************"
python3 -m src.reflective_learning.tools.main preprocess --input ../jack_bot/motion_path/"$fn_data".json --mapping ../jack_bot/motion_path/xxx.txt --output "$fn_data"_preprocess_prefix.json  --context-dir context --prefix-only

cp "$fn_data"_preprocess_prefix.json output/

#(2.5)
echo "*******************step 2.5****************************"
python3 filter.py --inputfn "$fn_data".json
cp "$fn_data"_sampling.json output/

#(3)
echo "*******************step 3****************************"
python3 -m src.reflective_learning.tools.main preprocess --input "$fn_data"_sampling.json --mapping ../jack_bot/motion_path/xxx.txt --output "$fn_data"_preprocess_prefix.json  --context-dir context --prefix-only


cp "$fn_data"_preprocess_prefix.json output/

 
python3 -m src.reflective_learning.tools.main generate --input "$fn_data"_preprocess_prefix.json --checkpoint checkpoints/mp_model --mapping ../jack_bot/motion_path/xxx.txt --state-weights success=0.95,fail=0.05 --output "$fn_data"_inferenc.json

cp "$fn_data"_inferenc.json output/

#4
echo "*******************step 4****************************"
python3 filter2.py --inputfn "$fn_data"_inference.json --outputfn "$fn_data"_infer_clean.json


cp "$fn_data"_infer_clean.json output/


