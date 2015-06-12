function outsig = bmsin(fc,mf,fs)
%BMSIN Generate a binaural modulated sinus
%   Usage: outsig = bmsin(fc,mf,fs)
%
%   Input parameters:
%       fc  : carrier frequency of the sinus (Hz)
%       mf  : binaural modulation frequency (Hz)
%       fs  : sampling rate (Hz)
%
%   Output parameters:
%       outsig  : fs x2 sinusoid signal
%
%   BMSIN(fc,mf,fs) generates an binaural modulated sinusoid with a
%   carrier frequency of f and a frequency moving around the two ears of
%   mf.
%
%   Url: http://amtoolbox.sourceforge.net/doc/signals/bmsin.php

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

% ------ Checking of input parameters ---------

error(nargchk(3,3,nargin));

if ~isnumeric(fc) || ~isscalar(fc) || fc<0
    error('%s: f has to be a positive scalar.',upper(mfilename));
end

if ~isnumeric(mf) || ~isscalar(mf) || mf<=0
    error('%s: mf has to be a positive scalar.',upper(mfilename));
end

if ~isnumeric(fs) || ~isscalar(fs) || fs<=0
    error('%s: fs has to be a positive scalar!',upper(mfilename));
end


% ------ Computation --------------------------
% Create a one second time 
t = (1:fs)/fs;
% Left signal
sigl = sin(2*pi*fc.*t);
% Right signal with amplitude modulation
sigr = sin(2*pi*fc.*t + sin(2*pi*mf.*t));
outsig = [sigl' sigr'];
% Scale outsig
outsig = outsig / (max(abs(outsig(:)))+eps);


