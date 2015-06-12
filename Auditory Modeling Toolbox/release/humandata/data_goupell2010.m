function data = data_goupell2010(varargin)
%DATA_GOUPELL2010 Localization performance in sagittal planes
%   Usage: data = data_goupell2010(condition)
%          data = data_goupell2010(lat, dlat, condition)
%
%   Listener-specific experimental data from Goupell et al. (2010) testing
%   localization performance in sagittal planes for various numbers of
%   channels of a GET vocoder.
%
%   The condition flag may be one of:
%
%     'BB'   Broadband DTFs (baseline condition)
%     'CL'   Click trains with unlimited number of channels
%     'N24'  24 vocoder channels
%     'N18'  18 vocoder channels
%     'N12'  12 vocoder channels
%     'N9'   9 vocoder channels
%     'N6'   6 vocoder channels
%     'N3'   3 vocoder channels
%
%   Output parameters:
%     data.id    : listener ID
%     data.mtx   : experimental data matrix conaining 9 colums
%                  col 1: target azimuth
%                  col 2: target elevation
%                  col 3: response azimuth
%                  col 4: response elevation
%                  col 5: lateral angle of target
%                  col 6: polar angle of target
%                  col 7: lateral angle of response
%                  col 8: polar angle of response
%
%   References goupell2010numchan
%
%   Url: http://amtoolbox.sourceforge.net/doc/humandata/data_goupell2010.php

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

% AUTHOR: Robert Baumgartner

%% Check input options

% Define input flags
definput.flags.condition = {'BB','CL','N24','N18','N12','N9','N6','N3'};

% Parse input options
[flags,kv]  = ltfatarghelper({},definput,varargin);

%% Extract data
x=amtload('goupell2010','data.mat');

C = find(ismember(x.condition,flags.condition));

for ll = 1:length(x.subject)
  
  data(ll).mtx = x.subject(ll).expData{C}(:,1:8);
  data(ll).id = x.subject(ll).id;

end
