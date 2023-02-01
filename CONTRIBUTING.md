# Contribution Guide

The style guide can be found in the [wiki tab](https://github.com/hbrs-cse/Modellbildung-und-Simulation/wiki).

<details>
<summary>## Project Goals</summary>
 
The goal of the Modellbildung und Simulation Buchprojekt is to create a relatable, intuitive and application-oriented introduction to modelling and simulation with low entry barriers. Its focus are the basics of physical modelling and the mathematics and programming aspects of numerical simulation.
 
*"Mit diesem Projekt wollen wir unsere Erfahrungen in der Vermittlung von Inhalten der mathematisch-physikalischen Modellierung für technische Bachelor-Studierende durch einen integralen Ansatz zusammenführen. Wir wollen gleichzeitig eine Lücke in der Unterstützung von Studierenden mit geeignetem Lehrmaterial schließen, das optimal auf die Zielgruppe abgestimmt ist. Das bedeutet, dass wir methodisches und theorielastiges Handwerkszeug zwar stringent vermitteln wollen, dabei aber so eng wie möglich die Anwendungsmöglichkeiten mit in den Blick nehmen wollen. Dies soll zudem möglichst modern, mit interaktivem Online-Content und durch viele nützliche Querverweise, gelingen."*
 
</details>

<details>
<summary>## Initial Setup</summary>

I have tested this on Linux, though it should work on Windows and Mac as well. For Windows 10, working with the [Windows Linux Subsystem](https://docs.microsoft.com/en-us/windows/wsl/install-win10) works really well, so I suggest you install e.g. **Ubuntu 18.04** on your Windows machine.

I suggest installing [miniconda3](https://docs.conda.io/en/latest/miniconda.html) via the provided bash script. It is a very good package manager that comes with Python and allows the creation of environments. This is *not really* necessary, but some of the commands below assume you have `conda` installed on your system.

#### Install prerequisites

This website is based on Jupyter-book, which lets you create a static website out of Markdown files and Jupyter notebooks. The Jupyter notebooks here use the Octave kernel. The webpage creation is done with ruby. So first, we need to install these prerequisites with `apt-get` and `conda`:

Install octave, jupyter and optionally jupyterlab:

```bash
sudo apt-get install octave
conda install jupyter jupyterlab
```


#### Install MOxUnit

For some Matlab exercises, unit tests are provided. This page teaches Matlab but uses Octave under the hood. Because the unit testing frameworks of Matlab and Octave are not
compatible to each other, we have to use a free unit testing framework that works with both Matlab and Octave, namely MOxUnit

```bash
git clone https://github.com/MOxUnit/MOxUnit
cd MOxUnit
make install
cd ..
```

#### Clone this repository to your local machine

 ```bash
 git clone https://github.com/hbrs-cse/Modellbildung-und-Simulation
 cd Modellbildung-und-Simulation
 ```
 
Now install the python requirements:

```bash
pip install -r requirements.txt
```

</details>

<details>
<summary>## Contribution Workflow</summary>

In this section, it is assumed that you are in the root directory of your clone of this repository, i.e. in `Modellbildung-und-Simulation`.

#### Create a feature branch
 
 * Switch to the master branch and fetch the latest changes from this repository
 ```bash
 git checkout master
 git pull
 ```
 * Create a new branch and switch to it
 ```bash
 git checkout -b my-awesome-new-page
 ```
 
#### Create or modify content

 * Navigate into the `content` subdirectory of the repository and create some markdown files and jupyter notebooks.
 ```bash
 cd content
 jupyter-lab .
 ```
 Jupyter-lab (or jupyter-notebook) runs in the browser. If your browser does not start automatically, you might have to copy the url from the command line output to your favorite browser. 
 * Create new Markdown files or jupyter notebooks or edit the ones that are already there. Check the [wiki](https://github.com/hbrs-cse/Modellbildung-und-Simulation/wiki) for writing conventions *(in German)*.
 * Most likely, these are the only places where changes need to be made. For more sophisticated changes, checkout the [jupyter-book documentation](https://jupyterbook.org/start/overview.html) and the [demo notebook](https://jupyterbook.org/intro.html).
 * Back in the root directory, run
 ```bash
 jupyter-book toc from-project -e .ipynb -e .md -f jb-book content/ > content/_toc.yml
 ```
 to automatically generate the table of contents based on the page titles. Then run
 ```bash
 jupyter-book build content/
 ```
 to convert the Jupyter notebooks and markdown files and copy the results to the `content/_build` directory. **Make sure this command executes without warnings.**
 
#### Review your changes and push them upstream
 
 * Checkout the generated html files in `content/_build/html`.
 * Stage and commit your changes:
 ```bash
 git add .
 git commit -m "added another really awesome page"
 ```

 * Push your changes to this repository to publish the changes. If your newly created branch `my-awesome-new-page` only exists locally, you need to associate a new upstream branch to your local copy.
 ```bash
 git push -u origin HEAD
 ```
 This only needs to be done once per branch. Afterwards,
 ```bash
 git push
 ```
 suffices.
 * Once you are fully satisfied with the changes, go to Github and create a Pull-Request from your branch.

#### Review the final result online

This repository uses Circle CI to build a demo site with each `git push`. This way you can see the effect that your commits will have on the website, even before your changes are merged into the master branch.
To view the demo site, click on *"Details"* next to the check *"ci/circleci:html_demo artifact"*.

![PR Status](./docs/media/pr_status.png)

If the book generation failed for some reason, there will be a red cross instead of a green check mark. You can click on the red cross to see what went wrong.

</details>

<details>
<summary>## Tips and best practices</summary>

Hereafter we will list our tips and best practices to keep a consistent look to this book. If something is listed below we should stick to using this format or we should adapt the new format to every occurrence. This list will not represent every feature of Jupyter Book. If something isn't listed it can be found in the [documentation](https://jupyterbook.org/intro.html).

#### Embedding images

Images can be embedded with the following code block. All lines starting with a `:` are optional but help with formatting the book.
````
```{image} images/image.png
:alt: Name of image
:width: 800px
:align: center
```
<div style=\"text-align: right\"> Abbildung x: Description of image. </div> <br>
````
This format also accepts internet links to images instead of `path/to/image.png`.

#### Licensing of images

When using licensed images we have to credit this. It is obligatory to mention information based on the [TULLU-Rule](https://open-educational-resources.de/oer-tullu-regel/). 
Here is our scheme for license information and an example from our Book. These code block are placed below the embedded image.
```
<div style="text-align: right"> "Title (if available)", <a href="Link to author (if available)" >Author</a>, <a href="Link to license type" >[License (incl. version)]</a> via <a href="Link to original" >Place of origin</a></div> <br>
```
```
<div style="text-align: right"> "Bremsvorgang", <a href="https://commons.wikimedia.org/wiki/User:Stefan-Xp" >Stefan-Xp</a>, <a href="https://creativecommons.org/licenses/by-sa/3.0/legalcode" >[CC BY-SA 3.0]</a> via <a href="https://commons.wikimedia.org/wiki/File:Bremsvorgang.svg" >Wikimedia Commons</a></div> <br>
```

 #### Requirements and learning goals
 
All new exercises should include learning requirements and learning goals. These can be added using this draft:
 
``````
````{grid} 2
```{grid-item-card}
:class-header: bg-light
Voraussetzungen
^^^
- keine
```
```{grid-item-card}
:class-header: bg-light
Lerninhalte
^^^
- keine
```
````
``````

 #### Special content boxes and admonitions

Jupyter Book has a convenient way to mark special content like tips or warnings.
We are using three different styles of these boxes, one for admonitions, one for tips and one for warnings. They are formatted like this:
````
```{admonition} Hinweis
Dies ist ein Hinweis.
```
````
````
```{admonition} Tipp
:class: tip
Dies ist ein Tipp.
```
````
````
```{admonition} Achtung
:class: warning
Dies ist eine Warnung.
```
````
````
```{admonition} Exkurs
:class: dropdown
Dies ist ein Ausklappmenü.
```
````

</details>
