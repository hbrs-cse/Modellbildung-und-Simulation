## Contribute or improve the book

* Download and install [jupyter-book](https://github.com/jupyter/jupyter-book).
* Navigate into the `content` subdirectory of the repository and create some markdown files and jupyter notebooks.
* Edit `_data/toc.yml` to include the newly created content files in the table of contents.

Most likely, these are the only places where changes need to be made. For more sophisticated changes, checkout the jupyter-book documentation.

* Call
```bash
make clean
make book
```
from the root directory of the repository. With ```make serve``` the results can be checked locally. Once you are content with the changes, commit all of your changed files. _Don't forget to include the newly generated files from the `_build` directory!_

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
