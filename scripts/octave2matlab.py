#!/usr/bin/env python3
import os

for dname, dirs, files in os.walk("_build"):
    for fname in files:
        fpath = os.path.join(dname, fname)
        if fpath[-3:]=='.md':
            with open(fpath) as f:
                s = f.read()
            s = s.replace("```octave", "```matlab")
            with open(fpath, "w") as f:
                f.write(s)