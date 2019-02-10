---
redirect_from:
  - "/00-einleitung/matlab-02-scripts-and-functions"
interact_link: content/00_einleitung/matlab_02_scripts_and_functions.ipynb
kernel_name: octave
title: 'Skripte und Funktionen'
prev_page:
  url: /00_einleitung/matlab_01_command_window
  title: 'Matlab Command Window'
next_page:
  url: /emptypage
  title: 'Best Practices'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Skripte und Funktionen

Bisher haben wir Befehle im `Command Window` eingeben und festgestellt, dass alle Variablen im `Workspace` hinterlegt werden. In diesem Kapitel widmen wir uns den `Editor`. Wir benutzen ihn um Skripte und Funktionen zuschreiben. Beide werden als Textdateien mit der Endung `.m` gespeichert. Prinzipiell können wir diese Textdateien mit jeden beliebigen Texteditor schreiben, Der Editor in Matlab bietet aber einige nützliche Funktionen. Allein *Syntax-Highlighting* kann schon sehr hilfreich sein.

## Skripte
 
To Do
 * Plots
 * if-then-else, while, for
 * Kommentare
 * Aufruf von Skripten im Command Window, nested Aufruf

## Funktionen

To Do:
 * Auf Scope eingehen, Unterschiede Skript und Funktion
 * Function handles


## To aufräum


Das %-Zeichen läutet in MATLAB einen Kommentar ein.

* Wie in *ALLEN* Programmiersprachen gilt in MATLAB: ** Kommentieren Sie ihren Code! **

Wie in anderen Programmiersprachen können in MATLAB auch Schleifen verwendet werden. Die Syntax für eine for-Schleife ist



{:.input_area}
```matlab
for i=1:5
    f(i)=2^i;
end
```


Dabei wird der Vektor f automatisch in jedem Schleifendurchlauf um ein Element erweitert. Es ist zu beachten, dass in MATLAB auf das erste Element eines Vektors mit dem Index 1 zugegriffen wird. Weitere Schleifentypen sind in der Hilfe nachzulesen.



{:.input_area}
```matlab
x=linspace(-5,5,11);   % Ein Vektor mit Werten von -5 bis 5
y=x.^2;                % Ein Vektor y mit den zugehörigen Funktionswerten 

plot(x,y);             % Erstellen einer grafischen Darstellung
title('Mein erster plot')
xlabel('X-Achsenbeschriftung')
ylabel('Y-Achsenbeschriftung')
```



{:.output .output_png}
![png](../images/00_einleitung/matlab_02_scripts_and_functions_5_0.png)



## Funktionen schreiben

* Funktionen werden normalerweise in einem eigenen m-file gespeichert, siehe das Handout zur Matlab Einführung.

* Kurze Funktionen (Einzeiler) können in Variablen, so genannten 'function handles' abgespeichert werden.



{:.input_area}
```matlab
% Die Unbekannten Größen einer function handle
% werden mit dem @-Symbol deklariert.
meineFunktion = @(x)  x.^2;

meineFunktion(2)
meineFunktion([2,3;4,5])
```


{:.output .output_stream}
```
ans =  4
ans =

    4    9
   16   25


```

# Binominialkoeffizienten

siehe Handout



{:.input_area}
```matlab
%% fac.m
% calculate the factorial of an integer n
function z = fac(n)
    if n==0
        z=1;
    else
        z=n*fac(n-1);
    end
end
```




{:.input_area}
```matlab
n=5;
k=3;
fac(5)/(fac(k)*fac(n-k))
```


{:.output .output_stream}
```
ans =  10

```

# Programmierübung 2: Rundungsfehler

siehe Handout



{:.input_area}
```matlab
max_iter=30;            % Anzahl der Iterationen
z = zeros(max_iter,1);  % Initialisiere Vektor für z aus Effizienzgründen
err = zeros(max_iter,1);% Initialisiere Vektor für err aus Effizienzgründen

z(1)=2*sqrt(2);         %Anfangswerte
err(1)=abs(pi-z(1))/pi;

for n=1:max_iter-1
    z(n+1)=2^(n+1.5)*sqrt(1-sqrt(1-4^(-n-1)*z(n)^2));
    err(n+1)=abs(pi-z(n+1))/pi;
end
```


Logarithmische Darstellung des Fehlers



{:.input_area}
```matlab
plot(log(err))
title('Logarithmus des Fehlers')
xlabel('Iteration')
ylabel('log(error)')
```



{:.output .output_png}
![png](../images/00_einleitung/matlab_02_scripts_and_functions_14_0.png)


