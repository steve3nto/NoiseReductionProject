% NOISE REDUCTION FOR SPEECH ENHANCEMENT SYSTEM

%-----------------PARAMETERS GO HERE-------------------------%
NFFT = 2^14;            % number of points for the FFT of the whole signal
split_length = 20;      % window length in ms
overlap_length = 10;     % overlap between windows in ms
L = 10;                 % number of Bartlett averaging windows;
PH0 = 0.5;              % prior probability of having no speech
alpha = 0.8;            % update parameter for PSD estimation
%------------------------------------------------------------%

% Load audio. Wav sampled at 16 KHz
[clean, Fs] = wavread('clean');

noise = wavread('noise1');
white_noise = randn(size(noise));
noise = 0.05*white_noise;  % This give an SNR of approximately 0dB
intersection = wavread('intersection_soundjay');
Ts = 1/Fs;
% Create noisy speech Y
y = clean + noise;
% Listen to noisy speech
player = audioplayer(y,Fs);
player.play;

% Visualize time domain signals
figure('name','time-domain signals');
subplot(1,2,1);
plot(clean);
title('speech(t)');
subplot(1,2,2);
plot(noise);
title('noise(t)');
figure('name','noisy signal');
plot(y);

% Compute DFTs
Y = fft(y,NFFT);
N = fft(noise,NFFT);
S = fft(clean,NFFT);
f = Fs/2*linspace(0,1,NFFT/2+1);   %single-sided frequency axis in Hz
% Visualize magnitude of clean speech and noise
figure;
plot(f,20.*log10(abs(S(1:NFFT/2+1))))
hold on;
plot(f,20.*log10(abs(N(1:NFFT/2+1))),'r')
title('Single-Sided Amplitude Spectrum of s(t) and n(t) in red')
xlabel('Frequency (Hz)')
ylabel('|S(f)|')
% Visualize phase of clean speech and noise
figure;
plot(f,unwrap(angle(S(1:NFFT/2+1))));
hold on;
plot(f,unwrap(angle(N(1:NFFT/2+1))),'r');
title('Single-Sided Phase Spectrum of s(t) and n(t) in red')
xlabel('Frequency (Hz)')
ylabel('Arg(S(f))')
% Visualize magnitude of Y
figure;
plot(f,20.*log10(abs(Y(1:NFFT/2+1)))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
% Visualize phase of Y
figure;
plot(f,unwrap(angle(Y(1:NFFT/2+1))));
title('Single-Sided Phase Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('Arg(Y(f))')
% Store noisy phase for later
phase = angle(Y);
noisy_magnitude = abs(Y);

% Segment the signals using hanning windows and apply fft
windows = split_hanning(y,split_length,overlap_length,Fs);
ffts = fft(windows);
magnitudes = abs(ffts);
% store noisy phases for later
phases = angle(ffts);
Yk2s = magnitudes.^2;

% Y_bart_single = mean(Yk2s(:,1:L),2);

% Compute all the Bartlett estimates
Y_bart = Bartlett( y, Fs, L, split_length, overlap_length );
% Estimate noise PSD
SigmaN2 = noise_estimation(Y_bart, PH0, alpha);

% Plot noise and signal PSD
f = Fs/2*linspace(0,1,size(Y_bart,1)/2+1);
figure;
plot(f,Y_bart(1:size(Y_bart,1)/2+1,1000),'g',f,SigmaN2(1:size(SigmaN2,1)/2+1,1000),'r'); 
title('Single-Sided PSD of Y and N')
xlabel('Frequency (Hz)')
ylabel('PSD of Y and N')

% Apply noise subtraction
speech = NoiseSubtraction(Y_bart,SigmaN2,phases);
% Overlap and Add to recreate speech signal
filtered_speech = OverlapAdd(speech, split_length, overlap_length, Fs, size(y,1));
% Listen to filtered speech
player = audioplayer(filtered_speech,Fs);
player.play;

%PLOTS AND EVALUATION
plot(filtered_speech);
n = y-filtered_speech;
plot(n);
SNR = sum(clean.^2)/sum(n.^2);
SNR = 10*log10(SNR);
%% Test code and debug

% test overlap and add
windows = split_hanning(y, split_length, overlap_length, Fs);
filtered_speech = OverlapAdd(windows, split_length, overlap_length, Fs, size(y,1));
figure;
plot(y);
hold on;
plot(y - filtered_speech, 'r');

% Test spectral subtraction with real PSD noise
P_clean = sum(clean.^2);
P_noise = sum(noise.^2);
SNR_original = 10*log10(P_clean / P_noise);
PSD_noise = Bartlett( noise, Fs, L, split_length, overlap_length);

% Plot noise and signal PSD
figure;
plot(f,Y_bart(1:size(Y_bart,1)/2+1,1000),'b');
hold on;
plot(f,PSD_noise(1:size(PSD_noise,1)/2+1,1000),'r'); 
title('Single-Sided PSD of Y and N')
xlabel('Frequency (Hz)')
ylabel('PSD of Y and N')

speech = NoiseSubtraction(Y_bart,PSD_noise,phases);
% Overlap and Add to recreate speech signal
filtered_speech_real = OverlapAdd(speech, split_length, overlap_length, Fs, size(y,1));
% Listen to filtered speech
player = audioplayer(filtered_speech_real,Fs);
player.play;