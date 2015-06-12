% AN model - [Zilany, Bruce, Ibrahim and Carney] Auditory Nerve Model
%
%     vihc = model_IHC(pin,CF,nrep,tdres,reptime,cohc,cihc,species);
%     [meanrate,varrate,psth] = model_Synapse(vihc,CF,nrep,tdres,fiberType,noiseType,implnt);
%
% vihc is the inner hair cell (IHC) potential (in volts)
% meanrate is the estimated instantaneous mean rate (incl. refractoriness)
% varrate is the estimated instantaneous variance in the discharge rate (incl. refractoriness)
% psth is the peri-stimulus time histogram 
%
% pin is the input sound wave in Pa sampled at the appropriate sampling rate (see instructions below)
% CF is the characteristic frequency of the fiber in Hz
% nrep is the number of repetitions for the mean rate, rate variance & psth calculation
% tdres is the binsize in seconds, i.e., the reciprocal of the sampling rate (see instructions below)
% reptime is the time between stimulus repetitions in seconds - NOTE should be equal to or longer than the duration of pin
% cohc is the OHC scaling factor: 1 is normal OHC function; 0 is complete OHC dysfunction
% cihc is the IHC scaling factor: 1 is normal IHC function; 0 is complete IHC dysfunction
% species is either "cat" (1) or "human" (2): "1" for cat and "2" for human
% fiberType is the type of the fiber based on spontaneous rate (SR) in spikes/s - "1" for Low SR; "2" for Medium SR; "3" for High SR
% noiseType is for fixed fGn (noise will be same in every simulation) or variable fGn: "0" for fixed fGn and "1" for variable fGn
% implnt is for "approxiate" or "actual" implementation of the power-law functions: "0" for approx. and "1" for actual implementation
% 
%
% For example,
%
%    vihc = model_IHC(pin,1e3,10,1/100e3,0.200,1,1,1); *requires 8 input arguments
%    [meanrate,varrate,psth] = model_Synapse(vihc,1e3,10,1/100e3,3,0,0); *requires 7 input arguments
%
% models a normal fiber of high spontaneous rate (normal OHC & IHC function) with a CF of 1 kHz, 
% for 10 repititions and a sampling rate of 100 kHz, for a repetition duration of 200 ms, 
% with a fixed fractional Gaussian noise (fGn) and also with approximate implementation of the power-law 
% functions in the synapse model.
%
%
% NOTE ON SAMPLING RATE:-
% Since version 2 of the code, it is possible to run the model at a range
% of sampling rates between 100 kHz and 500 kHz.
% It is recommended to run the model at 100 kHz for CFs up to 20 kHz, and
%
%   Url: http://amtoolbox.sourceforge.net/doc/src/zilany5/ANmodel.php

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
% at 200 kHz for CFs> 20 kHz to 40 kHz.
