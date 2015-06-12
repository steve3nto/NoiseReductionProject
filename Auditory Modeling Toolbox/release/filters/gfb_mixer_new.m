function mixer = gfb_mixer_new(analyzer, delay, iterations)
%GFB_MIXER_NEW  Create new mixer
%   Usage: mixer = gfb_mixer_new(analyzer, delay, iterations)
%
%   Input parameters:
%     analyzer : A gfb_analyzer structure as created by
%                gfb_analyzer_new. The mixer created by this function can
%                act as part of a synthesizer
%                that resynthesizes the output of this analyzer
%     delay :    A gfb_Delay structure as created by gfb_delay_new, together
%                with the mixer created by this function, this delay can
%                form a synthesizer that resynthesizes the output of the
%                analyzer
%     iterations : The gain factors are approximated numerically in
%                  iterations.  If this parameter is omitted, then the
%                  number of iterations will be GFB_GAINCALC_ITERATIONS
%                  (see gfb_set_constants.m, usually =100)
%
%   GFB_MIXER_NEW creates a gfb_mixer object with gain factors suitable
%   to calculate a weighted sum of the bands present in the output of the
%   given delay.  The gain factors are computed using a numerical optimization
%   method described in Herzke & Hohmann (2007).
%
%   Url: http://amtoolbox.sourceforge.net/doc/filters/gfb_mixer_new.php

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
% date     : Jan 2002, Nov 2003, Mar & Nov 2006, Jan Feb 2007


global GFB_GAINCALC_ITERATIONS;
gfb_set_constants;

mixer.type           = 'gfb_mixer';
center_frequencies   = analyzer.center_frequencies_hz;
number_of_bands   = length(center_frequencies);
sampling_frequency   = analyzer.fs;


% The center frequencies in the z plain
z_c = exp(2i * pi * center_frequencies(:) / sampling_frequency);

mixer.gains          = ones(number_of_bands, 1);

% compute the frequency response of each filter (col) at the center
% frequencies of all filters (row)
  pos_f_response = ...
    gfb_analyzer_zresponse(analyzer, z_c);
  neg_f_response = ...
    gfb_analyzer_zresponse(analyzer, conj(z_c));

% apply delay and phase correction
for band = [1:number_of_bands]
  pos_f_response(:,band) = pos_f_response(:,band) * ...
    delay.phase_factors(band) .* ...
    z_c .^ -delay.delays_samples(band);
  neg_f_response(:,band) = neg_f_response(:,band) * ...
    delay.phase_factors(band) .* ...
    conj(z_c) .^ -delay.delays_samples(band);
end

% combine responses at positive and negative responses to yield
% responses for real part.
f_response = (pos_f_response + conj(neg_f_response)) / 2;

if (nargin < 4)
  iterations = GFB_GAINCALC_ITERATIONS;
end
for i = [1:iterations]
  % add selected spectrum of all bands with gain factors
  selected_spectrum = f_response * mixer.gains;

  % calculate better gain factors from result
  mixer.gains = mixer.gains ./ abs(selected_spectrum);
end
mixer.gains = mixer.gains.';

