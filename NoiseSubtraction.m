% yk2_bart is matrix of yk2_bart, Enk is the matrix of noiseEstimation
% and phase is the matrix of phase of yk 
% speech is a matrix containing the windows of audio samples
% that must be overlapped and added
function speech = NoiseSubtraction(yk2_bart,Enk,phase)
    % transform into decibels
    bartdb = 10*log10(yk2_bart);
    Edb = 10*log10(Enk);
    s_db=max(bartdb-Edb,0.2);  % to reduce musical noise
    s_mag = 10.^(s_db./10);
    sk = sqrt(s_mag).*exp(phase.*sqrt(-1));
    speech=ifft(sk,320);    
end