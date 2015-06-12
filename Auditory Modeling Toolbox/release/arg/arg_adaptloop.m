function definput=arg_adaptloop(definput)
 
  definput.keyvals.limit=10;
  definput.keyvals.minlvl=0;
  definput.keyvals.tau=[0.005 0.050 0.129 0.253 0.500];
  
  definput.groups.adt_dau      = {'tau',[0.005 0.050 0.129 0.253 0.500]};
  definput.groups.adt_breebaart = {'tau',linspace(0.005,0.5,5)};
  definput.groups.adt_puschel  = {'tau',linspace(0.005,0.5,5),'limit',0};


%
%   Url: http://amtoolbox.sourceforge.net/doc/arg/arg_adaptloop.php

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

