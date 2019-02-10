---
redirect_from:
  - "/00-einleitung/matlab-01-command-window"
interact_link: content/00_einleitung/matlab_01_command_window.ipynb
kernel_name: octave
title: 'Matlab Command Window'
prev_page:
  url: /00_einleitung/matlab_00_first_steps
  title: 'Erste Schritte in Matlab'
next_page:
  url: /00_einleitung/matlab_02_scripts_and_functions
  title: 'Skripte und Funktionen'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---

# Command Window

Im *Command Window* gibt man, wie der Name schon sagt, Befehle ein. Diese werden unmittelbar nach dem *Prompt* ```>>``` eingetippt. 

## Erste Befehle

Gibt man zum Beispiel ```a=5``` ein, erscheint ein feedback, dass die Variable ```a``` erstellt wurde, und sie den Wert ```5``` zugewiesen bekommen hat.




{:.input_area}
```matlab
a = 5
```


{:.output .output_stream}
```
a =  5

```

MATLAB gibt nach Eingabe eines Kommandos immer eine Rückmeldung, in diesem Fall wird die Variable noch einmal ausgegeben. Diese Rückmeldung kann mit Hilfe des Semikolons unterdrückt werden:



{:.input_area}
```matlab
b = 2*pi;
```


Beide Variablen sind nun im Workspace hinterlegt, und können für weitere Berechnungen benutzt werden. Ich kann mir zum Beispiel den Wert von ```b``` ausgeben lassen,



{:.input_area}
```matlab
b
```


{:.output .output_stream}
```
b =  6.2832

```

oder einfache Rechenoperationen ausführen:



{:.input_area}
```matlab
b/a + i*sin(pi/8)
```


{:.output .output_stream}
```
ans =  1.25664 + 0.38268i

```

Das Ergebnis der Rechnung wird unter dem Variablennamen ```ans``` im Workspace hinterlegt. Ich kann dem Ergebnis explizit einen Variablennamen, hier ```c``` zuordnen:



{:.input_area}
```matlab
c = b/a + i*sin(pi/8)
```


{:.output .output_stream}
```
c =  1.25664 + 0.38268i

```

Wenn ich möchte, kann ich die Ausgabe des Ergebnisses unterdrücken, indem ich die Zeile mit einem Semikolon beende:



{:.input_area}
```matlab
d = exp(b/a - i*sin(pi/8));
```


Einige wichtige Punkte konnten wir bisher beobachten:

* Variablenzuweisungen passieren von links nach rechts: Was rechts vom Gleichheitszeichen steht, wird der Variablen die links vom Gleichheitszeichen steht zugeordnet. Wenn es diese Variable nicht gibt, wird sie im Workspace hinterlegt.
* Matlab bietet eine Vielzahl von mathematischen Funktionen an, die regelmäßig gebraucht werden, wie z.B. die Exponentialfunktion ```exp``` oder das Rechnen mit komplexen Zahlen.
* Alle Variablen werden im Workspace hinterlegt und können anschließend für weitere Berechnungen verwendent werden.
* In Matlab werden die skalaren Datentypen (```integer```, ```double```, ```float```, ...) nicht explizit angegeben, wie man es von Sprachen wie C oder C++ vielleicht gewöhnt ist. Auch wenn die Variablen ```a``` ganzzahlig ist, geht Matlab standardmäßig von ```double``` aus. Der Typ einer Variable lässt sich in Matlab durch die Funktion ```class()``` ausgeben lassen:



{:.input_area}
```matlab
class(a)
```


{:.output .output_stream}
```
ans = double

```

## Vektoren und Matrizen

Matlab ist ein Kofferwort aus **Mat**rix-**Lab**oratory. Der Name impliziert schon, dass es sich ideal dazu eignet mit Matrizen und Vektoren zu arbeiten. Dabei wird nicht zwischen den beiden unterschieden: Ein Zeilenvektor mit $n$ Einträgen ist einfach eine Matrix aus $\mathbb{R}^{1 \times n}$, während ein Spaltenvektor mit $n$ Einträgen eine Matrix aus $\mathbb{R}^{n \times 1}$ ist.

In Matlab werden Matrizen mit eckigen Klammern geschrieben, ein Semikolon beendet eine Zeile:



{:.input_area}
```matlab
e = [1, 2, 3, 4, 5] % ein Zeilenvektor
f = [1; 2; 3; 4; 5] % ein Spaltenvektor
```


{:.output .output_stream}
```
e =

   1   2   3   4   5

f =

   1
   2
   3
   4
   5


```

## Produkte von Vektoren und Matrizen

Beim Produkt zweier Vektoren $\mathbf{e}$ und $\mathbf{f}$ (byw. Matrixprodukt zweier Matrizen) ist stets darauf zu achten, dass die Dimensionen zueinander passen! Kann ich die eben erstellten Vektoren $e$ und $f$ miteinander multiplizieren?



{:.input_area}
```matlab
e*f
```


{:.output .output_stream}
```
ans =  55

```

Aha, bei Multiplikation eines $(1,n)$-dimensionalen Vektors $\mathbf{e}$ mit einem $(n,1)$-dimensionalen Vektor $\mathbf{f}$ erhalte ich eine Zahl, bzw. eine $(1,1)$-dimensionale Matrix mit nur einem Eintrag. Wir erhalten das **Skalarprodukt**

$$ \mathbf{e} \cdot \mathbf{f} = \sum_{i=1}^n e_i \cdot f_i. $$



{:.input_area}
```matlab
f*e
```


{:.output .output_stream}
```
ans =

    1    2    3    4    5
    2    4    6    8   10
    3    6    9   12   15
    4    8   12   16   20
    5   10   15   20   25


```

Die Multiplikation eines $(n,1)$-dimensionalen Vektors $\mathbf{f}$ mit einem (1,n)-dimensionalen Vektor $\mathbf{e}$ liefert mit also eine $(n,n)$-dimensionale Matrix. Es handelt sich um das **diadische Produkt**

$$ A = \mathbf{f} \cdot \mathbf{e}, \hskip0.5cm A_{ij} = f_i \cdot e_j $$

Wie sieht es mit den folgenden Matrizen aus?



{:.input_area}
```matlab
g = [1; 1; 1];
h = [2; 2; 2];
g*h
```


{:.output .output_stream}
```
error: operator *: nonconformant arguments (op1 is 3x1, op2 is 3x1)

```

Nein! Es klappt nicht. Die Fehlermeldung gibt schon Auskunft darüber wieso, die Dimensionen der Matrizen passen nicht zusammen. 

*Hinweis:* Hier ist der Wortlaut der Octave-Fehlermeldung zusehen. Matlab gibt an dieser Stelle die folgende Fehlermeldung wieder:

```
Error using  * 
Incorrect dimensions for matrix multiplication. Check that the number of columns in
the first matrix matches the number of rows in the second matrix. To perform
elementwise multiplication, use '.*'.
```

Wir behelfen uns eines Tricks: Ein nachgestelltes Apostroph gibt die transponierte Matrix aus:



{:.input_area}
```matlab
g
```


{:.output .output_stream}
```
g =

   1
   1
   1


```



{:.input_area}
```matlab
size(g)
```


{:.output .output_stream}
```
ans =

   3   1


```



{:.input_area}
```matlab
g'
```


{:.output .output_stream}
```
ans =

   1   1   1


```



{:.input_area}
```matlab
size(g')
```


{:.output .output_stream}
```
ans =

   1   3


```

Das Skalarprodukt von $\mathbf{g}$ mit $\mathbf{h}$ können wir also doch ausrechnen:



{:.input_area}
```matlab
g'*h
```


{:.output .output_stream}
```
ans =  6

```

Sehr häufig ist es nützlich Operationen komponentenweise auszuführen. Nehmen wir zum Beispiel an, in einer kleinen Arbeitsgruppe arbeiten fünft Personen. Zwei Mitarbeiter haben Vollzeitstellen, d.h. 39.5 Stunden pro Woche, einer hat eine halbe Stelle und zwei studentische Hilfskräfte unterstützen jeweils mit acht Stunden pro Woche.. Die wöchentliche Arbeitszeit der Mitarbeiter hinterlegen wir in einem Vektor



{:.input_area}
```matlab
weekly_hours = [39.5, 19.5, 39.5, 8, 8];
```


Die stündlichen Bruttokosten der Mitarbeiterstellen in € schreiben wir ebenfalls in einen Vektor:



{:.input_area}
```matlab
costPerHour_brutto_euro = [57.5, 57.5, 40, 15, 15];
```


Wenn ich wissen möchte, wieviel die Mitarbeiter jeweils pro Woche kosten, muss ich die Vektoren komponentenweise miteinander multiplizieren. Das erreiche ich in Matlab, indem ich vor dem ```*```-Operator einen Punkt voranstelle, es ist also eine *punktweise* Operation, und keine Matrixmultiplikation:



{:.input_area}
```matlab
weekly_hours.*costPerHour_brutto_euro
```


{:.output .output_stream}
```
ans =

   2271.25   1121.25   1580.00    120.00    120.00


```

**Quiz:** Wie berechne ich die Gesamtkosten aller Mitarbeiter pro Woche mit nur einer Zeile in Matlab? *Hinweis: Das Ergebnis lautet 5212.5 €.*



{:.input_area}
```matlab
% calculate weekly total cost

```


{:.output .output_stream}
```


```

## Spezielle Matrizen

Malab hat einige Befehle um spezielle Matrizen zu erstellen. Einige der wichtigsten sind:



{:.input_area}
```matlab
A1 = eye(2);     % 2,2-Einheitsmatrix
A2 = ones(3,2);  % 3,2-Matrix gefuellt mit 1
A3 = zeros(2,4); % 2,4-Matrix gefuellt mit 0
A4 = rand(2);    % 2,2-Matrix mit gleichverteilten Zufallszahlen von 0 bis 1
A5 = randn(4);   % 4,4-Matrix mit normalverteilten Zufallszahlen um 0 und Standardabweichung 1
```


## Funktionen komponentenweise ausführen

Viele der mathematischen Funktionen, wie `sin`, `cos`, `exp`, `sqrt` etc., können auch direkt auf Vektoren und Matrizen angewandt werden. Sie werden dann komponentenweise ausgeführt:



{:.input_area}
```matlab
A4
disp('Die Wurzel der Elemente von A4:')
sqrt(A4)
```


{:.output .output_stream}
```
A4 =

   0.23504   0.90148
   0.52603   0.61217

Die Wurzel der Elemente von A4:
ans =

   0.48480   0.94946
   0.72528   0.78241


```

Nehmen wir zum Beispiel an, wir haben $n$ Vektoren $\mathbf{v}_i = (x_i, y_i, z_i)$, $i=1,...,n$. Wenn wir die $x$-, $y$-, und $z$-Komponenten der Vektoren als `X`, `Y` und `Z` speichern, können wir in nur einer Zeile den Betrag der Vektoren berechnen:



{:.input_area}
```matlab
n=20;
X = randn(n,1);
Y = randn(n,1);
Z = randn(n,1);
% calculate magnitude of vectors
sqrt(X.^2 + Y.^2 + Z.^2)
```


{:.output .output_stream}
```
ans =

   1.73364
   1.16848
   2.36722
   1.31926
   0.51579
   1.25096
   1.86197
   1.34855
   2.36795
   0.86583
   2.90336
   1.76214
   1.07268
   1.11153
   2.10915
   0.85852
   1.20627
   3.32477
   1.34089
   2.09798


```

**Zusatzfrage:** Wozu dienen die Punkte in der Vorschrift `sqrt(X.^2 + Y.^2 + Z.^2)`?

## Concatenation und Slicing

Oft kann es sinnvoll sein, einzelne Vektoren oder Matrizen zu größeren zusammenzufügen. Das nennt man *Concatenation*. Die zuvor erstellten Matrizen `X`, `Y`, `Z` sind schließlich nicht unabhängig von einander, sie bezeichnen die Komponenten von $n$ Vektoren $v_i$. Um dies zu verdeutlichen können wir eine $(n,3)$-Matrix erstellen, dessen Zeilen die jeweiligen Vektoren $v_i$ sind, und die Spalten die jeweiligen Komponenten `X`, `Y` und `Z`:



{:.input_area}
```matlab
V = [X,Y,Z]
```


{:.output .output_stream}
```
V =

   0.318746   0.900866  -1.446499
   0.026590   0.309210   1.126516
  -2.061057   1.010726  -0.578107
  -0.293259   0.949766   0.867398
   0.451284  -0.204515   0.143379
  -1.009625   0.143004  -0.724636
  -0.707674   1.659136  -0.461968
   0.895087  -1.006398  -0.067532
  -1.220751  -1.719768  -1.076727
  -0.146500  -0.052633  -0.851724
   2.501248   0.999032  -1.084067
  -1.415780   1.025420  -0.221840
  -0.950251   0.436690   0.238668
  -0.306860  -0.696183  -0.810347
   0.111207  -1.830164  -1.042425
  -0.137679   0.700737  -0.476524
   0.040380   1.185899   0.217040
  -2.939838  -0.747825  -1.360955
  -0.900775   0.023616  -0.992987
   1.257438  -1.610587   0.475782


```

Wie bei Matrixprodukten müssen wir auf die richtige Dimension achten. Was passiert genau bei folgendem Befehl?



{:.input_area}
```matlab
V = [X,Y;Z]
```


{:.output .output_stream}
```
error: vertical dimensions mismatch (20x2 vs 20x1)

```

*Concatenation* ist also das Zusammenfügen von Matrizen. Der gezielte Zugriff auf Subblöcken aus einer Matrix wird als *Slicing* bezeichnet. In Matlab wird dazu der `:`-Operator verwendet. Mit folgenden Befehlen erhält man die ersten fünf Zeilen der Matrix `V`:



{:.input_area}
```matlab
V(1:5,:)
```


{:.output .output_stream}
```
ans =

   0.318746   0.900866  -1.446499
   0.026590   0.309210   1.126516
  -2.061057   1.010726  -0.578107
  -0.293259   0.949766   0.867398
   0.451284  -0.204515   0.143379


```

Im Gegensatz zu C/C++, fangen wir bei Matlab immer bei 1 an zu zählen, und nicht bei 0. Der Doppelpunkt nach dem Komma gibt Auskunft darüber, dass alle Spalten ausgegeben werden sollen. Wenn nur die ersten beiden Spalten ausgegeben werden sollen kann man `V(1:5,1:2)` eingeben.

Alle Vektoren, bis auf die ersten 15 erhalten wir mit Hilfe des Wortes `end`, das für die Größe der jeweiligen Dimension steht:



{:.input_area}
```matlab
V(16:end,:)
```


{:.output .output_stream}
```
ans =

  -0.137679   0.700737  -0.476524
   0.040380   1.185899   0.217040
  -2.939838  -0.747825  -1.360955
  -0.900775   0.023616  -0.992987
   1.257438  -1.610587   0.475782


```

Ich kann mir auch jeden zweiten Vektor ausgeben lassen, indem ich eine ganzzahlige Schrittweite mit angebe:



{:.input_area}
```matlab
V(1:2:end,:)
```


{:.output .output_stream}
```
ans =

   0.318746   0.900866  -1.446499
  -2.061057   1.010726  -0.578107
   0.451284  -0.204515   0.143379
  -0.707674   1.659136  -0.461968
  -1.220751  -1.719768  -1.076727
   2.501248   0.999032  -1.084067
  -0.950251   0.436690   0.238668
   0.111207  -1.830164  -1.042425
   0.040380   1.185899   0.217040
  -0.900775   0.023616  -0.992987


```

Die Schrittweite kann auch negativ gewählt werden:



{:.input_area}
```matlab
V(end:-1:1,:)
```


{:.output .output_stream}
```
ans =

   1.257438  -1.610587   0.475782
  -0.900775   0.023616  -0.992987
  -2.939838  -0.747825  -1.360955
   0.040380   1.185899   0.217040
  -0.137679   0.700737  -0.476524
   0.111207  -1.830164  -1.042425
  -0.306860  -0.696183  -0.810347
  -0.950251   0.436690   0.238668
  -1.415780   1.025420  -0.221840
   2.501248   0.999032  -1.084067
  -0.146500  -0.052633  -0.851724
  -1.220751  -1.719768  -1.076727
   0.895087  -1.006398  -0.067532
  -0.707674   1.659136  -0.461968
  -1.009625   0.143004  -0.724636
   0.451284  -0.204515   0.143379
  -0.293259   0.949766   0.867398
  -2.061057   1.010726  -0.578107
   0.026590   0.309210   1.126516
   0.318746   0.900866  -1.446499


```

**Zusatzfrage:** Wie kann ich mir die letzten fünf Zeilen einer Matrix ausgeben lassen, ohne explizit die Größe der Matrix zu kennen?



{:.input_area}
```matlab
% get last 5 elements of V

```


## Logische Indizierung

Der folgende Befehl liefert Auskunft darüber, welche Elemente der Matrix `X` größer oder gleich null sind:



{:.input_area}
```matlab
X>=0
```


{:.output .output_stream}
```
ans =

  1
  1
  0
  0
  1
  0
  0
  1
  0
  0
  1
  0
  0
  0
  1
  0
  1
  0
  0
  1


```

Das Ergebnis ist wieder eine Matrix, dessen Einträge entweder 1 sind, falls der jeweilige Eintrag in `X` größer oder gleich null ist, oder 0 wenn der jeweilige Eintrag kleiner als null ist. Matlab speichert diese Werte nicht als `double`, sondern als `logical`-, d.h. boolsche Werte ab. Wir können dem Ergebnis der Abfrage wieder einen Namen geben:



{:.input_area}
```matlab
Xpos = X>0;
class(Xpos)
```


{:.output .output_stream}
```
ans = logical

```

Um nun alle Vektoren (Zeilen in `V`) zu erhalten, deren $x$-Komponente größer oder gleich null ist, kann diese `logical`-Matrix direkt als Zeilenindex verwenden.



{:.input_area}
```matlab
V(Xpos,:)
```


{:.output .output_stream}
```
ans =

   0.318746   0.900866  -1.446499
   0.026590   0.309210   1.126516
   0.451284  -0.204515   0.143379
   0.895087  -1.006398  -0.067532
   2.501248   0.999032  -1.084067
   0.111207  -1.830164  -1.042425
   0.040380   1.185899   0.217040
   1.257438  -1.610587   0.475782


```

**Zusatzfrage:** Was macht der folgende Befehl:



{:.input_area}
```matlab
V(V(:,2)<0,:)
```


{:.output .output_stream}
```
ans =

   0.451284  -0.204515   0.143379
   0.895087  -1.006398  -0.067532
  -1.220751  -1.719768  -1.076727
  -0.146500  -0.052633  -0.851724
  -0.306860  -0.696183  -0.810347
   0.111207  -1.830164  -1.042425
  -2.939838  -0.747825  -1.360955
   1.257438  -1.610587   0.475782


```

**Zusatzfrage:** Wie erhalte ich mit nur einem Befehl alle Vektoren, deren Betrag kleiner als 1 ist?



{:.input_area}
```matlab
% get all rows with a magnitude < 1

```


## Gleichungssysteme lösen

Natürlich bietet Matlab auch viele weitere Funktionen rund um Matrizen und Vektoren um uns das Leben zu erleichtern. So kann ein Gleichungssytem $A\cdot \mathbf{x} = \mathbf{b}$ einfach und effizient mit dem sogenannten **backslash**-Operator gelöst werden.



{:.input_area}
```matlab
A=[1,2,3;4,5,-6;7,8,9];
b=[0.1,0.2,0.3]';
x = A\b                     % x = inv(A)*b
```


{:.output .output_stream}
```
x =

  -3.3333e-02
   6.6667e-02
  -1.4456e-18


```

Also ist Matlab ein Taschenrechner? Ja, genau! Aber ein ziemlich cooler, mit extrem vielen Funktionen und der Möglichkeit beliebig viele Variablen als Matrizen im Zwischenspeicher vorzuhalten.

Matlab ist aber auch noch mehr, nämlich eine [Turing-vollständige Computersprache](http://lmgtfy.com/?q=turing+complete+progamming+language). Die Mächtigkeit von Matlab kommt erst zur Geltung, wenn wir anfangen Skripte und Funktionen zu schreiben.
