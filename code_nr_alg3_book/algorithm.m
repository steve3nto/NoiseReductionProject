function [shat] = algorithm(noisy,par)
%%%%%%%%%%%%%%%%%%%%%% Author: Timo Gerkmann, Richard Hendriks and Jesper
%%%%%%%%%%%%%%%%%%%%%% Jensen
%%%%%%%%%%%%%%%%%%%%%% University of Oldenburg 
%%%%%%%%%%%%%%%%%%%%%% Delft university of Technology 
%%%%%%%%%%%%%%%%%%%%%% JIKT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    This matlab code is  an implementation
%%%%                    from algorithm number 3 used in the comparison in the book
%%%%                    DFT-Domain Based Single-Microphone Noise Reduction for Speech Enhancement-A Survey of the State of the Art
%%%                     Richard C. Hendriks; Timo Gerkmann; Jesper Jensen;
%%%                     Morgan and Claypool Publishers, 2013.

%%%                     The subcomponents of this algorithm are described
%%%                     in Section 9, Table 9.1.





%% som constants
MIN_GAIN = par.MIN_GAIN;
%%
ALPHA= par.ALPHA; %% this is the smoothing factor used in the decision directed approach
SNR_LOW_LIM = par.SNR_LOW_LIM;
g_mag=   par.g_mag;
frLen  = par.frLen;
fShift   = par.fShift;
nFrames = floor(length(noisy)/fShift)-1; % number of frames


fs=par.fs;
anWin  = par.anWin;
synWin = par.synWin;
fft_size= frLen;

%% initialize
noise_psd = init_noise_tracker_ideal_vad(noisy,frLen,frLen,fShift, anWin); % This function computes the initial noise PSD estimate. It is assumed that the first 5 time-frames are noise-only.
noise_psd = max(eps, noise_psd);

%
PH1mean = 0.5;
alphaPH1mean = 0.9;
alphaPSD = 0.8;


%constants for a posteriori SPP
q          = 0.5; % a priori probability of speech presence:
priorFact  = q./(1-q);
xiOptDb    = 15; % optimal fixed a priori SNR for SPP estimation
xiOpt      = 10.^(xiOptDb./10);
logGLRFact = log(1./(1+xiOpt));
GLRexp     = xiOpt./(1+xiOpt);
clean_est_dft_frame=[];


shat=zeros(size(noisy));

for indFr = 1:nFrames
    indices     = (indFr-1)*fShift+1:(indFr-1)*fShift+frLen;
    noisy_frame = anWin.*noisy(indices);
    noisyDftFrame = fft(noisy_frame,frLen);
    noisyDftFrame = noisyDftFrame(1:frLen/2+1);
    clean_est_dft_frame_p=abs(clean_est_dft_frame).^2;
    noisyPer = noisyDftFrame.*conj(noisyDftFrame);
    snrPost1 =  noisyPer./(noise_psd);% a posteriori SNR based on old noise power estimate
    
    %% noise power estimation
    GLR         = priorFact .* exp(min(logGLRFact + GLRexp.*snrPost1,200));
    PH1         = GLR./(1+GLR); % a posteriori speech presence probability
    
    PH1mean = alphaPH1mean * PH1mean + (1-alphaPH1mean) * PH1;
    stuckInd = PH1mean > 0.99;
    PH1(stuckInd) = min(PH1(stuckInd),0.99);
    estimate =  PH1 .* noise_psd + (1-PH1) .* noisyPer ;
    noise_psd = alphaPSD *noise_psd+(1-alphaPSD)*estimate;
    
    
    
    
    [a_post_snr,a_priori_snr   ]=estimate_snrs( noisyPer,fft_size,   noise_psd,SNR_LOW_LIM,  ALPHA   ,indFr,clean_est_dft_frame_p)   ;
    [gain]= lookup_gain_in_table(g_mag,a_post_snr,a_priori_snr,-40:1:50,-40:1:50,1);
    gain=max(gain,MIN_GAIN);
    clean_est_dft_frame=gain.*noisyDftFrame(1:fft_size/2+1);
    shat(indices)=shat(indices)+  synWin.*real(ifft( [clean_est_dft_frame;flipud(conj(clean_est_dft_frame(2:end-1)))]));
end
