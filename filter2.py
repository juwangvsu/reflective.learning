#read a json file, and only keep the following keys:  start, final,text, image. the results should be saved to a file named trajs_sim_0_sampling.json
import json

# Define the keys to keep
keys_to_keep = ['start', 'final', 'token']

# Initialize an empty list to store the filtered data
filtered_data = []

# Read the line-separated JSON file
with open('trajs_sim_0_inference.json', 'r') as infile:
    for line in infile:
        entry = json.loads(line.strip())  # Parse the JSON from the line
        filtered_entry = {key: entry[key] for key in keys_to_keep if key in entry}
        filtered_data.append(filtered_entry)

# Save the filtered data to a new file
with open('trajs_sim_0_infer_clean.json', 'w') as outfile:
    for entry in filtered_data:
        json.dump(entry, outfile)
        outfile.write('\n')

print("Filtered data has been saved to trajs_sim_0_infer_clean.json.")

