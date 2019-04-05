## Contribution Workflow

### Initial Setup

Clone this repository to your local machine.

 ```bash
 git clone https://github.com/joergbrech/Modellbildung-und-Simulation
 cd Modellbildung-und-Simulation
 ```
 
### Adding new Content
 
 * Switch to the master branch and fetch the latest changes from this repository
 ```bash
 git checkout master
 git pull
 ```
 * Create a new branch and switch to it
 ```bash
 git checkout -b my-awesome-new-page
 ```
 * Add content, see below. Remember to build the book after adding/editing markdown files and jupyter notebooks in the `content` subdirectory
 ```bash
 make book
 ```
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

## How to create content

* Download and install [jupyter-book](https://github.com/jupyter/jupyter-book), if you haven't done so already.
```bash
git clone https://github.com/jupyter/jupyter-book
cd jupyter-book
python setup.py install
```
* Navigate into the `content` subdirectory of the repository and create some markdown files and jupyter notebooks.
* Edit `_data/toc.yml` to include the newly created content files in the table of contents.

Most likely, these are the only places where changes need to be made. For more sophisticated changes, checkout the jupyter-book documentation.

* Call
```bash
make book
```
from the root directory of the repository. With ```make serve``` the results can be checked locally (*setting this up can be a bit tedious*). Once you are content with the changes, commit all of your changed files. _Don't forget to include the newly generated files from the `_build` directory!_

## Jupyter Book

The book is based on Jupyter Book. Here are some links with documentation by the creators:

* **[A demo of the hosted textbook](http://jupyter.org/jupyter-book/ )**
* **[A short guide to deploying your own textbook](https://jupyter.org/jupyter-book/guide/01_overview)**
* **[The markdown version of the guide in this repo](content/guide/)**

Jupyter Books was originally created by [Sam Lau][sam] and [Chris Holdgraf][chris]
with support of the **UC Berkeley Data Science Education Program and the Berkeley
Institute for Data Science**.

[sam]: http://www.samlau.me/
[chris]: https://predictablynoisy.com
