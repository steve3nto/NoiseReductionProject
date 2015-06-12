README
To Install the model

1-install scipy and numpy http://www.scipy.org/install.html

2-type "make" from terminal in the current folder

3-run the matlab script demo_verhulst_otoacousticemssion to check that python is correctly installed

 
#Info:
This is an implementation of the cochlear model described in verhulst2012, using a  variable step size integration method.

It support multiprocessing, so it is possible to run several simulation at once, regarding the number of processors available. For example is it possible to process a stereo signal at once, saving roughly half time.
