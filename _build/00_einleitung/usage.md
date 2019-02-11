---
redirect_from:
  - "/00-einleitung/usage"
title: 'Verwendung des Buches'
prev_page:
  url: /00_einleitung/intro
  title: 'Einleitung'
next_page:
  url: /00_einleitung/matlab_00_first_steps
  title: 'Erste Schritte in Matlab'
comment: "***PROGRAMMATICALLY GENERATED, DO NOT EDIT. SEE ORIGINAL FILES IN /content***"
---
# Verwendung dieses Buches

Ganz einfach: Lesen.

Es gibt aber ein paar zusätzliche Features, die hier erklärt werden. Alle Seiten, die Codeblöcke enthalten haben oben in der Kopfzeile zwei Buttons, einen auf dem "Thebelab" steht, und einen auf dem "Interact" steht.

<img src="../images/usage_buttons.png" alt="Interact buttons" style="width: 250px;"/>

Beide Buttons bewirken auf unterschiedliche Weise, dass der Matlab-Code in den Code-Blöcken editierbar und ausführbar wird.

## Thebelab

Die einfachste Möglichkeit, den Code auf dieser Seite zu editieren und auszuführen ist über Thebelab. Per Klick auf die Taste "run", wird der Code ausgeführt, mit "restart" wird der im Hintergrund laufende Octave-Kernel neu gestartet.

<img src="../images/usage_thebe.png" alt="Binder Loading Page" style="width: 800px;"/>

## Interact

*To Do*

## Unit Testing

[*Unit-Testing*](http://lmgtfy.com/?q=unit+testing) ist aus moderner Software-Entwicklung nicht mehr wegzudenken. Sobald ein Software-Paket etwas größer wird und aus einer Vielzahl von Modulen, Bibliotheken, Funktionen und Skripten besteht, sollte regelmäßig getestet werden, ob die Module nach Änderungen noch so funktionieren wie erwartet. Unit Tests sind im wesentlichen kleine Programme, die wenn sie ausgeführt sind diese Module auf ihrer Funktionsfähigkeit prüfen. Es gibt auch Programmierparadigmen die besagen, dass man erst den Test schreiben soll, bevor man das Modul erstellt.

Auch Matlab bietet Möglichkeiten für Unit Tests an. Für die meisten Übungsaufgaben müssen Matlabskripte bzw. -funktionen erstellt werden. Auf dieser Seite werden für diese Übungsaufgaben Unit tests zur Verfügung gestellt, die die erstellten Skripte auf ihre Richtigkeit testet.

*To Do*

## Troubleshooting

Falls es Probleme oder Verbesserungsvorschläge gibt, freue ich mich über eine [Email](mailto:jan.kleinert@h-brs.de) oder noch besser, über einen Eintrag im [Issue tracker](https://github.com/joergbrech/Modellbildung-und-Simulation/issues) auf Github.

**Bekannte Probleme:**
1. Wenn ich auf `run` klicke, steht da nur `Waiting for kernel...` und nichts passiert.

   <img src="../images/usage_waiting.png" alt="Drawing" style="width: 400px;"/>

   *Lösung:* Geduld. Wahrscheinlich wurden gerade Änderungen an diesem Buch vorgenommen und Sie sind die erste Person, die seitdem interaktive Inhalte nutzen wollen. Damit haben sie ein *rebuild des binder image getriggert*. Das kann schonmal dauern. Dasselbe gilt für die "Interact" Funktion. Hier erhält man aber ausführlichere Informationen über eine Konsolenausgabe beim Start.
   
   <img src="../images/usage_binder_waiting.png" alt="Binder Loading Page" style="width: 1200px;"/>
   
2. Wenn ich einen Code-Block starte, erhalte ich eine seltsame Fehlermeldung, die nicht nach Octave oder Matlab aussieht.

   *Lösung:* Ab und zu wird der Code fälschlicherweise an einen *Python*-interpreter übergeben. In solchen Fällen hilft es, die Seite neu zuladen.
