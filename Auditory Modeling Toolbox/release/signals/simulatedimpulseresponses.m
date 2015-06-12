function [ir,fs]=simulatedimpulseresponses(duration)
%SIMULATEDIMPULSERESPONSES  Return a simulated impulse response
%   Usage: ir=simulatedimpulseresponses(duration);
%          [ir,fs]=simulatedimpulseresponses(duration);
%
%   SIMULATEDIMPULSERESPONSES(duration) returns a simulated impulse
%   response of length duration, where the duration is measured in
%   seconds. Only four durations (T30) are possible to select: 0.4, 0.7,
%   1.3, and 2.3 seconds.
%
%   [ir,fs]=SIMULATEDIMPULSERESPONSES(duration) also returns the
%   sampling frequency, fs = 44100 Hz.
%
%   The impulse responses were created using the ODEON room acoustic
%   software version 10 (Christensen, 2009). The simulated room was shaped
%   like an auditorium with maximal dimensions of 28x16x10m
%   (length-width-height).
%
%   The source and the receiver were horizontally with a fixed distance of
%   5m, and placed approximately the center of the room. All surfaces had
%   the same coefficient, which was adjusted individually frequency such
%   that the room had similar reverberation (T30) in the octave bands from
%   63 to 8000 Hz.
%
%   The corresponding clarity (C50), defined as the ratio of the energy of
%   first 50 ms of the impulse response to the energy of the part, was 0.60,
%   -2.9, -6.6, and -8.0 dB for the four different lengths, respectively.
%
%   See also: joergensen2011 joergensen2013
%
%   Url: http://amtoolbox.sourceforge.net/doc/signals/simulatedimpulseresponses.php

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

switch(duration)
 case {0.4,0.7,1.3,2.3}
   [ir,fs]=amtload('signals',['simulatedimpulseresponses_',num2str(duration),'s.wav']);
 otherwise
   error('%s: Unsupported duration.',upper(mfilename));  
end;

