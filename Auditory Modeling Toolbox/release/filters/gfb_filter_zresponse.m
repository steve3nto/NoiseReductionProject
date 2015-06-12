function zresponse = gfb_filter_zresponse(filter, z)
%GFB_FILTER_ZRESPONSE  Filter response at freqenzy z
%   Usage: zresponse = gfb_filter_zresponse(filter, z)
%
%   Input parameters:
%     filter  : A gfb_Filter struct as created by gfb_filter_new.
%     z       : A vector of z-plane frequencies where the frequency response should
%               be computed. z = exp(2i*pi*f/fs)
%   Output parameters:
%     zresponse : The complex response of the filter at z.
%
%   Computes the frequency response of the gammatone filter at the frequency z.
%
%   Url: http://amtoolbox.sourceforge.net/doc/filters/gfb_filter_zresponse.php

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

% author   : tp
% date     : Jan & Nov 2006

zresponse = (1 - filter.coefficient ./ z) .^ -filter.gamma_order * ...
    filter.normalization_factor;

