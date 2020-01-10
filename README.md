This repository contains a Keras/Tensorflow environment, accessible through the built-in Jupyter Notebook. The repository also includes a machine vision example from the horses vs humans dataset

https://github.com/kaibrooks

https://medium.com/@kaibrooks/creating-a-neural-network-from-the-ground-up-for-classifying-your-own-images-in-keras-tensorflow-91e57d480c24?sk=44768b90870500a1cb8e654cbcbd1b9d

---

### 1) Get image from Docker
<I>(Do this once)</I>

<pre><code>docker pull kaibrooks/demo-horsemans</code></pre>

### 2) Run the image
<I>(Do this if you restart/close the terminal and want to start the notebook up again)</I>

Run this if you only want to access the demo files:
<pre><code>docker run -it -p 8888:8888 kaibrooks/demo-horsemans:latest</code></pre>

or run this instead if you want Docker to access your own folder as well (like for your own projects):
<pre><code>docker run -it -v ~/MYSWEETFOLDER/:/tf/notebooks -p 8888:8888 kaibrooks/demo-horsemans:latest</code></pre>

Replace ~/MYSWEETFOLDER/ with whatever folder you want Docker to have access to. Don't touch the :/tf/notebooks part!

### 3) Open Jupyter Notebook
<I>(Do this after you run the image, to open Jupyter Notebook and start working)</I>

The command line outputs a URL like below. Go there.

http://127.0.0.1:8888/?token=WHATEVERISHERE

(Done)
