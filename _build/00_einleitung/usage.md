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

Ganz einfach: Lesen. Es gibt aber ein paar zusätzliche Features, die hier erklärt werden. Es wird auch darauf eingegangen, welche Software für diese features verwendet wird. Das soll nur als Zusatzinformationen dienen und ist für die Verwendung des Online Buches nicht relevant.

Alle Seiten, die Codeblöcke enthalten haben oben in der Kopfzeile zwei Buttons, einen auf dem "Thebelab" steht, und einen auf dem "Interact" steht.

<img src="../images/usage_buttons.png" alt="Interact buttons" style="width: 250px;"/>

Beide Buttons bewirken auf unterschiedliche Weise, dass der Matlab-Code in den Code-Blöcken editierbar und ausführbar wird. Im Hintergrund wird in einer virtuellen Maschine ein Octave Kern gestartet. Octave ist ein freier Matlab-Klon, der weitestgehend mit Matlab kompatibel ist.

## Thebelab

Die einfachste Möglichkeit, den Code auf dieser Seite zu editieren und auszuführen ist über Thebelab. Per Klick auf die Taste "run", wird der Code ausgeführt, mit "restart" wird der im Hintergrund laufende Octave-Kernel neu gestartet.

<img src="../images/usage_thebe.png" alt="Binder Loading Page" style="width: 800px;"/>

## Interact

Der Nachteil von der "Interact"-Methode ist, dass man von dieser Seite weggeführt wird. Der Vorteil ist, dass man auf die Inhalte über [Jupyter Lab](https://blog.jupyter.org/jupyterlab-is-ready-for-users-5a6f039b8906) zugreifen kann, eine Art Entwicklungsumgebung die im Browser läuft. 

<img src="../images/usage_binder.png" alt="Jupyter Lab Screenshot" style="width: 1200px;"/>

<img src="../images/usage_binder_launcher.png" alt="Jupyter Lab Screenshot 2" style="width: 1200px;"/>


Sie können nicht nur die Code-Blöcke editieren und ausführen, sie können auch neue Dokumente, wie z.B. m-files, erstellen oder hochladen, Dokumente herunterladen und eine Linux-Konsole starten. Das ganze funktioniert über ein [Docker-Container](https://de.wikipedia.org/wiki/Docker_(Software)), der über den [Binder](https://mybinder.org/) Service geladen wird. 

<img src="../images/attention.svg" alt="" style="width: 25px; display: inline;" />    **Wichtig: Das bedeutet insbesondere, dass alle erstellten Dateien und Änderungen nur temporär sind und nicht über eine Session hinaus erhalten bleiben!** Laden Sie unbedingt erstellte Dateien runter, bevor sie das Fenster schließen, oder noch besser, erstellen Sie Dateien offline auf ihren Computer und laden Sie sie hoch, wenn Sie sie in einer interaktiven Session verwenden möchten.

## Unit Testing

[*Unit-Testing*](http://lmgtfy.com/?q=unit+testing) ist aus moderner Software-Entwicklung nicht mehr wegzudenken. Sobald ein Software-Paket etwas größer wird und aus einer Vielzahl von Modulen, Bibliotheken, Funktionen und Skripten besteht, sollte regelmäßig getestet werden, ob die Module noch so funktionieren wie erwartet. Unit Tests sind im wesentlichen kleine Programme, die diese Module auf ihrer Funktionsfähigkeit prüfen. Ein weit verbreitetes [Programmierparadigma](https://de.wikipedia.org/wiki/Testgetriebene_Entwicklung) besagt sogar, dass man erst die Unit Tests schreiben soll, bevor man das Modul erstellt.

Auch Matlab und Octave bieten Möglichkeiten für Unit Tests an. Für die meisten Übungsaufgaben müssen Matlabskripte bzw. -funktionen erstellt werden. Auf dieser Seite werden für diese Übungsaufgaben Unit Tests zur Verfügung gestellt, mit der selbst erstellte Skripte auf ihre Richtigkeit überprüft werden können. Die Unit Testing Funktionalitäten von Matlab und Octave sind nicht kompatibel untereinander, deshalb basieren die Unit Tests auf dieser Seite auf die [MOxUnit](https://github.com/MOxUnit/MOxUnit), ein externes open source unit testing framework, das sowohl mit Matlab als auch Octave kompatibel ist.

*To Do*

## Troubleshooting

Falls es Probleme oder Verbesserungsvorschläge gibt, freue ich mich über eine [Email](mailto:jan.kleinert@h-brs.de) oder noch besser, über einen Eintrag im [Issue tracker](https://github.com/joergbrech/Modellbildung-und-Simulation/issues) auf Github.

**Bekannte Probleme:**
1. Wenn ich auf `run` klicke, steht da nur `Waiting for kernel...` und nichts passiert.

   <img src="../images/usage_waiting.png" alt="Drawing" style="width: 400px;"/>

   *Lösung:* Geduld. Wahrscheinlich wurden gerade Änderungen an diesem Buch vorgenommen und Sie sind die erste Person, die seitdem interaktive Inhalte nutzen wollen. Damit haben sie ein *rebuild des binder image getriggert*. Das kann schon mal eine Weile dauern. Dasselbe gilt für die "Interact" Funktion. Hier erhält man aber ausführlichere Informationen über eine Konsolenausgabe beim Start.
   
   <img src="../images/usage_binder_waiting.png" alt="Binder Loading Page" style="width: 1200px;"/>
   
2. Wenn ich einen Code-Block starte, erhalte ich eine seltsame Fehlermeldung, die nicht nach Octave oder Matlab aussieht.

   *Lösung:* Ab und zu wird der Code fälschlicherweise an einen *Python*-interpreter übergeben. In solchen Fällen hilft es, die Seite neu zuladen.
