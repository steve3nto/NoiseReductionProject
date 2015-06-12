The matlab files enclosed in this toolbox can be used to tabulate gain functions 
for clean speech complex-DFT, magnitude and magnitude squared estimators under an assumed Generalized- 
Gamma model for the clean speech magnitude DFT coefficients.
 
For the theory behind these estimators and constraints on the parameters we refer to the articles
 
[1] J.S. Erkelens, R.C. Hendriks, R. Heusdens, and J. Jensen, 
     "Minimum mean-square error estimation of discrete Fourier coefficients with generalized gamma priors", 
    IEEE Trans. on Audio, Speech and Language Proc., vol. 15, no. 6, pp. 1741 - 1752, August 2007.
 

 
[2] J.S. Erkelens, R.C. Hendriks and  R. Heusdens
    "On the Estimation of Complex Speech DFT Coefficients without Assuming Independent Real and Imaginary Parts", 
    IEEE Signal Processing Letters, 2008.
 

and
 
[3] R.C. Hendriks, J.S. Erkelens and  R. Heusdens
    "Comparison of complex-DFT estimators with and without the independence assumption of real and imaginary parts",
    ICASSP, 2008
 
Short description of the 2 main m-files (see the headers of the files for more info):
 
For an assumed Generalized-Gamma prior density of the magnitude DFT coefficients with specific 
gamma and nu parameter the m-file [Gdft,Gmag,Gmag2]=Tabulate_gain_functions(gamma,nu) 
tabulates the gain functions for the complex DFT coefficients, the magnitude DFT coefficients, 
and the magnitude squared DFT coefficients. These three estimators are computed under the same distributional assumption. 
For mathematical expressions of the gain functions for the complex DFT coefficients see [2]. For mathematical expressions 
of the gain functions for the magnitude DFT coefficients see [1].
The range of a priori and a posteriori SNRs is
-40 to 50 dB in 1 dB steps. Each row of the gain matrices is for a different a priori SNR, while a posteriori
SNR varies along columns.
 
Given the tabulated gain function, a vector of gain values for pairs of a priori and a posteriori SNRs can be
selected using the m-file
[gains]=lookup_gain_in_table(G,a_post,a_priori,a_post_range,a_priori_range,step);
where a_post and a_priori are vectors with the a posteriori and a priori SNRs respectively.
The vectors a_post and a_priori should have equal lengths. The parameters a_post_range and a_priori_range indicate
the ranges in dBs used in the gain table G, and step is the stepsize (assumed equal for both SNR parameters).
 
Implementations of the special functions are based on 
S. Zhang & J. Jin "Computation of Special Functions" (Wiley, 1996) with implementations available 
online: http://iris-lee3.ece.uiuc.edu/~jjin/routines/routines.html
 
The implementations of these special functions in the toolbox have been adapted with respect to the original implementations 
such that they can handle vector arguments as well.
 
Copyright 2007: Delft University of Technology, Information and
Communication Theory Group. The software is free for non-commercial use.
This program comes WITHOUT ANY WARRANTY.
 
December, 2007
J. S. Erkelens
R. C. Hendriks
R. Heusdens
 
 