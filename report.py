import argparse
import json
from datetime import date

def get_config(file):
    f = open(file)
    config = json.load(f)
    f.close()

    return config

config = get_config('config.json')
print(config)

parser = argparse.ArgumentParser()
parser.add_argument('--day', type=str, required=False, default=date.today().strftime("%Y-%m-%d"),
                    help='Day for reporting (yyyy-mm-dd)')
args = parser.parse_args()

print(args.day)
