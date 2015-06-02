% yk2_bart is matrix of yk2_bart, Enk is the matrix of noiseEstimation
% and phase is the matrix of phase of yk 
% speech is a matrix containing the windows of audio samples
% that must be overlapped and added
function speech = NoiseSubtraction(yk2_bart,Enk,phase)
    % transform into decibels
    s_mag = max(yk2_bart - Enk, 0.2);  % to reduce musical noise
    sk = sqrt(s_mag).*exp(phase.*sqrt(-1));
%     speech=ifft(sk,320); 
     speech=ifft(sk); 
end