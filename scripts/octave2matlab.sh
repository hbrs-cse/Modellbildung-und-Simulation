#!/bin/bash

egrep -lRZ '```octave' _build | xargs -0 -l sed -i -e 's/```octave/```matlab/g'
