function definput=arg_eicell(definput)

  definput.keyvals.tc    = 30e-3;   % Temporal smoothing constant
  definput.keyvals.rc_a  = 0.1;     % Range compression parameter 'a' 
  definput.keyvals.rc_b  = .00002;  % Range compression parameter 'b'
  definput.keyvals.ptau  = 2.2e-3;  % time constant for p(tau) function

%
%   Url: http://amtoolbox.sourceforge.net/doc/arg/arg_eicell.php

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

