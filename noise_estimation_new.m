function SigmaN2 = noise_estimation_new(yk_2, PH0, alpha)
    


% Keep first 5 time windows as noise
     SigmaN2(:,1:5) = yk_2(:,1:5);

      one=ones(size(yk_2,1),1);
      SNR=10.^1.5;
      S=SNR/(1+SNR);
      S=S*one;

    for i=6:size(yk_2,2)
        % SNR(:,i) = yk_2(:,i)./SigmaN2(:,i-1) - 1;

       % pyH0(:,i) = exp(-abs(yk_2(:,i))./SigmaN2(:,i-1))./(SigmaN2(:,i-1).*pi);
       % pyH1(:,i) = exp(-abs(yk_2(:,i))./(SigmaN2(:,i-1).*(1+SNR(:,i))))./(SigmaN2(:,i-1).*pi.*(1+SNR(:,i)));
        % Use Bayes rule to compute PH | Y
      %  PH0y(:,i) = PH0.*pyH0(:,i) ./ (PH0.*pyH0(:,i) + (1-PH0).*pyH1(:,i));
      %  PH1y(:,i) = ones(size(PH0y,1),1) - PH0y(:,i);
      
        PH1y(:,i)=(one+(one+SNR.*one).*exp(-(yk_2(:,i)./SigmaN2(:,i-1)).*S)).^-1;
        PH0y(:,i)=one-PH1y(:,i);
        % Compute E[N^2|y]
        EN2Y(:,i) = PH0y(:,i).*yk_2(:,i) + PH1y(:,i).*SigmaN2(:,i-1);
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