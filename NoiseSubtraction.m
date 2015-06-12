% yk2_bart is matrix of yk2_bart, Enk is the matrix of noiseEstimation
% and phase is the matrix of phase of yk 
% speech is a matrix containing the windows of audio samples
% that must be overlapped and added
function speech = NoiseSubtraction(yk2_bart,Enk,phase)
    s_mag = (yk2_bart.^0.5).*(max(1 - Enk./yk2_bart, 0.02)).^0.5;  % to reduce musical noise
    sk = s_mag.*exp(phase.*sqrt(-1));
    speech=ifft(sk);    
end