% NOISE REDUCTION FOR SPEECH ENHANCEMENT SYSTEM

%-----------------PARAMETERS GO HERE-------------------------%
NFFT = 2^14;            % number of points for the FFT of the whole signal
split_length = 32;      % window length in ms
overlap_length = 16;     % overlap between windows in ms
L = 10;                 % number of Bartlett averaging windows;
PH0 = 0.5;              % prior probability of having no speech
alpha = 0.8;            % update parameter for PSD estimation
%------------------------------------------------------------%

% Load audio. Wav sampled at 16 KHz
[clean, Fs] = wavread('clean');

noise = wavread('noise1');  % modulated speech-like noise (SNR = -5.00dB)
white_noise = randn(size(noise));

% noise = 0.1*white_noise;  % white noise (SNR = -5.38dB)

% noise = wavread('intersection_soundjay');  % car noise 
% noise = 2*noise(1:size(clean,1));          % SNR = -5.66dB

Ts = 1/Fs;
% Create noisy speech Y
y = clean + noise;
% Listen to noisy speech
player = audioplayer(y,Fs);
player.play;

% Compute SNR
P_clean = sum(clean.^2);
P_noise = sum(noise.^2);
SNR_original = 10*log10(P_clean / P_noise);
% Bartlett estimate of the real noise PSD (used later for test and plots)
PSD_noise = Bartlett( noise, Fs, L, split_length, overlap_length);
PSD_noisedb = 10*log10(PSD_noise);

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

% % Compute DFTs
% Y = fft(y,NFFT);
% N = fft(noise,NFFT);
% S = fft(clean,NFFT);
% f = Fs/2*linspace(0,1,NFFT/2+1);   %single-sided frequency axis in Hz
% % Visualize magnitude of clean speech and noise
% figure;
% plot(f,20.*log10(abs(S(1:NFFT/2+1))))
% hold on;
% plot(f,20.*log10(abs(N(1:NFFT/2+1))),'r')
% title('Single-Sided Amplitude Spectrum of s(t) and n(t) in red')
% xlabel('Frequency (Hz)')
% ylabel('|S(f)|')
% % Visualize phase of clean speech and noise
% figure;
% plot(f,unwrap(angle(S(1:NFFT/2+1))));
% hold on;
% plot(f,unwrap(angle(N(1:NFFT/2+1))),'r');
% title('Single-Sided Phase Spectrum of s(t) and n(t) in red')
% xlabel('Frequency (Hz)')
% ylabel('Arg(S(f))')
% % Visualize magnitude of Y
% figure;
% plot(f,20.*log10(abs(Y(1:NFFT/2+1)))) 
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% % Visualize phase of Y
% figure;
% plot(f,unwrap(angle(Y(1:NFFT/2+1))));
% title('Single-Sided Phase Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('Arg(Y(f))')
% % Store noisy phase for later
% phase = angle(Y);
% noisy_magnitude = abs(Y);

% Segment the signals using hanning windows and apply fft
windows = split_hanning(y,split_length,overlap_length,Fs);
ffts = fft(windows);
magnitudes = abs(ffts);
% store noisy phases for later
phases = angle(ffts);
Yk2s = magnitudes.^2;

% Compute all the Bartlett estimates
Y_bart = Bartlett( y, Fs, L, split_length, overlap_length );

% try matlab implementation for power spectrum
% for t=1:size(windows,2)
%     Pyy(:,t) = pwelch(windows(:,t),[],[],512,'twosided');
% end
% Y_bart = Pyy;

% % Estimate noise PSD
% SigmaN2 = noise_tracking(Y_bart, PH0, alpha);
% % Estimate noise PSD using MMSE tracking with low complexity
% SigmaN2 = Noise_estimation(Y_bart, 0.98, 0.8);
% % Estimate noise PSD using probability SPP method
% SigmaN2 = noise_psd(Y_bart);

% Estimate noise PSD
% New method based on the last paper by Hendricks and Gerkmann
SigmaN2 = noise_estimation_new(Yk2s,0.5,0.8,0.05);

%Test voicebox implementation
% [Noise_PSD,state] = estnoiseg(Yk2s',0.02);
% SigmaN2 = Noise_PSD';

% OPTIONAL! Smooth the estimate over time in the Bartlett way
% for i=L:size(SigmaN2,2)
%      SigmaN2(:,i) = mean(SigmaN2(:,i-L+1:i),2);
% end

% Plot noise and signal PSD of time window num_window
num_window = 2000;
f = Fs/2*linspace(0,1,size(Yk2s,1)/2+1);
figure;
Yk2sdb = 10*log10(Yk2s);
SigmaN2db = 10*log10(SigmaN2);
plot(f,Yk2sdb(1:size(Yk2s,1)/2+1,num_window),'g',...
     f,SigmaN2db(1:size(SigmaN2,1)/2+1,num_window),'r');
% Plot Y_PSD vs PSD_noise computed from the real noise
hold on
plot(f,PSD_noisedb(1:size(PSD_noise,1)/2+1,num_window),'b');
title('Single-Sided PSD of Y and N')
xlabel('Frequency (Hz)')
ylabel('PSD of Y and N')

% Apply noise subtraction
speech_sub = NoiseSubtraction(Y_bart,SigmaN2,phases);
% Apply Wiener Filter
speech_wiener = Wiener_filter(Y_bart,magnitudes,SigmaN2,phases);
% Overlap and Add to recreate speech signal
filtered_speech_sub = OverlapAdd(speech_sub, split_length, overlap_length, Fs, size(y,1));
filtered_speech_wiener = OverlapAdd(speech_wiener, split_length, overlap_length, Fs, size(y,1));
% Listen to spectral subtraction filtered speech
player = audioplayer(filtered_speech_sub,Fs);
player.play;
% Listen to wiener filtered speech
player = audioplayer(filtered_speech_wiener,Fs);
player.play;

%PLOTS AND EVALUATION
figure
plot(filtered_speech_sub);
figure
plot(filtered_speech_wiener, 'r');
n_sub = filtered_speech_sub - clean;
n_wiener = filtered_speech_wiener - clean;
figure
plot(n_sub);
figure
plot(n_wiener,'r');

% Compute Segmented SNR
clean_seg = split_vector(clean,20,0,Fs);
y_seg = split_vector(y,20,0,Fs);
noise_seg = split_vector(noise,20,0,Fs);
sub_seg = split_vector(filtered_speech_sub,20,0,Fs);
wiener_seg = split_vector(filtered_speech_wiener,20,0,Fs);
n_sub_seg = split_vector(n_sub,20,0,Fs);
n_wiener_seg = split_vector(n_wiener,20,0,Fs);
SNR_y = 10*log10( sum(y_seg.^2) ./ sum(noise_seg.^2)  );
SNR_y(find(isnan(SNR_y))) = []; % remove NaN values
SegSNR_y = mean(SNR_y);
SNR_sub = 10*log10( sum(sub_seg.^2) ./ sum(n_sub_seg.^2)  );
SNR_sub(find(isnan(SNR_sub))) = []; % remove NaN values
SegSNR_sub = mean(SNR_sub);
SNR_wiener = 10*log10( sum(wiener_seg.^2) ./ sum(n_wiener_seg.^2)  );
SNR_wiener(find(isnan(SNR_wiener))) = []; % remove NaN values
SegSNR_wiener = mean(SNR_wiener);

% Compute STOI measure
stoi_y = taal2011(clean,y,Fs);
stoi_sub = taal2011(clean,filtered_speech_sub,Fs);
stoi_wiener = taal2011(clean,filtered_speech_wiener,Fs);


%% ---------Test code and debug - OPTIONAL! ---------------------------%

% test overlap and add
windows = split_hanning(y, split_length, overlap_length, Fs);
filtered_speech = OverlapAdd(windows, split_length, overlap_length, Fs, size(y,1));
figure;
plot(y);
hold on;
plot(y - filtered_speech, 'r');

% Test spectral subtraction and Wiener filter with real PSD noise
speech_sub_real = NoiseSubtraction(Y_bart,PSD_noise,phases);
speech_wiener_real = Wiener_filter(Y_bart,magnitudes,PSD_noise,phases);
% Overlap and Add to recreate speech signal
filtered_speech_sub_real = OverlapAdd(speech_sub_real, split_length, overlap_length, Fs, size(y,1));
filtered_speech_wiener_real = OverlapAdd(speech_wiener_real, split_length, overlap_length, Fs, size(y,1));
% Listen to subtraction filtered speech
player = audioplayer(filtered_speech_sub_real,Fs);
player.play;
% Listen to wiener filtered speech
player = audioplayer(filtered_speech_wiener_real,Fs);
player.play;

%PLOTS AND EVALUATION
figure
plot(filtered_speech_sub_real);
figure
plot(filtered_speech_wiener_real, 'r');
n_sub_real = filtered_speech_sub_real - clean;
n_wiener_real = filtered_speech_wiener_real - clean;
figure
plot(n_sub_real);
figure
plot(n_wiener_real,'r');

% compute stoi
stoi_sub_real = taal2011(clean,filtered_speech_sub_real,Fs);
stoi_wiener_real = taal2011(clean,filtered_speech_wiener_real,Fs);

% Compute Segmented SNR
clean_seg = split_vector(clean,20,0,Fs);
sub_seg = split_vector(filtered_speech_sub_real,20,0,Fs);
wiener_seg = split_vector(filtered_speech_wiener_real,20,0,Fs);
n_sub_seg = split_vector(n_sub_real,20,0,Fs);
n_wiener_seg = split_vector(n_wiener_real,20,0,Fs);
SNR_sub_real = 10*log10( sum(sub_seg.^2) ./ sum(n_sub_seg.^2)  );
SNR_sub_real(find(isnan(SNR_sub_real))) = []; % remove NaN values
SegSNR_sub_real = mean(SNR_sub_real);
SNR_wiener_real = 10*log10( sum(wiener_seg.^2) ./ sum(n_wiener_seg.^2)  );
SNR_wiener_real(find(isnan(SNR_wiener_real))) = []; % remove NaN values
SegSNR_wiener_real = mean(SNR_wiener_real);


