function definput=arg_lindemann1986bincorr(definput)

definput.keyvals.c_s   = 0.3;
definput.keyvals.w_f   = 0.035;
definput.keyvals.M_f   = 6;
definput.keyvals.T_int = 5;
definput.keyvals.N_1   = 1;

definput.groups.stationary={'T_int',Inf,'N_1',17640'};

%
%   Url: http://amtoolbox.sourceforge.net/doc/arg/arg_lindemann1986bincorr.php

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

