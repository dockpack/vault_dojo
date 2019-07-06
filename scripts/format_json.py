#!/usr/bin/env python
# text filter script for TextWrangler or BBEdit
# http://ukitech.blogspot.in/2012/08/format-json-in-free-textwrangler.html
import fileinput
import json
if __name__ == "__main__":
    text = ''
    for line in fileinput.input():
        text = text + ' ' + line.strip()
    jsonObj = json.loads(text)
    print json.dumps(jsonObj, sort_keys=True, indent=2)
