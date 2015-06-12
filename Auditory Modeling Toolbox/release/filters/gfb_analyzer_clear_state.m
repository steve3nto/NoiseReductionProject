function analyzer = gfb_analyzer_clear_state(analyzer)
%GFB_ANALYZER_CLEAR_STATE  Reset filter states
%   Usage: analyzer = gfb_analyzer_clear_state(analyzer)
%
%   analyzer=GFB_ANALYZER_CLEAR_STATE(analyzer) resets the filter states
%   to zeros
%
%   Url: http://amtoolbox.sourceforge.net/doc/filters/gfb_analyzer_clear_state.php

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
  
% copyright: Universitaet Oldenburg
% author   : tp
% date     : Jan 2002, Nov 2006, Feb 2007

for band = [1:length(analyzer.center_frequencies_hz)]
  analyzer.filters(1, band) = ...
      gfb_filter_clear_state(analyzer.filters(1, band));
end

