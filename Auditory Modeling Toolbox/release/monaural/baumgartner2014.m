function varargout = baumgartner2014( target,template,varargin )
%BAUMGARTNER2014 Model for localization in saggital planes
%   Usage:    [p,rang] = baumgartner2014( target,template )
%             [p,rang,tang] = baumgartner2014( target,template )
%             [p,rang,tang] = baumgartner2014( target,template,fs,S,lat,stim,fsstim )
%
%   Input parameters:
%     target  : binaural impulse response(s) referring to the directional 
%               transfer function(s) (DFTs) of the target sound(s).
%               Option 1: given in SOFA format -> sagittal plane DTFs will 
%               be extracted internally. 
%               Option 2: binaural impulse responses of all available
%               listener-specific DTFs of the sagittal plane formated 
%               according to the following matrix dimensions: 
%               time x direction x channel/ear
%     template: binaural impulse responses of all available
%               listener-specific DTFs of the sagittal plane referring to
%               the perceived lateral angle of the target sound.
%               Options 1 & 2 equivalent to target.
%
%   Output parameters:
%     p       : predicted probability mass vectors for response angles 
%               with respect to target positions
%               1st dim: response angle
%               2nd dim: target angle
%     rang    : polar response angles (after regularization of angular 
%               sampling)
%     tang    : polar target angles (usefull if sagittal-plane HRTFs are
%               extracted directly from SOFA object)
%
%   BAUMGARTNER2014(...) is a model for sound-source localization
%   in sagittal planes (SPs). It bases on the comparison of internal sound 
%   representation with a template and results in a probabilistic
%   prediction of polar angle response.
%
%   BAUMGARTNER2014 accepts the following optional parameters:
%
%     'fs',fs        Define the sampling rate of the impulse responses. 
%                    Default value is 48000 Hz.
%
%     'S',S          Set the listener-specific sensitivity threshold 
%                    (threshold of the sigmoid link function representing 
%                    the psychometric link between transformation from the
%                    distance metric and similarity index) to S. 
%                    Default value is 1.
%
%     'lat',lat      Set the apparent lateral angle of the target sound to
%                    lat. Default value is 0 degree (median SP).
%
%     'stim',stim    Define the stimulus (source signal without directional
%                    features). As default an impulse is used.
%
%     'fsstim',fss   Define the sampling rate of the stimulus. 
%                    Default value is 48000 Hz.
%
%     'flow',flow    Set the lowest frequency in the filterbank to
%                    flow. Default value is 700 Hz.
%
%     'fhigh',fhigh  Set the highest frequency in the filterbank to
%                    fhigh. Default value is 18000 Hz.
%
%     'space',sp     Set spacing of auditory filter bands (i.e., distance 
%                    between neighbouring bands) to sp in number of
%                    equivalent rectangular bandwidths (ERBs). 
%                    Default value is 1 ERB.
%
%     'do',do        Set the differential order of the spectral gradient 
%                    extraction to do. Default value is 1 and includes  
%                    restriction to positive gradients inspired by cat DCN
%                    functionality.
%
%     'bwcoef',bwc   Set the binaural weighting coefficient bwc.
%                    Default value is 13 degrees.
%
%     'polsamp',ps   Define the polar-angle sampling of the acoustic data
%                    provided for the current sagittal plane. As default the 
%                    sampling of ARI's HRTFs in the median SP is used, i.e.,
%                    ps = [-30:5:70,80,100,110:5:210] degrees.
%
%     'rangsamp',rs  Define the equi-polar sampling of the response predictions.
%                    The default is rs = 5 degrees.
%
%     'mrsmsp',eps   Set the motoric response scatter eps within the median 
%                    sagittal plane. Default value is 17 degrees.
%
%   BAUMGARTNER2014 accepts the following flags:
%
%     'regular'      Apply spline interpolation in order to regularize the 
%                    angular sampling of the polar response angle. 
%                    This is the default.
%
%     'noregular'    Disable regularization of angular sampling.
%
%   Requirements: 
%   -------------
%
%   1) SOFA API from http://sourceforge.net/projects/sofacoustics for Matlab (in e.g. thirdparty/SOFA)
% 
%   2) Data in hrtf/baumgartner2014
%
%
%   See also: plot_baumgartner2014, data_baumgartner2014,
%   exp_baumgartner2014, demo_baumgartner2014, baumgartner2014calibration,
%   baumgartner2014likelistat, baumgartner2014pmv2ppp,
%   baumgartner2014virtualexp
%
%   References:
%     R. Baumgartner, P. Majdak, and B. Laback. Modeling sound-source
%     localization in sagittal planes for human listeners. The Journal of the
%     Acoustical Society of America, 136(2):791-802, 2014.
%     
%     R. Lyon. All pole models of auditory filtering. In E. R. Lewis, G. R.
%     Long, R. F. Lyon, P. M. Narins, C. R. Steele, and E. Hecht-Poinar,
%     editors, Diversity in auditory mechanics, pages 205-211. World
%     Scientific Publishing, Singapore, 1997.
%     
%
%   Url: http://amtoolbox.sourceforge.net/doc/monaural/baumgartner2014.php

% Copyright (C) 2009-2015 Piotr Majdak and Peter L. Søndergaard.
% This file is part of AMToolbox version 0.9.7
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

    
% AUTHOR: Robert Baumgartner, Acoustics Research Institute, Vienna, Austria

%% Check input

definput.import={'baumgartner2014'};

[flags,kv]=ltfatarghelper(...
  {'fs','S','lat','stim','fsstim','space','do','flow','fhigh',...
  'bwcoef','polsamp','rangsamp','mrsmsp','gamma'},definput,varargin);

% Print Settings
if flags.do_print 
  if flags.do_mrs
    fprintf('Settings: PSGE = %1.0f; Gamma = %1.0u; Epsilon = %1.0f deg \n',kv.do,kv.gamma,kv.mrsmsp)
  else
    fprintf('Settings: PSGE = %1.0f; Gamma = %1.0u; Epsilon = 0 deg \n',kv.do,kv.gamma)
  end
end

% HRTF format conversion
if isstruct(target) % Targets given in SOFA format
  kv.fs = target.Data.SamplingRate;
  [target,tang] = extractsp( kv.lat,target );
end

if isstruct(template) % Template given in SOFA format
  [template,kv.polsamp] = extractsp( kv.lat,template );
end


% Error handling
if size(template,2) ~= length(kv.polsamp)
  fprintf('\n Error: Second dimension of template and length of polsamp need to be of the same size! \n')
  return
end


%% Stimulus 
if isempty(kv.stim) 
    kv.stim = [1;0];
    kv.fsstim = kv.fs;
elseif isempty(kv.fsstim) 
    kv.fsstim = kv.fs;
end


%% DTF filtering, Eq.(1)
if ~isequal(kv.fs,kv.fsstim)
    amtdisp('Sorry, sampling rate of stimulus and HRIRs must be equal!')
    return
end
state=warning('off'); % convolve throws a warning
tmp = convolve(target,kv.stim);
warning(state);
target = reshape(tmp,[size(tmp,1),size(target,2),size(target,3)]);
    

%% Spectral Analysis, Eq.(2)

if kv.space == 1 % Standard spacing of 1 ERB
  [ireptar,fc] = auditoryfilterbank(target(:,:),kv.fs,...
      'flow',kv.flow,'fhigh',kv.fhigh);
  ireptem = auditoryfilterbank(template(:,:),kv.fs,...
      'flow',kv.flow,'fhigh',kv.fhigh);
else
  fc = audspacebw(kv.flow,kv.fhigh,kv.space,'erb');
  [bgt,agt] = gammatone(fc,kv.fs,'complex');
  ireptar = 2*real(ufilterbankz(bgt,agt,target(:,:)));  % channel (3rd) dimension resolved
  ireptem = 2*real(ufilterbankz(bgt,agt,template(:,:)));
end
Nfc = length(fc);   % # of bands

% Set back the channel dimension
ireptar = reshape(ireptar,[size(target,1),Nfc,size(target,2),size(target,3)]);
ireptem = reshape(ireptem,[size(template,1),Nfc,size(template,2),size(template,3)]);

% Averaging over time (RMS)
ireptar = 20*log10(squeeze(rms(ireptar)));      % in dB
ireptem = 20*log10(squeeze(rms(ireptem)));

if size(ireptar,2) ~= size(target,2) % retreive polar dimension if squeezed out
    ireptar = reshape(ireptar,[size(ireptar,1),size(target,2),size(target,3)]);
end

%% Positive spectral gradient extraction, Eq.(3)

nrep.tem = zeros(size(ireptem,1)-kv.do,size(ireptem,2),size(ireptem,3)); %init
nrep.tar = zeros(size(ireptar,1)-kv.do,size(ireptar,2),size(ireptar,3)); %init
for ch = 1:size(ireptar,3)
  if kv.do == 1 % DCN inspired feature extraction
      nrep.tem(:,:,ch) = max(diff(ireptem(:,:,ch),kv.do),0);
      nrep.tar(:,:,ch) = max(diff(ireptar(:,:,ch),kv.do),0);
  elseif kv.do == 2 % proposed by Zakarauskas & Cynader (1993)
      nrep.tem(:,:,ch) = diff(ireptem(:,:,ch),kv.do);
      nrep.tar(:,:,ch) = diff(ireptar(:,:,ch),kv.do);
  else
      nrep.tem(:,:,ch) = ireptem(:,:,ch);
      nrep.tar(:,:,ch) = ireptar(:,:,ch);
  end
end

%% Comparison process, Eq.(4)

sigma=zeros(size(ireptem,2),size(ireptar,2),size(ireptem,3)); % init
for ch = 1:size(ireptar,3)
  for it = 1:size(ireptar,2)
    isd = repmat(nrep.tar(:,it,ch),[1,size(nrep.tem(:,:,ch),2),1]) - nrep.tem(:,:,ch); 
    if kv.do == 0
      sigma(:,it,ch) = sqrt(squeeze(var(isd))); % standard dev. across frequencies
    else
      sigma(:,it,ch) = mean(abs(isd)); % L1-norm across frequencies
    end
  end
end

%% Similarity estimation, Eq.(5)

si=zeros(size(sigma)); % init
for ch = 1:size(ireptar,3)
  for it = 1:size(ireptar,2)
    si(:,it,ch) = 1+eps - (1+exp(-kv.gamma*(sigma(:,it,ch)-kv.S))).^-1;
  end
end


%% Binaural weighting, Eq.(6)

if size(si,3) == 2
    binw = 1./(1+exp(-kv.lat/kv.bwcoef)); % weight of left ear signal with 0 <= binw <= 1
    si = binw * si(:,:,1) + (1-binw) * si(:,:,2);
end


%% Interpolation (regularize polar angular sampling)
if flags.do_regular
    rang0 = ceil(min(kv.polsamp)*1/kv.rangsamp)*kv.rangsamp;    % ceil to kv.rangsamp deg
    rangs = rang0:kv.rangsamp:max(kv.polsamp);
    siint = zeros(length(rangs),size(si,2));
    for tt = 1:size(si,2)
        siint(:,tt) = interp1(kv.polsamp,si(:,tt),rangs,'spline');
    end
    si = siint;
    si(si<0) = 0; % SIs must be positive (necessary due to spline interp)
else
    rangs = kv.polsamp;
end


%% Sensorimotor mapping, Eq.(7)
if flags.do_mrs && flags.do_regular && kv.mrsmsp > 0
  
    angbelow = -90:kv.rangsamp:min(rangs)-kv.rangsamp;
    angabove = max(rangs)+kv.rangsamp:kv.rangsamp:265;
    rangs = [angbelow,rangs,angabove];
    si = [zeros(length(angbelow),size(si,2)) ; si ; zeros(length(angabove),size(si,2))];
    
    mrs = kv.mrsmsp/cos(deg2rad(kv.lat)); % direction dependent scatter (derivation: const. length rel. to the circumferences of circles considered as cross sections of a unit sphere)
    
    x = 0:2*pi/length(rangs):2*pi-2*pi/length(rangs);
    kappa = 1/deg2rad(mrs)^2; % concentration parameter (~1/sigma^2 of normpdf)
    mrspdf = exp(kappa*cos(x)) / (2*pi*besseli(0,kappa)); % von Mises PDF 
    for tt = 1:size(si,2)
      si(:,tt) = pconv(si(:,tt),mrspdf(:));
    end
    
end


%% Normalization to PMV, Eq.(8)
p = si ./ repmat(sum(si),size(si,1),1);


%% Output
varargout{1} = p;
if nargout >= 2
    varargout{2} = rangs;
    if nargout >= 3
      try
        varargout{3} = tang;
      catch
        amtdisp('SOFA Object of target DTFs is required to output target angles.')
      end
    end
end
  
end
