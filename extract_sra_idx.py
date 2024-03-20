import sys
import json


def main():
    js_fn = sys.argv[1]

    for line in open(js_fn):
        j = json.loads(line)
        for rec in j["assemblyInfo"]["biosample"]["sampleIds"]:
            if "db" in rec and rec["db"] == "SRA":
                print(rec["value"])


if __name__ == "__main__":
    main()
