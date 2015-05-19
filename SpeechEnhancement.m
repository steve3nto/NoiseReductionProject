clear;
clc;

% Load audio. Wav sampled at 16 KHz
[clean, Fs] = wavread('clean');
noise = wavread('noise1');
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

% Compute DFT
NFFT = 2^10;
Y = fft(y,NFFT);
f = Fs/2*linspace(0,1,NFFT/2+1);   %single-sided frequency axis in Hz
% Visualize magnitude
figure;
plot(f,20.*log10(abs(Y(1:NFFT/2+1)))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
% Visualize phase
figure;
plot(f,unwrap(angle(Y(1:NFFT/2+1))));
title('Single-Sided Phase Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('Arg(Y(f))')
% Store noisy phase for later
phase = angle(Y);
noisy_magnitude = abs(Y);
% Compute Bartlett estimate
windows = split_vector(y,20,10,Fs);
ffts = fft(windows,NFFT);
magnitudes = abs(ffts);
Yk2s = magnitudes.^2;
L = 10;   % number of Bartlett averaging windows;
Y_bart_single = mean(Yk2s(:,1:L),2);
% Compute all the Bartlett estimates
Y_bart = Bartlett( y, Fs, 10 );
