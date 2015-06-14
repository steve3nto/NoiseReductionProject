function SigmaN2 = noise_estimation_new(yk_2, PH0, alpha, a)
% noise_estimation_new estimates the PSD of the noise using
% the method presented in
% Gerkmann, T. & Hendriks, R. C.
% Unbiased MMSE-Based Noise Power Estimation With Low Complexity and Low Tracking Delay
% IEEE Trans Audio, Speech, Language Processing, 2012, 20, 1383-1393

% INPUTS
% yk_2 is the windowed PSD of the noisy speech
% PH0 is the prioir probability of speech absence
% alpha is the smoothing parameter for the update of the noise PSD
% a is the probability smoothing parameter

% OUTPUT
% SigmaN2 is the estimated windowed noise PSD 

% Keep first 5 time windows of y as noise
SigmaN2(:,1:5) = yk_2(:,1:5);

one = ones(size(yk_2,1),1);
SNR=10.^1.5;   % Optimal a priori SNR = 15dB
S=SNR/(1+SNR); 
S=S*one;


for i=6:size(yk_2,2)    % loop through the time windows
    
    % A posteriori speech presence probability
    PH1y(:,i)=(one+(PH0/(1-PH0)).*(one+SNR.*one).*exp(-(yk_2(:,i)./SigmaN2(:,i-1)).*S)).^-1;
    % Smooth the SPP over time
    PH1y(:,i)= a.*PH1y(:,i-1) + (1-a).*PH1y(:,i);

    
    % Avoid stagnation due to underestimates of noise power
    for j=1:size(yk_2,1)
        if PH1y(j,i)>0.99
            PH1y(j,i)=0.99;
        end
    end
    
    % Compute a posteriori speech absence probability
    PH0y(:,i) = one - PH1y(:,i);
    % Compute the current estimate of E[N^2|y]
    EN2Y(:,i) = PH0y(:,i).*yk_2(:,i) + PH1y(:,i).*SigmaN2(:,i-1);
    % Smooth the noise PSD over time using alpha
    SigmaN2(:,i) = alpha.*SigmaN2(:,i-1) + (1-alpha).*EN2Y(:,i);
end
       
end