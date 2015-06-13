function [G1,G2]=gam2gains(nu,SNRpost,Rprior);
% Gains can be expressed in terms of Besselfunctions for nu=1
if nu==1
    vk=SNRpost.*Rprior./(1+Rprior);
    G1=gamma(1.5)*sqrt(vk).*[(1+vk).*besseli(0,vk/2,1)+vk.*besseli(1,vk/2,1)]./SNRpost;
    G2=Rprior./(1+Rprior)./SNRpost.*(1+vk);
else
    Q=Rprior./(nu+Rprior);
    % ConflHyperGeomFun: computes confluent hypergeometric function
    Teller=ConflHyperGeomFun(nu+0.5,1,Q.*SNRpost);
    Teller2=ConflHyperGeomFun(nu+1,1,Q.*SNRpost);
    Noemer=ConflHyperGeomFun(nu,1,Q.*SNRpost);
    G1=gamma(nu+0.5)/gamma(nu)*sqrt(Q./SNRpost).*Teller./Noemer;
    G2=nu*(Q./SNRpost).*Teller2./Noemer;
    % asymptotic result for Q.*SNRpost>700 (Abramowitz and Stegun, 13.5.1) For very high values of nu and a posteriori SNR a value lower than 700 might be more appropriate.
    I=find(Q.*SNRpost>700);
    G1(I)=Q(I);
    G2(I)=Q(I).^2;
end
