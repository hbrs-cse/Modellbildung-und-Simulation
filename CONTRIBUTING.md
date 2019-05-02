## Initial Setup

### Requirements

I have tested this on Linux, though it should work on Windows and Mac as well. For Windows 10, working with the *Windows Linux Subsystem* works really well, so I suggest you install e.g. **Ubuntu 18.04** on your Windows machine.

I suggest installing miniconda3. It is a very good package manager that comes with Python and allows the creation of environments. This is not really necessary, but some of the commands below assume you have `conda` installed on your system.

#### Install prerequisites

This website is based on Jupyter-book, which lets you create a static website out of Markdown files and Jupyter notebooks. The Jupyter notebooks here use the Octave kernel. The webpage creation is done with ruby. So first, we need to install these prerequisites with `apt-get` and `conda`:

Install Octave, Jupyter and the Octave-kernel for jupyter:

```bash
sudo apt-get install octave
conda install jupyter jupyterlab
conda install octave_kernel -c conda-forge
```

Install ruby and its requirements:

```bash
sudo apt-get install gcc g++ zlib1g-dev ruby-dev
conda install jupyter
conda install octave_kernel -c conda-forge
```

Finally, you need Ruby's package manager `bundler`. To install it run

```bash
sudo gem install bundler
```

Note, that Ruby is only needed to preview the webpage locally, since the webpage is built with every commit to this repository using github-pages.

#### Install Jupyter-Book

To install jupyter-book, clone the Github repository to your local machine and run the `setup.py` script by entering the commands below. This will create a new subdirectory called `jupyter-book` in your current working directory.

```bash
git clone htttps://github.com/jupyter/jupyter-book
cd jupyter-book
python setup.py install
cd ..
```

### Clone this repository to your local machine

 ```bash
 git clone https://github.com/joergbrech/Modellbildung-und-Simulation
 cd Modellbildung-und-Simulation
 ```
 
#### Install some Ruby requirements needed to preview the website locally

```bash
bundle install
```

bundler might ask you for your sudo password here.

## Contribution Workflow

In this section, it is assumed that you are in the root directory of your clone of this repository, i.e. in `Modellbildung-und-Simulation`.

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
 * Navigate into the `content` subdirectory of the repository and create some markdown files and jupyter notebooks.
 ```bash
 cd content
 jupyterlab .
 ```
 * Edit `_data/toc.yml` to include the newly created content files in the table of contents. Most likely, these are the only places where changes need to be made. For more sophisticated changes, checkout the jupyter-book documentation.
 * Back in the root directory, run
 ```bash
 make book
 ```
 * With
 ```bash
 make serve
 ```
 the results can be checked locally. Simply copy the url from the command line output to your favorite browser.
 * Stage and commit your changes:
 ```bash
 git add .
 git commit -m "added another really awesome page"
 ```
 _Don't forget to include the newly generated files from the `_build` directory!_
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
