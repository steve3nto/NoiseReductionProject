function zresponse = gfb_analyzer_zresponse(analyzer, z)
%GFB_ANALYZER_ZRESPONSE  Frequency response
%   USAGE: zresponse = gfb_analyzer_zresponse(analyzer, z)
%
%   Input parameters:
%     analyzer : A gfb_analyzer struct as created by gfb_analyzer_new.
%     z        : A vector of z-plane frequencies where the frequency response
%                should be computed. z = exp(2i*pi*f/fs)
%
%   Output parameters:
%     zresponse : The complex frequency response of the filter
%
%   GFB_ANALYZER_ZRESPONSE(analyzer,z) computes the frequency response of
%   the gammatone filters in the filterbank at the frequencies z.
%   The frequency responses of the filters in the filterbank are stored
%   as columns in the output.
%
%   Url: http://amtoolbox.sourceforge.net/doc/filters/gfb_analyzer_zresponse.php

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
% date     : Jan & Nov 2006, Jan Feb 2007

number_of_bands = length(analyzer.center_frequencies_hz);
z = z(:);
zresponse = ones(length(z), number_of_bands);

for band = [1:number_of_bands]
  filter = analyzer.filters(band);
  zresponse(:,band) = gfb_filter_zresponse(filter, z);
end

