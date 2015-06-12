function [ur,fs]  = data_roenne2012(varargin)
%DATA_ROENNE2012 Unitary response
%   Usage: ur = data_roenne2012()
%
%   [ur,fs]=DATA_ROENNE2012 returns the unitary response from Roenne
%   (2012) and its sampling frequency, fs=30000.
%
%   Examples:
%   ---------
%
%   The first plot shows the unitary response in the time-domain:
%
%     [ur,fs]  = data_roenne2012;
%     plot((0:length(ur)-1)/fs,ur);
%     xlabel('Time / seconds');
%     ylabel('Amplitude');
%
%   The second plot shows the magnitude response of the unitary
%   response, normalized so the highest peak reaches 0-dB:
%
%     [ur,fs]  = data_roenne2012;
%     magresp(ur,fs,90,'fir','1');
%
%   References:
%     F. Roenne, J. Harte, C. Elberling, and T. Dau. Modeling auditory evoked
%     brainstem responses to transient stimuli. J. Acoust. Soc. Am., accepted
%     for publication, 2012.
%     
%
%   Url: http://amtoolbox.sourceforge.net/doc/humandata/data_roenne2012.php

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
  
s=amtload('roenne2012','ur.mat');
ur=s.ur;

fs=30000;



