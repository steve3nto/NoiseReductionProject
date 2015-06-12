function outsig = viemeister1979(insig,fs)
%VIEMEISTER1979  The Viemeister (1979) leaky-integrator model
%   Usage: outsig=viemeister1979(insig,fs);
%
%   This model is included mostly as a test, as it is so simple.
%
%   Url: http://amtoolbox.sourceforge.net/doc/monaural/viemeister1979.php

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
 
% ------ Checking of input parameters ---------
  
error(nargchk(2,2,nargin));

  
% 4-6 kHz four-pole Butterworth Bandpass (missing)
  
% halfwave rectification
insig = max(insig,0);

% first-order lowpass filter @ 65 Hz
[lp_b,lp_a] = butter(1,65/(fs/2));
insig = filter(lp_b, lp_a, insig);

% ac-coupled rms = std
outsig = std(insig,1);


