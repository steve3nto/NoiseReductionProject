function noise_psd = noise_psd(Y_bart)
PH1int = 0.5;
alphax = 0.9;
alpha = 0.6;


SNRpri   = 15; % optimal fixed a priori SNR for SPP estimation

S     = 10.^(SNRpri ./10);
GLRexp     = S ./(1+S );

for I=1:5
noise_psd(:,I) = Y_bart(:,I);
noise_psd(:,I) = max(eps, noise_psd(:,I));
end

for i=6:size(Y_bart,2)
  
     snrPost=  Y_bart(:,i)./(noise_psd(:,i-1));

    PH1=(1+(1+S  ).*exp(-snrPost.*GLRexp)).^-1;  % a posteriori speech presence probability 
     PH1int  = alphax * PH1int + (1-alphax) * PH1 ;
    stuckInd  = PH1int  > 0.99;
     PH1(stuckInd) = min(PH1(stuckInd),0.99);
   E =  PH1 .* noise_psd(:,i-1) + (1-PH1) .* Y_bart(:,i) ;

    noise_psd(:,i) = alpha.*noise_psd(:,i-1)+(1-alpha).* E;
end

end

