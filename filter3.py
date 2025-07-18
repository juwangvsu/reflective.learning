import json
import argparse
parser = argparse.ArgumentParser(description="This script demonstrates how to use the camera sensor.")
parser.add_argument("--filename", type=str, default="predicted.json", help="Basename of output file.")
args_cli = parser.parse_args()


input_file = args_cli.filename #"predicted.json"  # Replace with your actual input file name
fn_pref = input_file.split('.')[0]
output_file = fn_pref+"_noprefix.json"

with open(input_file, "r", encoding="utf-8") as infile, open(output_file, "w", encoding="utf-8") as outfile:
    for line in infile:
        obj = json.loads(line)
        obj.pop("prefix", None)  # Safely remove the "prefix" key if it exists
        json.dump(obj, outfile)
        outfile.write("\n")

