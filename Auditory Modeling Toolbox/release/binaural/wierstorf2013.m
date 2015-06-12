function [localization_error,perceived_direction,desired_direction,x,y,x0] = ...
        wierstorf2013(X,Y,phi,xs,src,L,varargin);
%WIERSTORF2013 estimate the localization within a WFS or stereo setup
%   Usage: [...] = wierstorf2013(X,Y,phi,xs,src,L,method,...);
%
%   Input parameters:
%       X           : range of the x-axis [xmin,xmax] or a single point x / m
%       Y           : range of the y-axis [ymin ymax] or a single point y / m
%       phi         : orientation of the listener in rad (0 is in the direction
%                     of the x-axis)
%       xs          : position of the point source in m / direction of the 
%                     plane wave
%       src         : source type
%                       'ps' for a point source
%                       'pw' for a plane wave
%       L           : length/diameter of the loudspeaker array
%       method      : reproduction setup
%                       'wfs' for wave field synthesis
%                       'setreo' for stereophony
%
%   Output parameters:
%       localization_error  : deviation from the desired direction, defined as
%                             perceived_direction - desired_direction / degree
%       perceived_direction : the direction of arrival the binaural model has
%                             estimated for our given setup / degree
%       desired_direction   : the desired direction of arrival indicated by the
%                             source position xs / degree
%       x                   : corresponding x-axis
%       y                   : corresponding y-axis
%       x0                  : position and directions of the loudspeakers in the
%                             form n x 7, where n is the number of loudspeakers
%
%   WIERSTORF2013(X,Y,phi,xs,src,L,method) calculates the localization
%   error for the defined wave field synthesis or stereophony setup. The
%   localization error is defined here as the difference between the perceived
%   direction as predicted by the dietz2011 binaural model and the desired
%   direction given by xs. The loudspeaker setup for the desired reproduction
%   method is simulated via HRTFs which are than convolved with white noise
%   which is fed into the binaural model.
%
%   The following parameters may be passed at the end of the line of
%   input arguments:
%
%     'resolution',resolution
%                      Resolution of the points in the listening
%                      area. Number of points is resoluation x resolution. If
%                      only one point in the listening area is given via single
%                      values for X and Y, the resolution is automatically set
%                      to 1.
%
%     'nls',nls        Number of loudspeaker of your WFS setup.
%                      Default value is 2.
%
%     'array',array    Array type to use, could be 'linear' or 'circle'.
%                      Default value is 'linear'.
%
%     'hrtf',hrtf      HRTF database. This have to be in the TU-Berlin
%                      mat-format, see:
%                      https://dev.qu.tu-berlin.de/projects/measurements/wiki/IRs_file_format
%                      Default HRTF set is the 3m one from TU-Berlin measured
%                      with the KEMAR.
%
%     'lookup',lookup  Lookup table to map ITD values to angles. This can be
%                      created by the itd2anglelookuptable function. Default
%                      value is the lookup table itd2anglelookuptable.mat that comes with AMT.
%
%
%   For the simulation of the wave field synthesis or stereophony setup this
%   functions depends on the Sound-Field-Synthesis Toolbox, which is available
%   here: http://github.com/sfstoolbox/sfs. It runs under Matlab and Octave. The
%   revision used to generate the figures in the corresponding paper is
%   a8914700a4.
%
%   See also: wierstorf2013estimateazimuth, dietz2011, itd2angle
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
%   Url: http://amtoolbox.sourceforge.net/doc/binaural/wierstorf2013.php

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

%   Copyright (c) 2013   Assessment of IP-based Applications
%                        Technische Universitaet Berlin
%                        Ernst-Reuter-Platz 7, 10587 Berlin, Germany


%% ===== Checking of input parameters and dependencies ===================
nargmin = 7;
nargmax = 17;
error(nargchk(nargmin,nargmax,nargin));
if length(xs)==2 xs = [xs 0]; end

definput.flags.method = {'stereo','wfs'};
definput.keyvals.array = 'linear';
definput.keyvals.nls = 2;
definput.keyvals.resolution = 21;
definput.keyvals.hrtf = [];
definput.keyvals.lookup = [];
definput.keyvals.showprogress = 1;
[flags,kv] = ...
    ltfatarghelper({'resolution','nls','array','hrtf','lookup','showprogress'},definput,varargin);
array = kv.array;
resolution = kv.resolution;
number_of_speakers = kv.nls;
hrtf = kv.hrtf;
lookup = kv.lookup;
showprogress = kv.showprogress;

% Check for the Sound-Field-Synthesis Toolbox
if ~which('SFS_start')
    error(['%s: you need to install the Sound-Field-Synthesis Toolbox.\n', ...
        'You can download it at https://github.com/sfstoolbox/sfs.\n', ...
        'You need version 1.0.0 of the Toolbox (commit ...).'], ...
        upper(mfilename));
end

% Check if we have only one position or if we have a whole listening area
if length(X)==1 && length(Y)==1
    resolution = 1;
end


%% ===== Configuration ===================================================
% The following settings are all for the Sound Field Synthesis Toolbox
conf.N = 1024;
conf.ir.usehcomp = false;
conf.ir.hcompfile = '';
conf.ir.useinterpolation = true;
conf.ir.useoriglength = false;
conf.dimension = '2.5D';
conf.driving_functions = 'default';
conf.wfs.usehpre = true;
conf.wfs.hpretype = 'FIR';
conf.wfs.hpreflow = 50;
conf.usetapwin = true;
conf.tapwinlen = 0.3;
conf.debug = false;
conf.showprogress = false;
conf.c = 343;
conf.fs = 44100;
conf.usefracdelay = 0;
conf.fracdelay_method = '';
conf.secondary_sources.center = [0 0 0];
conf.secondary_sources.x0 = [];


%% ===== Loading of additional data ======================================
% Load default 3m TU-Berlin KEMAR HRTF from the net if no one is given to the
% function
if isempty(hrtf)
    % load HRTFs, see:
    % https://dev.qu.tu-berlin.de/projects/measurements/wiki/2010-11-kemar-anechoic
%     [~,path] = download_hrtf('wierstorf2011_3m');
    irs=amtload('wierstorf2013', 'QU_KEMAR_anechoic_3m.mat');
    check_irs(irs.irs);
    hrtf = fix_irs_length(irs.irs,conf);
end
% Get sampling rate from the HRTFs
fs = hrtf.fs;
% Load lookup table from the AMT if no one is given to the function
if isempty(lookup)
    % load lookup table to map ITD values of the model to azimuth angles.
    % the lookup table was created using the same HRTF database
    lookup = amtload('wierstorf2013','itd2anglelookuptable.mat');
end


%% ===== Simulate the binaural ear signals ===============================
% array geometry
conf.secondary_sources.geometry = array;
% center of array
conf.secondary_sources.center = [0 0 0];
% initialize empty array
conf.secondary_sources.x0 = [];
% number of loudspeakers
conf.secondary_sources.number = number_of_speakers;
% length of array
conf.secondary_sources.size = L;
% get loudspeaker positions
x0 = secondary_source_positions(conf);
% calculate the stop frequency for the WFS pre-equalization filter
conf.wfs.hprefhigh = aliasing_frequency(x0,conf);

% selection of loudspeakers for WFS
if flags.do_wfs && strcmpi('circle',array)
    x0 = secondary_source_selection(x0,xs,src);
end

% get a grid of the listening positions
conf.resolution = resolution;
[~,~,~,x,y] = xyz_grid(X,Y,0,conf);

% 700 ms white noise burst
sig_noise = whitenoiseburst(fs);
for ii=1:length(x)
    if showprogress, amtdisp([num2str(ii) ' of ' num2str(length(x))],'progress'); end
    for jj=1:length(y)
        X = [x(ii) y(jj) 0];
        if strcmpi('circle',array) && norm(X)>L/2
            desired_direction(ii,jj) = NaN;
            perceived_direction(ii,jj) = NaN;
            localization_error(ii,jj) = NaN;
        else
            desired_direction(ii,jj) = source_direction(X,phi,xs,src);
            if flags.do_stereo
                % first loudspeaker
                ir1 = ir_point_source(X,phi,x0(1,1:3),hrtf,conf);
                % second loudspeaker
                ir2 = ir_point_source(X,phi,x0(2,1:3),hrtf,conf);
                % sum of both loudspeakers
                ir = (ir1+ir2)/2;
            else % WFS
                conf.xref = X;
                ir = ir_wfs(X,pi/2,xs,src,hrtf,conf);
            end
            % convolve impulse response with noise burst
            sig = auralize_ir(ir,sig_noise,1,conf);
            % estimate the perceived direction
            % this is done by calculating ITDs with the dietz2011 binaural model,
            % which are then mapped to azimuth values with a lookup table
            perceived_direction(ii,jj) = wierstorf2013estimateazimuth(sig,lookup, ...
                'dietz2011','no_spectral_weighting','remove_outlier');
            localization_error(ii,jj) = perceived_direction(ii,jj)-desired_direction(ii,jj);
        end
    end
end

end % of main function


%% ----- Subfunctions ----------------------------------------------------
function direction = source_direction(X,phi,xs,src)
    if strcmp('pw',src)
        [direction,~,~] = cart2sph(xs(1),xs(2),xs(3));
        direction = (direction+phi)/pi*180;
    elseif strcmp('ps',src)
        x = xs-X;
        [direction,~,~] = cart2sph(x(1),x(2),x(3));
        direction = (direction-phi)/pi*180;
    end
end

