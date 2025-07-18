import json
import os
import argparse
parser = argparse.ArgumentParser(description="This script check the unique lines in seed.json.")
parser.add_argument("--filename", type=str, default="seed.json", help="Basename of output file.")
parser.add_argument("--dupdir", type=str, default="duplicate", help="Basename of output file.")
args_cli = parser.parse_args()


input_file = args_cli.filename #"predicted.json" 
unique_texts = set()
unique_lines = []
uniqiue_idx=0
with open(input_file, "r", encoding="utf-8") as infile:
    for line in infile:
        obj = json.loads(line)
        text = obj.get("text")
        text2 = obj.get("token")
        key = json.dumps(text, sort_keys=False)+json.dumps(text2, sort_keys=False)
        if text is not None:
            if not key in unique_texts:
                unique_lines.append(line)
            unique_texts.add(json.dumps(text, sort_keys=False)+json.dumps(text2, sort_keys=False))  # makes it a string

output_json = 'seed_unique.json'
with open(output_json, "w") as f:
    for item in unique_lines:
        f.write(item)

unique_list =list(unique_texts)
dup_texts = [[] for i in range(len(unique_list))]
with open(input_file, "r", encoding="utf-8") as infile:
    for line in infile:
        obj = json.loads(line)
        text = obj.get("text")
        text2 = obj.get("token")
        key = json.dumps(text, sort_keys=False)+json.dumps(text2, sort_keys=False)
        if key in unique_list:
            idx = unique_list.index(key)
            dup_texts[idx].append(line)  # makes it a string
for i in range(len(dup_texts)):
    output_json = os.path.join(args_cli.dupdir, 'seed_'+str(i))
    with open(output_json, "w") as f:
        for item in dup_texts[i]:
            f.write(json.dumps(item) + "\n")

print(f"Number of unique 'text' values: {len(unique_texts)}")

for ut in unique_texts:
    print(ut)
#print(f"unique 'text' 'token' values: {unique_texts}")


