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

Ein interaktives Übungsbuch zur Vorlesung __Modellbildung und Simulation__ an der [Hochschule Bonn-Rhein-Sieg](https://www.h-brs.de).



{:.input_area}
```matlab
x = linspace(-8, 8, 41)';
y = x;
[X, Y] = meshgrid(x, y);
R = sqrt(X.^2 + Y.^2) + eps;
Z = sin(R)./ R;
surf(X, Y, Z);
```



{:.output .output_png}
![png](intro_1_0.png)



## Acknowledgements

Jupyter Books was originally created by [Sam Lau][sam] and [Chris Holdgraf][chris]
with support of the **UC Berkeley Data Science Education Program and the Berkeley
Institute for Data Science**.

[sam]: http://www.samlau.me/
[chris]: https://predictablynoisy.com
