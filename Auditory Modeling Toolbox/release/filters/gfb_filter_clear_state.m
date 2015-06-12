function filter = gfb_filter_clear_state(filter)
%GFB_FILTER_CLEAR_STATE  Clear filters
%   Usage: filter = gfb_filter_clear_state(filter)
%
%   Input parameters:
%     filter : a gfb_filter structure as returned by
%              GFB_FILTER_NEW.
%
%   GFB_FILTER_CLEAR_STATE(filter) returns a copy of the filter, with the
%   filter state cleared.
%
%   See also: gfb_filter_new
%
%   Url: http://amtoolbox.sourceforge.net/doc/filters/gfb_filter_clear_state.php

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
% date     : Jan 2002, Nov 2006


filter.state = zeros(1, filter.gamma_order);


