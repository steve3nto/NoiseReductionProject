function bw = audfiltbw(fc)
%AUDFILTBW  Bandwidth of auditory filter
%   Usage: bw = audfiltbw(fc)
%
%   AUDFILTBW(fc) returns the equivalent rectangular bandwidth of the
%   auditory filter at center frequency fc. The function uses the
%   relation
%
%      bw = 24.7 + fc/9.265
%
%   as estimated in Glasberg and Moore (1990)
%
%   See also: freqtoerb, erbspace
%
%   References:
%     B. R. Glasberg and B. Moore. Derivation of auditory filter shapes from
%     notched-noise data. Hearing Research, 47(1-2):103, 1990.
%     
%     
%
%   Url: http://ltfat.github.io/doc/auditory/audfiltbw.html

% Copyright (C) 2005-2015 Peter L. Soendergaard <peter@sonderport.dk>.
% This file is part of LTFAT version 2.1.0
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
  
%   AUTHOR : Peter L. Søndergaard
  
% ------ Checking of input parameters ---------
  
error(nargchk(1,1,nargin));

if ~isnumeric(fc) || any(fc(:)<0)
  error('AUDFILTBW: fc must be non-negative.');
end;

% ------ Computation --------------------------

% FIXME: What is the upper frequency for which the estimation is valid?

bw = 24.7 + fc/9.265;


