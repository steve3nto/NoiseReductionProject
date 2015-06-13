function SigmaN2 = Noise_estimation(Yk2, alpha, beta)
% Paper_noise_tracking estimates the noise PSD
% using the method outlined in the paper
% "MMSE based noise PSD tracking with low complexity"
% By Richard Hendricks et al

% INPUTS
% Y_bart is windowed PSD of the noisy speech y
% alpha is the smoothing parameter for the DD estimation
% of the a priori SNR, usually in the range [0.95 , 0.99]
% beta is the smoothing parameter for the noise,
% usually 0.8

%OUTPUT
% SigmaN2 is the windowed estimated noise PSD

% Keep the first five frames as pure noise PSD
SigmaN2(:,1:5) = Yk2(:,1:5);


for i=6:size(Yk2,2)
    % Compute ML estimate of a priori SNR
    Xi(:,i) = max( (Yk2(:,i)./SigmaN2(:,i-1)) - 1 , 0 );
    % Compute a posteriori SNR
    Zeta(:,i) = Yk2(:,i) ./ SigmaN2(:,i-1);
    % Compute noise PSD first estimate
    one = ones(size(Yk2,1),1);
    EN2(:,i) = ( (one./(one+Xi(:,i)).^2) + Xi(:,i)./((one+Xi(:,i)).*Zeta(:,i)) ).*Yk2(:,i);
    % Compute DD estimate of a priori SNR
    S(:,i) = max( Yk2(:,i) - SigmaN2(:,i-1), 0 );
    XiDD(:,i) = alpha*(S(:,i)./EN2(:,i)) + (1-alpha)*max( (Yk2(:,i)./SigmaN2(:,i-1)) - 1 , 0 );
    % Compute Bias correction using the DD estimated a priori SNR
    two = 2*one;
    gamma(:,i) = gammainc( two, max( one./(one+XiDD(:,i)), 0 ) );
    B(:,i) = ( (1+XiDD(:,i)).*gamma(:,i) + exp(-one./(one+XiDD(:,i))) );
    % Correct the bias for the noise PSD estimate
    SigmaN2(:,i) = EN2(:,i).*B(:,i);
    % Smooth the estimate over time using the beta parameter
    SigmaN2(:,i) = beta*SigmaN2(:,i-1) + (i-beta)*SigmaN2(:,i);
end

end

