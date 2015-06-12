function lookup = itd2anglelookuptable(irs,varargin)
%ITD2ANGLELOOKUPTABLE generates an ITD-azimuth lookup table for the given HRTF set
%   Usage: lookup = itd2anglelookuptable(irs,fs,model);
%          lookup = itd2anglelookuptable(irs,fs);
%          lookup = itd2anglelookuptable(irs);
%
%   Input parameters:
%       irs    : HRTF data set (at the moment only TU Berlin irs format)
%       fs     : sampling rate, (default: 44100) / Hz
%       model  : binaural model to use:
%                   'dietz2011' uses the Dietz binaural model (default)
%                   'lindemann1986' uses the Lindemann binaural model
%
%   Output parameters:
%       lookup : struct containing the polinomial fitting data for the
%                ITD -> azimuth transformation, p,MU,S, see help polyfit
%
%   ITD2ANGLELOOKUPTABLE(irs) creates a lookup table from the given IR data
%   set. This lookup table can be used by the dietz2011 or lindemann1986 binaural
%   models to predict the perceived direction of arrival of an auditory event.
%   The azimuth angle is stored in degree in the lookup table.
%
%   For the handling of the HRTF file format this function depends on the
%   Sound-Field-Synthesis Toolbox, which is available here:
%   http://github.com/sfstoolbox/sfs. It runs under Matlab and Octave. The
%   revision used to genrate the figures in the corressponding paper is
%   a8914700a4.
%
%   See also: dietz2011, lindemann1986, wierstorf2013
%
%   References:
%     M. Dietz, S. D. Ewert, and V. Hohmann. Auditory model based direction
%     estimation of concurrent speakers from binaural signals. Speech
%     Communication, 53(5):592-605, 2011. [1]http ]
%     
%     H. Wierstorf, M. Geier, A. Raake, and S. Spors. A free database of
%     head-related impulse response measurements in the horizontal plane with
%     multiple distances. In Proceedings of the 130th Convention of the Audio
%     Engineering Society, 2011.
%     
%     H. Wierstorf, A. Raake, and S. Spors. Binaural assessment of
%     multi-channel reproduction. In J. Blauert, editor, The technology of
%     binaural listening, chapter 10. Springer, Berlin-Heidelberg-New York
%     NY, 2013.
%     
%     References
%     
%     1. http://www.sciencedirect.com/science/article/pii/S016763931000097X
%     
%
%   Url: http://amtoolbox.sourceforge.net/doc/general/itd2anglelookuptable.php

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

% AUTHOR: Hagen Wierstorf


%% ===== Checking of input parameters ===================================
nargmin = 1;
nargmax = 3;
error(nargchk(nargmin,nargmax,nargin));

definput.flags.model = {'dietz2011','lindemann1986'};
definput.keyvals.fs = 44100;
[flags,kv]=ltfatarghelper({'fs'},definput,varargin);


%% ===== Configuration ==================================================
% Samplingrate
fs = kv.fs;
% time of noise used for the calculation (samples)
nsamples = fs;
% noise type to use
noise_type = 'white';
% SFS Toolbox settings
conf.ir.useinterpolation = true;
conf.fs = fs;


%% ===== Calculation ====================================================
% generate noise signal
sig_noise = noise(nsamples,1,noise_type);
% get only the -90 to 90 degree part of the irs set
idx = (( irs.apparent_azimuth>-pi/2 & irs.apparent_azimuth<pi/2 & ...
    irs.apparent_elevation==0 ));
irs = slice_irs(irs,idx);
% iterate over azimuth angles
nangles = length(irs.apparent_azimuth);
% create an empty mod_itd, because the lindemann model didn't use it
mod_itd = [];

if flags.do_dietz2011

    itd = zeros(nangles,12);
    mod_itd = zeros(nangles,23);
    ild = zeros(nangles,23);
    for ii = 1:nangles
        % generate noise coming from the given direction
        ir = get_ir(irs,[irs.apparent_azimuth(ii) 0 irs.distance],'spherical',conf);
        sig = auralize_ir(ir,sig_noise,1,conf);
        % calculate binaural parameters
        [fine, cfreqs, ild_tmp, env] = dietz2011(sig,fs);
        % unwrap ITD
        itd_tmp = dietz2011unwrapitd(fine.itd,ild_tmp(:,1:12),fine.f_inst,2.5);
        env_itd_tmp = dietz2011unwrapitd(env.itd,ild_tmp(:,13:23),env.f_inst,2.5);
        % calculate the mean about time of the binaural parameters and store
        % them
        itd(ii,1:12) = median(itd_tmp,1);
        itd(ii,13:23) = median(env_itd_tmp,1);
        ild(ii,:) = median(ild_tmp,1);
    end

elseif flags.do_lindemann1986

    itd = zeros(nangles,36);
    ild = zeros(nangles,36);
    for ii = 1:nangles
        % generate noise coming from the given direction
        ir = get_ir(irs,[irs.apparent_azimuth(ii) 0 irs.distance],conf);
        sig = auralize_ir(ir,sig_noise,1,conf);
        % Ten fold upsampling to have a smoother output
        %sig = resample(sig,10*fs,fs);
        % calculate binaural parameters
        c_s = 0.3; % stationary inhibition
        w_f = 0; % monaural sensitivity
        M_f = 6; % decrease of monaural sensitivity
        T_int = inf; % integration time
        N_1 = 17640; % sample at which first cross-correlation is calculated
        [cc_tmp,dummy,ild(ii,:),cfreqs] = lindemann1986(sig,fs,c_s,w_f,M_f,T_int,N_1);
        clear dummy;
        cc_tmp = squeeze(cc_tmp);
        % Calculate tau (delay line time) axes
        tau = linspace(-1,1,size(cc_tmp,1));
        % find max in cc
        for jj = 1:size(cc_tmp,2)
            [v,idx] = max(cc_tmp(:,jj));
            itd(ii,jj) = tau(idx)/1000;
        end
    end

end

% Fit the lookup data
for n = 1:size(itd,2)
    [p(:,n),S{n},MU(:,n)] = polyfit(itd(:,n),irs.apparent_azimuth'./pi*180,12);
    [p_ild(:,n),S_ild{n},MU_ild(:,n)] = ...
        polyfit(ild(:,n),irs.apparent_azimuth'./pi*180,12);
end
% Create lookup struct
lookup.p = p;
lookup.MU = MU;
lookup.S = S;
lookup.p_ild = p_ild;
lookup.MU_ild = MU_ild;
lookup.S_ild = S_ild;

