---
redirect_from:
  - "/05-interp-approx/exercises-02-spline-interpolation"
interact_link: content/05_interp_approx/exercises_02_spline_interpolation.ipynb
kernel_name: octave
has_widgets: false
title: 'Spline-Interpolation'
prev_page:
  url: /05_interp_approx/exercises_01_linear_approximation
  title: 'Lineare Approximation'
next_page:
  url: /emptypage
  title: 'Differentiation und Integration'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Spline-Interpolation am Biegebalken

Der Biegebalken mit einseitiger fester Einspannung ist ein Standardlastfall, der Ihnen aus der technischen
Mechanik bekannt ist.

<img src="../images/spline_interpolation.png" width="400" height="315" />

Messungen der Biegelinie an verschiedenen Punkten ergaben folgende Werte:

| $x [m]$ | 0   | 0.5 | 1 | 1.5 | 2 |
|:-------|:---|:---|:---|:---|:---|
| $z [m]$ | 0.00 | 0.0125 | 0.05 | 0.1125 | 0.2  |

Schreiben Sie ein Programm in dem Sie die gesamte Biegelinie des Balkens mit einem Spline interpolieren.
Dabei wird jedes Teilintervall mit einem geeigneten Polynom genähert (**Hierbei keine fertige MATLABSpline-Funktion benutzen - Finger weg von der Spline-Toolbox!**). Der Einfachheit halber werden hier
Polynome vom Grad zwei verwendet.

Zur eindeutigen Bestimmung der einzelnen Polynome sind drei Bedingungen notwendig. Zwei sind durch
den Anfangs- und Endpunkt des jeweiligen Intervalls gegeben. Um Knicke im gesamten Spline zu vermeiden
wird zusätzlich gefordert, dass die ersten Ableitungen an den Intervallgrenzen übereinstimmen
(dritte Bedingung). Welche Randbedingung ist für die erste Ableitung an der Einspannung zu wählen?
Stellen Sie die Messpunkte und den interpolierten Spline in einem plot dar.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
%SPACE FOR THE (WELL DOCUMENTED) SOLUTION


```
</div>

</div>
