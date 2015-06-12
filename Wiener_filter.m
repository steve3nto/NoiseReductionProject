function speech = Wiener_filter( Y_bart, Y_mag, SigmaN2, phase )
% Wiener_filter Sapplies a Wiener smoother filter
% to reduce noise on the speech signal
% Y_bart is the windowed PSD of the noisy signal y
% Y_mag is the fft magnitude of the noisy windowed speech
% SigmaN2 is the estimated windowed PSD of the noise
% phase is the noisy phase to append to the signal
% s is the windowed filtered speech


H = 1 - SigmaN2 ./ Y_bart;
S_mag = H.*Y_mag;   %magnitude of speech fft
Sk = S_mag.*exp(phase.*sqrt(-1));
speech = ifft(Sk);

end

