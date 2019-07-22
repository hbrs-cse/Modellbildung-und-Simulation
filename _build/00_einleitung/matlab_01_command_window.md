---
redirect_from:
  - "/00-einleitung/matlab-01-command-window"
interact_link: content/00_einleitung/matlab_01_command_window.ipynb
kernel_name: octave
has_widgets: false
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


<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
a = 5
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
a =  5
```
</div>
</div>
</div>

MATLAB gibt nach Eingabe eines Kommandos immer eine Rückmeldung, in diesem Fall wird die Variable noch einmal ausgegeben. Diese Rückmeldung kann mit Hilfe des Semikolons unterdrückt werden:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
b = 2*pi;
```
</div>

</div>

Beide Variablen sind nun im Workspace hinterlegt, und können für weitere Berechnungen benutzt werden. Ich kann mir zum Beispiel den Wert von ```b``` ausgeben lassen,

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
b
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
b =  6.2832
```
</div>
</div>
</div>

oder einfache Rechenoperationen ausführen:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
b/a + 1i*sin(pi/8)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =  1.25664 + 0.38268i
```
</div>
</div>
</div>

Das Ergebnis der Rechnung wird unter dem Variablennamen ```ans``` im Workspace hinterlegt. Ich kann dem Ergebnis explizit einen Variablennamen, hier ```c``` zuordnen:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
c = b/a + 1i*sin(pi/8)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
c =  1.25664 + 0.38268i
```
</div>
</div>
</div>

Wenn ich möchte, kann ich die Ausgabe des Ergebnisses unterdrücken, indem ich die Zeile mit einem Semikolon beende:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
d = exp(b/a - i*sin(pi/8));
```
</div>

</div>

Einige wichtige Punkte konnten wir bisher beobachten:

* Variablenzuweisungen passieren von links nach rechts: Was rechts vom Gleichheitszeichen steht, wird der Variablen die links vom Gleichheitszeichen steht zugeordnet. Wenn es diese Variable nicht gibt, wird sie im Workspace hinterlegt.
* Matlab bietet eine Vielzahl von mathematischen Funktionen an, die regelmäßig gebraucht werden, wie z.B. die Exponentialfunktion ```exp``` oder das Rechnen mit komplexen Zahlen. Dabei können sowohl `1i`, `1j` als auch `i` und `j` als Symbole für die komplexe Einheit verwendet werden. Die letzten beiden Varianten sind aber potenziell gefährlich, da es auch valide Variablennamen sind und es so zu Verwechslungen kommen kann.
* Alle Variablen werden im Workspace hinterlegt und können anschließend für weitere Berechnungen verwendet werden.
* In Matlab werden die skalaren Datentypen (```integer```, ```double```, ```float```, ...) nicht explizit angegeben, wie man es von Sprachen wie C oder C++ vielleicht gewöhnt ist. Auch wenn die Variablen ```a``` ganzzahlig ist, geht Matlab standardmäßig von ```double``` aus. Der Typ einer Variable lässt sich in Matlab durch die Funktion ```class()``` ausgeben:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
class(a)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans = double
```
</div>
</div>
</div>

Unter Umständen kann es sinnvoll sein, nochmal mit einem frischen *Workspace* zu starten. Der Inhalt des Workspace lässt sich mit dem Befehl `clear` leeren.

## Vektoren und Matrizen

Matlab ist ein Kofferwort aus **Mat**rix-**Lab**oratory. Der Name impliziert schon, dass es sich ideal dazu eignet mit Matrizen und Vektoren zu arbeiten. Dabei wird nicht zwischen den beiden unterschieden: Ein Zeilenvektor mit $n$ Einträgen ist einfach eine Matrix aus $\mathbb{R}^{1 \times n}$, während ein Spaltenvektor mit $n$ Einträgen eine Matrix aus $\mathbb{R}^{n \times 1}$ ist.

In Matlab werden Matrizen mit eckigen Klammern geschrieben, ein Semikolon beendet eine Zeile:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
e = [1, 2, 3, 4, 5] % ein Zeilenvektor
f = [1; 2; 3; 4; 5] % ein Spaltenvektor
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
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
</div>
</div>
</div>

## Produkte von Vektoren und Matrizen

Beim Produkt zweier Vektoren $\mathbf{e}$ und $\mathbf{f}$ (bzw. Matrixprodukt zweier Matrizen) ist stets darauf zu achten, dass die Dimensionen zueinander passen! Kann ich die eben erstellten Vektoren $e$ und $f$ miteinander multiplizieren?

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
e*f
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =  55
```
</div>
</div>
</div>

Aha, bei Multiplikation eines $(1,n)$-dimensionalen Vektors $\mathbf{e}$ mit einem $(n,1)$-dimensionalen Vektor $\mathbf{f}$ erhalte ich eine Zahl, bzw. eine $(1,1)$-dimensionale Matrix mit nur einem Eintrag. Wir erhalten das **Skalarprodukt**

$$ \mathbf{e} \cdot \mathbf{f} = \sum_{i=1}^n e_i \cdot f_i. $$

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
f*e
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

    1    2    3    4    5
    2    4    6    8   10
    3    6    9   12   15
    4    8   12   16   20
    5   10   15   20   25

```
</div>
</div>
</div>

Die Multiplikation eines $(n,1)$-dimensionalen Vektors $\mathbf{f}$ mit einem $(1,n)$-dimensionalen Vektor $\mathbf{e}$ liefert also eine $(n,n)$-dimensionale Matrix. Es handelt sich um das **diadische Produkt**

$$ A = \mathbf{f} \cdot \mathbf{e}, \hskip0.5cm A_{ij} = f_i \cdot e_j $$

Wie sieht es mit den folgenden Matrizen aus?

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
g = [1; 1; 1];
h = [2; 2; 2];
g*h
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
error: operator *: nonconformant arguments (op1 is 3x1, op2 is 3x1)
```
</div>
</div>
</div>

Nein! Es klappt nicht. Die Fehlermeldung gibt schon Auskunft darüber wieso, die Dimensionen der Matrizen passen nicht zusammen. 

*Hinweis:* Hier ist der Wortlaut der Octave-Fehlermeldung zu sehen. Matlab gibt an dieser Stelle die folgende Fehlermeldung wieder:

```
Error using  * 
Incorrect dimensions for matrix multiplication. Check that the number of columns in
the first matrix matches the number of rows in the second matrix. To perform
elementwise multiplication, use '.*'.
```

Wir behelfen uns eines Tricks: Ein nachgestelltes Apostroph gibt die transponierte Matrix aus:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
g
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
g =

   1
   1
   1

```
</div>
</div>
</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
size(g)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

   3   1

```
</div>
</div>
</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
g'
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

   1   1   1

```
</div>
</div>
</div>

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
size(g')
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

   1   3

```
</div>
</div>
</div>

Das Skalarprodukt von $\mathbf{g}$ mit $\mathbf{h}$ können wir also doch ausrechnen:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
g'*h
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =  6
```
</div>
</div>
</div>

Sehr häufig ist es nützlich, Operationen komponentenweise auszuführen. Nehmen wir zum Beispiel an, in einer kleinen Arbeitsgruppe arbeiten fünf Personen. Zwei Mitarbeiter haben Vollzeitstellen, d.h. 39,5 Stunden pro Woche, einer hat eine halbe Stelle und zwei studentische Hilfskräfte unterstützen jeweils mit acht Stunden pro Woche. Die wöchentliche Arbeitszeit der Mitarbeiter hinterlegen wir in einem Vektor

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
weekly_hours = [39.5, 19.5, 39.5, 8, 8];
```
</div>

</div>

Die stündlichen Bruttokosten der Mitarbeiterstellen in € schreiben wir ebenfalls in einen Vektor:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
costPerHour_brutto_euro = [57.5, 57.5, 40, 15, 15];
```
</div>

</div>

Wenn ich wissen möchte, wieviel die Mitarbeiter jeweils pro Woche kosten, muss ich die Vektoren komponentenweise miteinander multiplizieren. Das erreiche ich in Matlab, indem ich vor dem ```*```-Operator einen Punkt voranstelle, es ist also eine *punktweise* Operation, und keine Matrixmultiplikation:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
weekly_hours.*costPerHour_brutto_euro
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

   2271.25   1121.25   1580.00    120.00    120.00

```
</div>
</div>
</div>

**Quiz:** Wie berechne ich die Gesamtkosten aller Mitarbeiter pro Woche mit nur einer Zeile in Matlab? *Hinweis: Das Ergebnis lautet 5212,5 €.*

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
% calculate weekly total cost

```
</div>

</div>

## Spezielle Matrizen

Matlab hat einige Befehle, um spezielle Matrizen zu erstellen. Einige der wichtigsten sind:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
A1 = eye(2);     % 2,2-Einheitsmatrix
A2 = ones(3,2);  % 3,2-Matrix gefuellt mit 1
A3 = zeros(2,4); % 2,4-Matrix gefuellt mit 0
A4 = rand(2);    % 2,2-Matrix mit gleichverteilten Zufallszahlen von 0 bis 1
A5 = randn(4);   % 4,4-Matrix mit normalverteilten Zufallszahlen um 0 und Standardabweichung 1
```
</div>

</div>

## Funktionen komponentenweise ausführen

Viele der mathematischen Funktionen, wie `sin`, `cos`, `exp`, `sqrt` etc., können auch direkt auf Vektoren und Matrizen angewandt werden. Sie werden dann komponentenweise ausgeführt:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
A4
disp('Die Wurzel der Elemente von A4:')
sqrt(A4)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
A4 =

   0.902136   0.075642
   0.686556   0.399885

Die Wurzel der Elemente von A4:
ans =

   0.94981   0.27503
   0.82859   0.63236

```
</div>
</div>
</div>

Nehmen wir zum Beispiel an, wir haben $n$ Vektoren $\mathbf{v}_i = (x_i, y_i, z_i)$, $i=1,...,n$. Wenn wir die $x$-, $y$-, und $z$-Komponenten der Vektoren als `X`, `Y` und `Z` speichern, können wir in nur einer Zeile den Betrag der Vektoren berechnen:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
n=20;
X = randn(n,1);
Y = randn(n,1);
Z = randn(n,1);
% calculate magnitude of vectors
sqrt(X.^2 + Y.^2 + Z.^2)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

   3.13487
   0.99205
   2.25956
   2.85939
   0.52927
   0.90552
   1.28791
   1.30450
   1.13228
   1.93397
   0.84716
   1.47221
   0.69851
   1.66239
   1.29021
   2.01736
   2.24273
   1.51946
   0.78813
   2.42039

```
</div>
</div>
</div>

**Zusatzfrage:** Wozu dienen die Punkte in der Vorschrift `sqrt(X.^2 + Y.^2 + Z.^2)`?

## Concatenation und Slicing

Oft kann es sinnvoll sein, einzelne Vektoren oder Matrizen zu größeren zusammenzufügen. Das nennt man *Concatenation*. Die zuvor erstellten Matrizen `X`, `Y`, `Z` sind schließlich nicht unabhängig von einander, sie bezeichnen die Komponenten von $n$ Vektoren $v_i$. Um dies zu verdeutlichen, können wir eine $(n,3)$-Matrix erstellen, deren Zeilen die jeweiligen Vektoren $v_i$ sind, und die Spalten die jeweiligen Komponenten `X`, `Y` und `Z`:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
V = [X,Y,Z]
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
V =

  -3.019795   0.434514   0.720747
  -0.265533   0.097343  -0.950886
   0.894989   1.914294   0.800064
  -2.697906   0.300665   0.898349
  -0.083736   0.400069   0.336239
  -0.357997  -0.675456  -0.485356
  -0.696160  -1.005352   0.404150
  -0.614755  -1.149692   0.044734
  -0.771785   0.724196   0.402418
  -1.436569  -0.637793   1.126824
   0.144118  -0.373410  -0.746646
  -0.329917  -0.430427   1.368680
   0.513278  -0.395825  -0.260358
   1.464365  -0.444932  -0.649004
   1.129131   0.456939   0.425324
  -1.874085   0.379074  -0.643297
   1.613523  -1.536201   0.257822
  -1.110248   1.028797   0.133014
   0.542083   0.251091   0.514044
   0.964465   1.681427   1.449456

```
</div>
</div>
</div>

Wie bei Matrixprodukten müssen wir auf die richtige Dimension achten. Was passiert genau bei folgendem Befehl?

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
V = [X,Y;Z]
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
error: vertical dimensions mismatch (20x2 vs 20x1)
```
</div>
</div>
</div>

*Concatenation* ist also das Zusammenfügen von Matrizen. Der gezielte Zugriff auf Subblöcke aus einer Matrix wird als *Slicing* bezeichnet. In Matlab wird dazu der `:`-Operator verwendet. Mit folgenden Befehlen erhält man die ersten fünf Zeilen der Matrix `V`:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
V(1:5,:)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

  -3.019795   0.434514   0.720747
  -0.265533   0.097343  -0.950886
   0.894989   1.914294   0.800064
  -2.697906   0.300665   0.898349
  -0.083736   0.400069   0.336239

```
</div>
</div>
</div>

Im Gegensatz zu C/C++, fangen wir bei Matlab immer bei 1 an zu zählen, und nicht bei 0. Der Doppelpunkt nach dem Komma gibt Auskunft darüber, dass alle Spalten ausgegeben werden sollen. Wenn nur die ersten beiden Spalten ausgegeben werden sollen kann man `V(1:5,1:2)` eingeben.

Alle Vektoren, bis auf die ersten 15, erhalten wir mit Hilfe des Wortes `end`, das für die Größe der jeweiligen Dimension steht:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
V(16:end,:)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

  -1.87409   0.37907  -0.64330
   1.61352  -1.53620   0.25782
  -1.11025   1.02880   0.13301
   0.54208   0.25109   0.51404
   0.96446   1.68143   1.44946

```
</div>
</div>
</div>

Ich kann mir auch jeden zweiten Vektor ausgeben lassen, indem ich eine ganzzahlige Schrittweite mit angebe:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
V(1:2:end,:)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

  -3.019795   0.434514   0.720747
   0.894989   1.914294   0.800064
  -0.083736   0.400069   0.336239
  -0.696160  -1.005352   0.404150
  -0.771785   0.724196   0.402418
   0.144118  -0.373410  -0.746646
   0.513278  -0.395825  -0.260358
   1.129131   0.456939   0.425324
   1.613523  -1.536201   0.257822
   0.542083   0.251091   0.514044

```
</div>
</div>
</div>

Die Schrittweite kann auch negativ gewählt werden:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
V(end:-1:1,:)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

   0.964465   1.681427   1.449456
   0.542083   0.251091   0.514044
  -1.110248   1.028797   0.133014
   1.613523  -1.536201   0.257822
  -1.874085   0.379074  -0.643297
   1.129131   0.456939   0.425324
   1.464365  -0.444932  -0.649004
   0.513278  -0.395825  -0.260358
  -0.329917  -0.430427   1.368680
   0.144118  -0.373410  -0.746646
  -1.436569  -0.637793   1.126824
  -0.771785   0.724196   0.402418
  -0.614755  -1.149692   0.044734
  -0.696160  -1.005352   0.404150
  -0.357997  -0.675456  -0.485356
  -0.083736   0.400069   0.336239
  -2.697906   0.300665   0.898349
   0.894989   1.914294   0.800064
  -0.265533   0.097343  -0.950886
  -3.019795   0.434514   0.720747

```
</div>
</div>
</div>

**Zusatzfrage:** Wie kann ich mir die letzten fünf Zeilen einer Matrix ausgeben lassen, ohne explizit die Größe der Matrix zu kennen?

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
% get last 5 elements of V

```
</div>

</div>

## Logische Indizierung

Der folgende Befehl liefert Auskunft darüber, welche Elemente der Matrix `X` größer oder gleich null sind:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
X>=0
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

  0
  0
  1
  0
  0
  0
  0
  0
  0
  0
  1
  0
  1
  1
  1
  0
  1
  0
  1
  1

```
</div>
</div>
</div>

Das Ergebnis ist wieder eine Matrix, deren Einträge entweder 1 sind, falls der jeweilige Eintrag in `X` größer oder gleich null ist, oder 0 wenn der jeweilige Eintrag kleiner als null ist. Matlab speichert diese Werte nicht als `double` ab, sondern als `logical`-, d.h. boolsche Werte. Wir können dem Ergebnis der Abfrage wieder einen Namen geben:

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
Xpos = X>0;
class(Xpos)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans = logical
```
</div>
</div>
</div>

Um nun alle Vektoren (Zeilen in `V`) zu erhalten, deren $x$-Komponente größer oder gleich null ist, kann diese `logical`-Matrix direkt als Zeilenindex verwendet werden.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
V(Xpos,:)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

   0.89499   1.91429   0.80006
   0.14412  -0.37341  -0.74665
   0.51328  -0.39583  -0.26036
   1.46436  -0.44493  -0.64900
   1.12913   0.45694   0.42532
   1.61352  -1.53620   0.25782
   0.54208   0.25109   0.51404
   0.96446   1.68143   1.44946

```
</div>
</div>
</div>

**Zusatzfrage:** Was macht der folgende Befehl?

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
V(V(:,2)<0,:)
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
ans =

  -0.357997  -0.675456  -0.485356
  -0.696160  -1.005352   0.404150
  -0.614755  -1.149692   0.044734
  -1.436569  -0.637793   1.126824
   0.144118  -0.373410  -0.746646
  -0.329917  -0.430427   1.368680
   0.513278  -0.395825  -0.260358
   1.464365  -0.444932  -0.649004
   1.613523  -1.536201   0.257822

```
</div>
</div>
</div>

**Zusatzfrage:** Wie erhalte ich mit nur einem Befehl alle Vektoren, deren Betrag kleiner als 1 ist?

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
% get all rows with a magnitude < 1

```
</div>

</div>

Denken Sie daran, dass die Gleichheit zweier Variablen mit `==` abgefragt wird!

## Gleichungssysteme lösen

Natürlich bietet Matlab auch viele weitere Funktionen rund um Matrizen und Vektoren, um uns das Leben zu erleichtern. So kann ein Gleichungssystem $A\cdot \mathbf{x} = \mathbf{b}$ einfach und effizient mit dem sogenannten **backslash**-Operator gelöst werden.

<div markdown="1" class="cell code_cell">
<div class="input_area" markdown="1">
```matlab
A=[1,2,3;4,5,-6;7,8,9];
b=[0.1,0.2,0.3]';
x = A\b                     % x = inv(A)*b
```
</div>

<div class="output_wrapper" markdown="1">
<div class="output_subarea" markdown="1">
{:.output_stream}
```
x =

  -3.3333e-02
   6.6667e-02
  -1.4456e-18

```
</div>
</div>
</div>

Also ist Matlab ein Taschenrechner? Ja, genau! Aber ein ziemlich cooler, mit extrem vielen Funktionen und der Möglichkeit beliebig viele Variablen als Matrizen im Zwischenspeicher vorzuhalten.

Matlab ist aber auch noch mehr, nämlich eine [Turing-vollständige Computersprache](http://lmgtfy.com/?q=turing+complete+progamming+language). Die Mächtigkeit von Matlab kommt erst zur Geltung, wenn wir anfangen Skripte und Funktionen zu schreiben.
