%yk2_bart is matrix of yk2_bart, Enk is the matrix of noiseEstimation and phase is the matrix of phase of yk 

function speech = NoiseSubtraction(yk2_bart,Enk,phase)
    s_mag=max(yk2_bart-Enk,0.2);
    sk = sqrt(s_mag).*exp(phase.*sqrt(-1));
    speech=ifft(sk);
    
end