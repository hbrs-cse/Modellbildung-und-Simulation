---
redirect_from:
  - "/00-einleitung/exercises-02-fluessigkeit"
interact_link: content/00_einleitung/exercises_02_fluessigkeit.ipynb
kernel_name: octave
title: 'Flüssigkeit im Boden'
prev_page:
  url: /00_einleitung/exercises_01_factorial_pi
  title: 'Matlab/Octave'
next_page:
  url: /emptypage
  title: 'Verkehrssimulation'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Flüssigkeit im Boden

Erstellen Sie ein Programm in dem das Versickern einer Flüssigkeit im Boden in 2D modelliert wird. Legen Sie dazu eine Matrix an, die einen Bodenausschnitt mit **beliebiger** Breite $w$ und Tiefe $d$ darstellt. Die Oberfläche des Bodens sei im Bereich $[\frac{w}{4},\frac{3w}{4}]$ mit Flüssigkeit benetzt. 

![](../images/fluessigkeit.png)

Die Flüssigkeit dringt mit einer Wahrscheinlichkeit $p$ (Bodenparameter) senkrecht in die nächste Lage des Bodens ein. Zusätzlich kann es passieren, dass die Flüssigkeit in diagonal versetzte Bodenelemente eindringt, jeweils mit der Wahrscheinlichkeit $\frac{p}{2}$. Als Modellvereinfachung gehen Sie davon aus, dass jede Zelle entweder Flüssigkeit enthält oder nicht, d.h. der Zustand jeder Zelle ist binär.

## Aufgabe 1 - Parametrierung des Bodenmodells

Schreiben Sie eine Matlab Funktion, die diesen Prozess simuliert:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
%%file groundwater_sim.m
function ground = groundwater_sim(depth, width, probability)
% simulate diffusion of groundwater using cellular automata.
%
% The ground is modelled as a rectangular 2D-grid of size 
%   depth x width. 
% Fluid from a cell or the surface propagates to cells below
% according to a certain probability. Initially, the central 
% half of the surface is covered by fluid
%
% Inputs:
%   - depth:       The depth of the regulear 2D grid
%   - width:       The width of the regular 2D grid
%   - probability: The diffusion probability into lower cells
%
% Outputs:
%   - ground:      2D-grid represnting the groundwater distribution
%                  It is a (depth x width) Matrix with values in {0,1}

end
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
Created file '/data/work/H_BRS/Modellbildung-und-Simulation/content/00_einleitung/groundwater_sim.m'.
```
</div>
</div>
</div>

**Tipp:** 
 - Für die Visualisierung können Sie zum Beispiel die Funktion `spy` oder `imagesc` verwenden.
 - Die Ränder der Bodenmatrix sind gesondert zu behandeln.

Parametrieren Sie den Bodenparameter $p$ so, dass über 1000 Simulationen gemittelt circa drei Zellen am unteren Ende befeuchtet sind. Berechnen Sie dann Mittelwert und Standardabweichung. Verwenden Sie hierfür konkret $d=80$ und $w=80$. Schreiben Sie dazu ein Matlab-Skript, dass die Funktion `groundwater_sim` verwendet.

## Aufgabe 2 - Unregelmäßigkeiten im Boden

Reale Böden sind in der Regel sehr unregelmäßig strukturiert, so dass Flüssigkeiten an verschiedenen Punkten auch unterschiedlich gut in den Boden eindringen können. Gehen Sie nun davon aus, dass der Boden zu einem Anteil von `absorbing_material` aus zufällig verteiltem Material besteht, welches Flüssigkeit absorbieren kann. Modifizieren ihr Programm aus Aufgabe 1 so, dass diese Unregelmäßigkeit des Bodens zusätzlich berücksichtigt wird.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
%%file groundwater_sim.m
function ground = groundwater_sim(depth, width, probability, absorbing_material)
% simulate diffusion of groundwater using cellular automata.
%
% The ground is modelled as a rectangular 2D-grid of size 
%   depth x width. 
% Fluid from a cell or the surface propagates to cells below
% according to a certain probability. Initially, the central 
% half of the surface is covered by fluid
%
% Inputs:
%   - depth:       The depth of the regulear 2D grid
%   - width:       The width of the regular 2D grid
%   - probability: The diffusion probability into lower cells
%   - absorbing_material: Ratio of absorbing material in the ground
%                         values between 0 and 1
%
% Outputs:
%   - ground:      2D-grid represnting the groundwater distribution
%                  It is a (depth x width) Matrix with values in {0,1}

end
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
Created file '/data/work/H_BRS/Modellbildung-und-Simulation/content/00_einleitung/groundwater_sim.m'.
```
</div>
</div>
</div>

Geben Sie $p$ vor und variieren Sie `absorbing_material` ausgehend von 10%. Wie groß muss der Anteil *mindestens* sein, damit über 1000 Simulationen gemittelt weniger als eine Zelle am unteren Ende des Bodensegments von Flüssigkeit erreicht wird ($d=250$ und $w=250$)?

## Aufgabe 3 - Einfluss der Tiefe

In größerer Tiefe ist das Bodenmaterial stärker verdichtet als nahe der Oberfläche. Erweitern Sie ihr Programm aus Aufgabe 2 so, dass sich die Flüssigkeit bei zunehmender Tiefe schlechter durch den Boden bewegt. Führen Sie einen Parameter `depth_influence` ein, um die Stärke dieses Effektes zu regulieren.

Um die Eingabeparameter ihrer Funktion übersichtlich zu gestalten, sammeln Sie alle Bodenparameter in einem *Structure array* mit Namen `params`.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
%%file groundwater_sim.m
function ground = groundwater_sim(depth, width, params)
% simulate diffusion of groundwater using cellular automata.
%
% The ground is modelled as a rectangular 2D-grid of size 
%   depth x width. 
% Fluid from a cell or the surface propagates to cells below
% according to a certain probability. Initially, the central 
% half of the surface is covered by fluid
%
% Inputs:
%   - depth:       The depth of the regulear 2D grid
%   - width:       The width of the regular 2D grid
%
%   - params.probability:        The diffusion probability into 
%                                lower cells
%   - params.absorbing_material: Ratio of absorbing material in 
%                                the ground values between 0 and 1
%   - params.depth_influence:    influence of the depth on the
%                                seeping probability
%
% Outputs:
%   - ground:      2D-grid represnting the groundwater distribution
%                  It is a (depth x width) Matrix with values in {0,1}

end
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
Created file '/data/work/H_BRS/Modellbildung-und-Simulation/content/00_einleitung/groundwater_sim.m'.
```
</div>
</div>
</div>

In einem Skript können Sie die Parameter im Structure array speichern und so gesammelt an die Funktion übergeben:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
depth = 10;
width = 10;

params.probability        = 0.1;
params.absorbing_material = 0.1;
params.depth_influence    = 0.5;

G = groundwater_sim(depth, width, params);
```
</div>

</div>

## Aufgabe 4 - Gesteigerter Realismus

Überlegen Sie sich einen weiteren Einflussparameter mit dem der Prozess des Versickerns realistischer simuliert werden kann und modifizieren Sie ihr Programm aus Aufgabe 3 entsprechend. In welchen Grenzen kann man diesen Parameter sinnvoll wählen?
