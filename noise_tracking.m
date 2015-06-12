%PH0 is row vector in which each element correspond to probability of absence
%of speech for every frame l
% yk_2 is the squared magnitude of the noisy signal DFT
% alpha is the update parameter for the output
% SigmaN2 is the estimated noise PSD for every time window l
function SigmaN2 = noise_tracking(yk_2, PH0, alpha)
    % Keep first time window as noise
     SigmaN2(:,1) = yk_2(:,1);

%     SNR(:,2) = yk_2(:,2)./SigmaN2(:,1) - 1;
%     pyH0(:,2) = exp(-abs(yk_2(:,2))./SigmaN2(:,1))./(SigmaN2(:,1).*pi);
%     pyH1(:,2) = exp(-abs(yk_2(:,2))./(SigmaN2(:,1).*(1+SNR(:,2))))./(SigmaN2(:,1).*pi.*(1+SNR(:,2)));
%     % Use Bayes rule to compute PH | Y
%     PH0y(:,2) = PH0.*pyH0(:,2) ./ (PH0.*pyH0(:,2) + (1-PH0).*pyH1(:,2));
%     PH1y(:,2) = ones(size(PH0y,1),1) - PH0y(:,2);

    Sk_2 = zeros(size(yk_2));
    


    for i=2:size(yk_2,2)
        % spectral subtraction for
        Sk_2(:,i-1) = yk_2(:,i-1) - SigmaN2(:,i-1);

        
        SNR_ML(:,i) = max(yk_2(:,i)./SigmaN2(:,i-1) - 1 ,0); %ML estimate
        a = .96;
        SNR_DD(:,i) = a*(Sk_2(:,i-1)./SigmaN2(:,i-1)) + (1-a)*SNR_ML(:,i);
        
        vector_ones = ones(size(SNR_DD,1),1);
        vector_twos = 2*vector_ones;
        Bias_Compensation(:,i) = ((1 + SNR_DD(:,i)).*gammainc(vector_twos,...
        vector_ones./vector_ones+SNR_DD(:,i)) + ...
        exp(-vector_ones./vector_ones+SNR_DD(:,i)));
      
        pyH0(:,i) = exp(-abs(yk_2(:,i))./SigmaN2(:,i-1))./(SigmaN2(:,i-1).*pi);
        pyH1(:,i) = exp(-abs(yk_2(:,i))./(SigmaN2(:,i-1).*(1+SNR_ML(:,i))))./(SigmaN2(:,i-1).*pi.*(1+SNR_ML(:,i)));
        % Use Bayes rule to compute PH | Y
        PH0y(:,i) = PH0.*pyH0(:,i) ./ (PH0.*pyH0(:,i) + (1-PH0).*pyH1(:,i));
        PH1y(:,i) = ones(size(PH0y,1),1) - PH0y(:,i);
        % Compute E[N^2|y]
        EN2Y(:,i) = PH0y(:,i).*yk_2(:,i) + PH1y(:,i).*SigmaN2(:,i-1);
        %Compensate the BIAS
        EN2Y(:,i) = EN2Y(:,i).*Bias_Compensation(:,i);
        % update new sigmaN2
        SigmaN2(:,i) = alpha.*SigmaN2(:,i-1) + (1-alpha).*EN2Y(:,i);
    end
    
    
    
%     PH0=repmat(PH0,size(yk_2,1),1);
%     PH1=ones(size(PH0))-PH0;
%     PH1y=(PH1.*pyH1)./(PH1.*pyH1+PH0.*pyH0);
%     PH0y=ones(size(PH1y))-PH1y;
%     sigma2_pad=padarray(sigma2,[0 1],0);
%     sigma2_pre=sigma2_pad(:,1:size(sigma2_pad,2)-1);
%     sigma2_pre_mat=repmat(sigma2_pre,size(yk_2,1),1);
%     Enk=PH0y.*yk_2+PH1y.*sigma2_pre_mat;
    
end