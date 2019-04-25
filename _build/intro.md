---
interact_link: content/intro.ipynb
kernel_name: octave
has_widgets: false
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

Dies ist ein interaktives Übungsbuch zur Vorlesung __Modellbildung und Simulation__ an der [Hochschule Bonn-Rhein-Sieg](https://www.h-brs.de). Es dient zur Übermittlung von Matlab bzw. Octave-Kenntnissen für die Modellierung und Simulation ingenieurstechnischer Probleme.

Es ist ein gemeinsames Projekt von [Dirk Reith](https://www.h-brs.de/de/emt/dirk-reith), [Gerd Steinebach](https://www.h-brs.de/de/emt/prof-dr-gerd-steinebach) und [Jan Kleinert](https://www.h-brs.de/de/emt/prof-dr-jan-kleinert), das sich gerade im Aufbau befindet. Wir freuen uns über jegliche Art von Feedback!

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
x = linspace(-8, 8, 41)';
y = x;
[X, Y] = meshgrid(x, y);
R = sqrt(X.^2 + Y.^2) + eps;
Z = sin(R)./ R;
surf(X, Y, Z);
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">

{:.output_png}
![png](images/intro_1_0.png)

</div>
</div>
</div>

Im Gegensatz zu Matlab-Liveskripten wird hier auf die kostenfreie Matlab-Alternative [Octave](https://www.gnu.org/software/octave/) zusammen mit dem [Project Jupyter](https://jupyter.org/) gebaut, um mit frei verfügbaren Software-Tools frei verfügbare Lerninhalte bereitzustellen.

***Hinweis***: Microsoft Edge und Microsoft Internet Explorer werden nicht unterstützt!

## Acknowledgements

Jupyter Books was originally created by [Sam Lau][sam] and [Chris Holdgraf][chris]
with support of the **UC Berkeley Data Science Education Program and the Berkeley
Institute for Data Science**.

[sam]: http://www.samlau.me/
[chris]: https://predictablynoisy.com
