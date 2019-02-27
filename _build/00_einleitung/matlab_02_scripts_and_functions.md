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
  url: /00_einleitung/matlab_03_best_practice
  title: 'Best Practices'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Skripte und Funktionen

Bisher haben wir Befehle im `Command Window` eingeben und festgestellt, dass alle Variablen im `Workspace` hinterlegt werden. In diesem Kapitel widmen wir uns den `Editor`. Wir benutzen ihn um Skripte und Funktionen zuschreiben. Beide werden als Textdateien mit der Endung `.m` gespeichert. Prinzipiell können wir diese Textdateien mit jeden beliebigen Texteditor schreiben, Der Editor in Matlab bietet aber einige nützliche Funktionen. Allein *Syntax-Highlighting* kann schon sehr hilfreich sein.

## Skripte
 
Matlab-Skripte sind einfache Textdateien, die eine Abfolge von Matlab-Befehlen enthalten. Diese werden nach einander abgearbeitet. 

Das `%`-Zeichen läutet in Matlab einen Kommentar ein. Kommentare helfen dabei, die Skripte nachvollzubar zu machen. Wie in *ALLEN* Programmiersprachen gilt auch in MATLAB: **Kommentieren Sie ihren Code!**
Es kommt nicht selten vor, dass man nach Wochen in ein altes Matlab-Skript schaut, sich fragt was man damals eigentlich gemacht hat und sich wünscht, man hätte es besser kommentiert.



{:.input_area}
```matlab
%%file myScript.m
% Ein kleines Beispielskript
% mit Kommentaren

% Initialisiere Variablen a und b
a = 5;
b = 2*a;

% Ändere Variable a
a = a/2;

% Ausgabe erzwingen, durch weglassen des Semikolons am Ende der Zeile
a
b
```


{:.output .output_stream}
```
Created file '/data/work/H_BRS/Modellbildung-und-Simulation/content/00_einleitung/myScript.m'.

```

**Hinweis:** *Die allererste Zeile*

`%%file myScript.m` 

*besagt nur, dass alles was folgt Inhalt der Datei `myScript.m` ist. Der eigentliche Inhalt der Datei beginnt ab der darauf folgenden Zeile*

`% Ein kleines Beispielskript`.

Dieses Skript wird mit dem `run` Befehl ausgeführt.



{:.input_area}
```matlab
run myScript.m
```


{:.output .output_stream}
```
a =  2.5000
b =  10

```

Wir dürfen an dieser Stelle die Dateiendung `.m` weglassen. Tatsächlich ist der `run` Befehl auch nicht zwingend nötig. Die Befehle `run myScript.m`, `run myScript`, `myScript.m`, `myScript` haben alle denselben Effekt: Die Befehle in `myScript.m` werden ausgeführt.

Es bietet sich an, in den ersten paar Zeilen jedes Skriptes zu beschreiben, welchem Zweck das Skript dient. Diese ersten Zeilen lassen sich mit dem `help` Befehl ausgeben:



{:.input_area}
```matlab
help myScript.m
```


{:.output .output_stream}
```
'myScript.m' is the file /data/work/H_BRS/Modellbildung-und-Simulation/content/00_einleitung/myScript.m

 Ein kleines Beispielskript
 mit Kommentaren


Additional help for built-in functions and operators is
available in the online version of the manual.  Use the command
'doc <topic>' to search the manual index.

Help and information about Octave is also available on the WWW
at http://www.octave.org and via the help@octave.org
mailing list.

```

### for-Schleifen

Wie in anderen Programmiersprachen können in MATLAB auch Schleifen verwendet werden. Die Syntax für eine for-Schleife ist



{:.input_area}
```matlab
for i=1:5
    f(i)=2^i;
end
```


Der Code zwischen der `for`-  und der `end`-Zeile wird fünf mal ausgeführt. Bei jeder Ausführung wird eine *Laufvariable* `i` um Eins erhöht. Wir greifen in diesem Beispiel in jedem Durchlauf auf die $i$-te Stelle eines Vektors $f$ zu, und beschreiben diese Stelle mit $2^i$. Dabei wird der Vektor f automatisch in jedem Schleifendurchlauf um ein Element erweitert. Matlab macht den Vektor nur so groß, wie für die Ausführung des Befehls nötig ist. Es ist zu beachten, dass in MATLAB auf das erste Element eines Vektors mit dem Index 1 zugegriffen wird.

Es besteht die Möglichkeit die Schrittweite der Laufvariablen anzupassen. Auf diese Weise können auch Laufvariablen benutzt werden, die nicht ganzzahlig sind:



{:.input_area}
```matlab
for t=2*pi:-pi/2:0
    x = [cos(t), sin(t)]
end
```


{:.output .output_stream}
```
x =

   1.0000e+00  -2.4493e-16

x =

  -1.8370e-16  -1.0000e+00

x =

  -1.0000e+00   1.2246e-16

x =

   6.1232e-17   1.0000e+00

x =

   1   0


```

**Quiz:** Wie sieht der Vektor $f$ aus, der von folgender for-Schleife erzeugt wird?



{:.input_area}
```matlab
for i=1:2:5
    f(i)=2^i;
end
```


Bei for-Schleifen ist über die Laufvariable die Anzahl der Aufrufe vor dem Beginn der Schleife klar. Es ist zwar möglich, die Laufvariable selbst in der Schleife zu verändern, das sollte aber auf jeden Fall vermieden werden. Der Code wird dadurch nicht mehr intuitiv verständlich und es ist eine wahrscheinliche Fehlerquelle.

### while-Schleifen

while-Schleifen bieten eine weiter Möglichkeit, einen Code-Block wiederholt auszuführen. Eine while-Schleife solange ausgeführt, bis eine Aussage nicht mehr zutrifft. Dabei muss dem Programmierer vorher nicht bekannt sein, wieviele Schleifendurchläufe dafür nötig sind.



{:.input_area}
```matlab
x = pi/2;
while abs( sin(x)-x )/x > 0.01
    x = 0.99*x;
end
disp(x)
```


{:.output .output_stream}
```
 0.24470

```

Die Anweisung `x = 0.99*x` wird solange ausgeführt, bis $\lvert \sin(x) - x \rvert$ nicht mehr größer als $0.01$ ist.

Das kleine Programm schätzt auf eine etwas ungenaue Art ab, bis zu welchem Wert die Kleinwinkelnäherung $\sin(x) \approx x$ relative Fehler von unter $1 \%$ liefert. 

**Challenge:** Fallen Ihnen Wege ein, die Abschätzung genauer zu gestalten?

Eine for-Schleife kann immer in eine-while Schleife umgeschrieben werden. Folgende Code-Blöcke liefern das selbe Ergebnis:



{:.input_area}
```matlab
for i=1:5
    f(i)=2^i;
end
```




{:.input_area}
```matlab
i=1;
while i<=5
    f(i)=2^i;
    i = i+1;
end
```


**Best Practice:** Verwenden Sie while-Schleifen, wenn die Anzahl der Durchläufe unbekannt ist und for-Schleifen sonst.

### if-Abfragen

TO DO

### Grafische Ausgabe

TO DO

## Funktionen

To Do:
 * Auf Scope eingehen, Unterschiede Skript und Funktion
 * Nested Call
 * Function handles

## To aufräum




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
![png](../images/00_einleitung/matlab_02_scripts_and_functions_20_0.png)



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
![png](../images/00_einleitung/matlab_02_scripts_and_functions_29_0.png)


