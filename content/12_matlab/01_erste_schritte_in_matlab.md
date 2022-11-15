````{panels}
Voraussetzungen
^^^
- keine
---

Lerninhalte
^^^
- Kennenlernen von Matlab
````

(erste_schritte)=
# Matlab einrichten

[Matlab](https://de.wikipedia.org/wiki/Matlab) ist eine interpretierte Skriptsprache, die insbesondere für numerische Berechnungen, Modellbildung und Simulation verwendet wird. Interpretierte Skriptsprachen zeichnen sich dadurch aus, dass sie von speziellen Computerprogrammen, sogenannten *Interpretern*, direkt interpretiert und ausgeführt werden. Im Kontrast dazu stehen Sprachen wie C/C++, die zunächst von einem Compiler in eine maschinenlesbare Datei übersetzt werden müssen.

```{image} images/Matlab_Logo.png
:alt: Matlab Logo
:width: 200px
:align: center
```
<div style="text-align: right"> "Matlab Logo", <a href="https://commons.wikimedia.org/wiki/User:Jarekt" >Jarekt</a>, <a href="https://en.wikipedia.org/wiki/Public_domain" >[Public domain]</a> via <a href="https://commons.wikimedia.org/wiki/File:Matlab_Logo.png">Wikimedia Commons</a></div> <br>

Die Sprache wird von [The Mathworks Inc.](https://de.wikipedia.org/wiki/The_MathWorks) entwickelt. Dieses Unternehmen vertreibt kommerziell die gleichnamige Entwicklungsumgebung und den gleichnamigen Interpreter.

## Matlab Alternativen

Matlab ist nicht kostengünstig. Es gibt aber frei verfügbare Alternativen. Zum Beispiel gibt es die kostenfreien Matlab-Klone [Octave](http://www.octave.org) oder [Scilab](http://www.scilab.org). Octave- bzw. Scilab-Skripte sind weitestgehend mit Matlab kompatibel. 

An einigen Stellen dieses Online-Lehrbuchs tauchen Textboxen mit Matlab-Code auf, der sich interaktiv ausführen lässt. Die Umsetzung basiert auf einem Octave-Kern, der im Hintergrund auf einer virtuellen Maschine läuft. [Hier](https://en.wikibooks.org/wiki/MATLAB_Programming/Differences_between_Octave_and_MATLAB) finden Sie eine Liste syntaktischer Unterschiede zwischen Octave und Matlab.

Neben Octave und Matlab gibt es eine Vielzahl weiterer Skriptsprachen, die man ebenso verwenden könnte. Die drei am weitesten verbreiteten, frei verfügbaren Sprachen aus dem Bereich des wissenschaftlichen Rechnens sind wahrscheinlich 
 * [Python](https://www.python.org/) - Extrem vielseitige und weitverbreitete Sprache.
 * [R](https://www.r-project.org/) - Insbesondere für statistische Anwendungen geeignet
 * [Julia](https://julialang.org/) - Spricht R- und Matlabnutzer an. Streng genommen keine interpretierte Sprache, es kommt ein sogenannter *Just-In-Time-Compiler* zum Einsatz.
 

Warum soll ich also das kostenpflichtige Matlab verwenden, wenn es so viele kostenfreie Alternativen gibt? Zugegeben, sehr viele Argumente fallen uns nicht ein. Es gibt dennoch ein paar sehr gute Gründe Matlab zu benutzen: 
1. Es ist eine ausgereifte, vielseitige, robuste und einfach zu erlernende Skriptsprache, mit der man in sehr kurzer Zeit komplexe Modelle erstellen kann.
2. Die sehr gute Benutzerumgebung liefert viele praktische Werkzeuge wie Profiler oder Debugging Tools.
2. Studenten erhalten in der Regel kostenfrei Zugang zu einer Campuslizenz.

Also: Matlab ist super! Bevor man aber ganz viel Geld ausgibt, lohnt sich ein Blick auf die Alternativen.

## Installation

Es gibt verschiedene Wege mit Matlab zu arbeiten.

 * **Installation des Software-Pakets**: Das ist mit Sicherheit der sinnvollste Weg, wenn man viel mit Matlab arbeitet. Für Studenten der Hochschule Bonn-Rhein-Sieg wird [hier](https://www.h-brs.de/de/emt/matlab) beschrieben, wie man Matlab installiert und über die Campuslizenz aktiviert. Am Fachbereich 3 der Hochschule Bonn-Rhein-Sieg ist auf allen Computern der Räume B107 und B114 bereits Matlab installiert.
 * **Matlab Online**: Inzwischen gibt es eine [browser-basierte Version von Matlab](https://matlab.mathworks.com/), die ohne Installation funktioniert. Hierfür muss man sich nur über seinen MathWorks-Account einloggen und dort eine valide Lizenz hinterlegt haben.
 * **Matlab Mobile**: Es gibt eine [App von MathWorks](https://play.google.com/store/apps/details?id=com.mathworks.matlabmobile&hl=de), die sich anfühlt wie Matlab. Kommandos werden übers Internet zu einem Server geschickt, dort ausgeführt und das Ergebnis wird auf dem Smartphone angezeigt.

## Basics

In diesem Lehrbuch geht es hauptsächlich um Methodik und weniger um die Computersprache, in der die Algorithmen umgesetzt werden. Es ist also nicht Ziel, das drölfmillionste Tutorial für Matlab zur Verfügung zu stellen. Hierfür gibt es bereits viele sehr gute Anlaufstellen:

* [Matlab Onramp - **Sehr empfehlenswert**](https://de.mathworks.com/learn/tutorials/matlab-onramp.html)
* [https://matlabacademy.mathworks.com/](https://matlabacademy.mathworks.com/)
* [http://www.mathworks.com/videos/](http://www.mathworks.com/videos/)
* [http://www.mathworks.de/academia/student_center/tutorials](http://www.mathworks.de/academia/student_center/tutorials)
* [http://www.mathworks.com/academia/courseware](http://www.mathworks.com/academia/courseware)
* [http://www.mathworks.de/matlabcentral/fileexchange/](http://www.mathworks.de/matlabcentral/fileexchange/)
* [let me google that for you...](http://lmgtfy.com/?q=matlab+tutorial+beginner)


Genauso hilft immer ein Blick in die Dokumentation. Nichtsdestotrotz sollen hier die absoluten Basics einmal beschrieben werden. Die wichtigsten Fenster von Matlab werden am Anfang das *Command Window*, der *Editor* und der *Workspace* sein. 

```{image} images/matlabonline.PNG
:alt: Matlab Screenshot
:width: 1200px
:align: center
```
