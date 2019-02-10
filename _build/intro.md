---
interact_link: content/intro.ipynb
kernel_name: octave
title: 'Home'
prev_page:
  url: 
  title: ''
next_page:
  url: /00_einleitung/intro
  title: 'Einleitung'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Modellbildung und Simulation

An dieser Stelle entsteht in Kürze ein interaktives Übungsbuch zur Vorlesung __Modellbildung und Simulation__ an der [Hochschule Bonn-Rhein-Sieg](https://www.h-brs.de).



{:.input_area}
```matlab
tx = ty = linspace(-8, 8, 41)';
[xx, yy] = meshgrid(tx, ty);
r = sqrt(xx.^2 + yy.^2) + eps;
tz = sin(r)./ r;
surf(tx, ty, tz);
```



{:.output .output_png}
![png](/data/work/H_BRS/Modellbildung-und-Simulation/_build/intro_1_0.png)



## Acknowledgements

Jupyter Books was originally created by [Sam Lau][sam] and [Chris Holdgraf][chris]
with support of the **UC Berkeley Data Science Education Program and the Berkeley
Institute for Data Science**.

[sam]: http://www.samlau.me/
[chris]: https://predictablynoisy.com
