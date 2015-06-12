function sig = whitenoiseburst(fs)
% Generate the noise signal used for the binaural model to predict the perceived
% direction
%
%   Url: http://amtoolbox.sourceforge.net/doc/signals/whitenoiseburst.php

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
noise_length = 700;
pause_length = 300;
slope_length = 20;
% calculate samples from ms
noise_samples = round(noise_length/1000*fs);
pause_samples = round(pause_length/1000*fs);
slope_samples = round(slope_length/1000*fs);
% on- and offset slope
win = hann_window(slope_samples,slope_samples,noise_samples);
% bandpass filter
n=4;      % 2nd order butterworth filter
fnq=fs/2;  % Nyquist frequency
wn=[125/fnq 20000/fnq];    % butterworth bandpass non-dimensional frequency
[b,a]=butter(n,wn); % construct the filter
%
pause_sig = zeros(round(pause_samples/2),1);
sig_noise = noise(noise_samples,1,'white') .* win;
sig = [pause_sig; sig_noise; pause_sig];
sig = filtfilt(b,a,sig);
sig = sig(1:end-round(pause_samples/2));

