clear all
%%%%%%%%%%%%%%%%%%%%%% Author: Timo Gerkmann, Richard Hendriks and Jesper
%%%%%%%%%%%%%%%%%%%%%% Jensen
%%%%%%%%%%%%%%%%%%%%%% University of Oldenburg 
%%%%%%%%%%%%%%%%%%%%%% Delft university of Technology 
%%%%%%%%%%%%%%%%%%%%%% JIKT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    This matlab code is used to run an implementation
%%%%                    from algorithm number 3 used in the comparison in the book
%%%%                    DFT-Domain Based Single-Microphone Noise Reduction for Speech Enhancement-A Survey of the State of the Art
%%%                     Richard C. Hendriks; Timo Gerkmann; Jesper Jensen;
%%%                     Morgan and Claypool Publishers, 2013.

%%%                     The subcomponents of this algorithm are described
%%%                     in Section 9, Table 9.1.






addpath(fullfile(cd,filesep,'TabGenGam',filesep));


%% some constants

par.fs=16000;
par.MIN_GAIN = 10^(-20/20);
par.ALPHA=0.98; %% this is the smoothing factor used in the decision directed approach
par.frLen   = 32e-3*par.fs;  % frame size
par.fShift  = par.frLen/2;        % fShift size
par.anWin  = sqrt(hanning(par.frLen,'periodic')); %analysis and synthesis anWin
par.synWin = sqrt(hanning(par.frLen,'periodic')); %analysis and synthesis anWin
par.SNR_LOW_LIM = eps;
[s,fs]=wavread('s');
if fs==par.fs
else
    error
end
[n,fs]=wavread('n');
if fs==par.fs
else
    error
end
y=s+n;
%%%%%%%%%%
gamma=1;
nu=0.6;
[g_dft,g_mag,g_mag2]=Tabulate_gain_functions(gamma,nu); %% tabulate the gain function used later on
par.g_mag=g_mag;
[shat] =algorithm(y,par);
