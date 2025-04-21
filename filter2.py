#read a json file, and only keep the following keys:  start, final,text, image. the results should be saved to a file named trajs_sim_0_sampling.json
import json
import argparse
import os

# Initialize an empty list to store the filtered data
filtered_data = []
parser = argparse.ArgumentParser(
                            description="Convert 3D CSV path data into transformer-ready JSON format."
                                                    )
parser.add_argument("--inputfn", required=False, default="trajs_sim_0_inference.json", help="Path to raw CSV file")
parser.add_argument("--outputfn", required=False, default="trajs_sim_0_infer_clean.json", help="Path to raw CSV file")

args = parser.parse_args()
fni_json = os.path.join('.', args.inputfn)

# Define the keys to keep
keys_to_keep = ['start', 'final', 'token']


# Read the line-separated JSON file
with open(args.inputfn, 'r') as infile:
    for line in infile:
        entry = json.loads(line.strip())  # Parse the JSON from the line
        filtered_entry = {key: entry[key] for key in keys_to_keep if key in entry}
        filtered_data.append(filtered_entry)

# Save the filtered data to a new file
with open(args.outputfn, 'w') as outfile:
    for entry in filtered_data:
        json.dump(entry, outfile)
        outfile.write('\n')

print("Filtered data has been saved to :", args.outputfn)

