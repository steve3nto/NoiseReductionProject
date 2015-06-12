%DEMO_HOHMANN2002  Filterbank example
%
%   This example program demonstrates how to create and use an analysis
%   gammatone filterbank.
%   It seems to implement Hohmann (2002).
%
%   See also: exp_gammatone gammatone demo_gammatone exp_hohmann2002 
%   gfb_analyzer_new gfb_analyzer_process
%
%   Url: http://amtoolbox.sourceforge.net/doc/demos/demo_hohmann2002.php

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
% date     : Jan, Mar 2002, Nov 2006

flow = 70;
fhigh = 6700;
base_frequency_hz = 1000;
sampling_rate_hz = 16276;
filters_per_ERB = 1.0;

amtdisp(['Building a filterbank for ', num2str(sampling_rate_hz), ...
      'Hz sampling frequency.']);
amtdisp(['Lower cutoff frequency: ', num2str(flow), 'Hz']);
amtdisp(['Upper cutoff frequency: ', num2str(fhigh), 'Hz']);
amtdisp(['Base frequency        : ', num2str(base_frequency_hz), 'Hz']);
amtdisp(['filters per ERB       : ', num2str(filters_per_ERB)]);
amtdisp(' ')
analyzer = gfb_analyzer_new(sampling_rate_hz, flow, ...
                            base_frequency_hz, fhigh,...
			    filters_per_ERB);
bands = length(analyzer.center_frequencies_hz);
amtdisp(['filterbank contains ', num2str(bands), ' filters:']);

fprintf(1,'%3s|%12s |%15s |%16s\n\n', ...
        '# ', 'f / Hz ', 'normalization', 'coefficient');

%% display filter parameters of the individual filters: %%
for band = 1:bands
  filter = analyzer.filters(band);
  fprintf(1,'%3d|%12f |%15e | %f + %fi\n', ...
	  band, analyzer.center_frequencies_hz(band), ...
	  filter.normalization_factor, ...
	  real(filter.coefficient), imag(filter.coefficient));
end


%%% plot the frequency response of the individual filters: %%%         

impulse = [1, zeros(1,8191)];                                          
[impulse_response, analyzer] = gfb_analyzer_process(analyzer, impulse);
frequency_response = fft(real(impulse_response)');                     
frequency = [0:8191] * sampling_rate_hz / 8192;                        

figure(1);
plot(frequency, 20 * log10(abs(frequency_response)));
axis([0, sampling_rate_hz/2, -40, 0]);
title('frequency response of the individual filters in this filterbank');
xlabel('frequency / Hz');
ylabel('filter response / dB');

amtdisp(' ');
amtdisp('Figure 1 shows the frequency response of the individual filters.');


