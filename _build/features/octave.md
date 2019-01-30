---
interact_link: content/features/octave.ipynb
title: 'Ein Octave Notebook als Test'
prev_page:
  url: /features/notebooks
  title: 'Ein Python Notebook als Test'
next_page:
  url: /emptypage
  title: 'Über dieses Buch'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Matlab Getting Started

Dieses Online-Tutorial basiert auf [GNU Octave](https://www.gnu.org/software/octave/), einer frei-verfügbaren Matlab-Alternative, das in den allermeisten Fällen Matlab Befehle korrekt interpretieren kann. Alle Beispiele die Sie hier finden werden, können Sie sowohl mit Octave als auch mit Matlab ausführen.

### Erstellen einfacher Graphen

Die folgenden beiden Zeilen erstellen einen Vektor $t$, der das Intervall $[0,2\pi]$ an 25 äquidistanten Punkten enthält und einen Vektor $y$, der an diesen Punkten die Funktion $y=sin(t)$ auswertet.



{:.input_area}
```octave
t = linspace(0,2*pi,25);
y = sin(t);
```


Wir schauen uns mal die ersten 5 Elemente der beiden Vektoren an. Wenn ein Matlab-Befehl ohne Semikolon geschrieben wird, wird das Ergebnis des Befehles ausgegeben.



{:.input_area}
```octave
t(1:5)
y(1:5)
```


{:.output .output_stream}
```
ans =

   0.00000   0.26180   0.52360   0.78540   1.04720

ans =

   0.00000   0.25882   0.50000   0.70711   0.86603


```

Nun wollen wir eine grafische Darstellung mit dem Befehl `plot` erzeugen. Wir wählen den Vektor $t$ für die x-Werte und den Vektor $y$ für die y-Werte. 



{:.input_area}
```octave
plot(t,y);
```



{:.output .output_png}
![png](../images/features/octave_6_0.png)



Einfache Funktionen blablabla



{:.input_area}
```octave
%%file fibonacci.m

function n = fibonacci(n)

if n<3
    n = 1;
else
    n = fibonacci(n-1) + fibonacci(n-2);
end
    
```


{:.output .output_stream}
```
Created file '/mnt/d/documents/modellbildung-und-simulation/content/features/fibonacci.m'.

```



{:.input_area}
```octave
for i = 1:10
    fibonacci(i)
end
```


{:.output .output_stream}
```
ans =  1
ans =  1
ans =  2
ans =  3
ans =  5
ans =  8
ans =  13
ans =  21
ans =  34
ans =  55

```
