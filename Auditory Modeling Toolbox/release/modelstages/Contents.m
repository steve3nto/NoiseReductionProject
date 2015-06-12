% AMT - Single stages of auditory models
%
%  The AMT team, 2011 - 2014.
%
%  Peripheral stages
%     HEADPHONEFILTER    - FIR filter to model headphones 
%     MIDDLEEARFILTER    - FIR filter to model the middle ear
%     AUDITORYFILTERBANK - Linear auditory filterbank.
%     IHCENVELOPE        - Inner hair cell envelope extration.
%     ADAPTLOOP          - Adaptation loops.
%     KARJALAINEN1996    - Adaptation network.
%     DRNL               - Dual resonance non-linear filterbank.
%     MODFILTERBANK      - Modulation filter bank.
%     MODFILTERBANKEPSM  - Modulation filter bank from Joergensen model.
%
%  Binaural processing stages
%     LANGENDIJK2002COMP     - Comparison process from Langendijk 20002.
%     LINDEMANN1986BINCORR - Running cross-correlation between two signals.
%     EICELL             - Excitation-inhibition cell model by Breebaart.
%     CULLING2005BMLD    - BMLD calculation from Culling et al. (2005).
%     DIETZ2011UNWRAPITD - IPD to ITD transformation for the Dietz model
%     DIETZ2011FILTERBANK - filterbank of Dietz 2011 binaural model
%     DIETZ2011INTERAURALFUNCTIONS - Calculate interaural parameters for Dietz 2011 model
%     WIERSTORF2013ESTIMATEAZIMUTH - Azimuth position estimation based on dietz2011 or lindemann1986
%
%  The Takanen 2013 model   - Takanen 2013 binaural auditory model
%     TAKANEN2013CONTRACOMPARISON - Enhance contrast between hemispheres
%     TAKANEN2013CUECONSISTENCY - Check consistency before cue combination
%     TAKANEN2013DIRECTIONMAPPING - Map the directional cues to directions
%     TAKANEN2013FORMBINAURALACTIVITYMAP - Steer cues on a topographic map
%     TAKANEN2013LSO        - Model of the lateral superior olive
%     TAKANEN2013MSO        - Model of the medial superior olive
%     TAKANEN2013ONSETENHANCEMENT - Emphasize onsets on direction analysis
%     TAKANEN2013PERIPHERY  - Process input through the model of periphery
%     TAKANEN2013WBMSO      - Wideband medial superior olive model
%
%  Sagittal-plane localization models
%     BAUMGARTNER2013PMV2PPP - Calculate psychophysical predictions from PMVs for baumgartner2013
%     BAUMGARTNER2014CALIBRATION - Calibration of the model
%     BAUMGARTNER2014VIRTUALEXP - Performs a virtual sound-localization experiment
%     BAUMGARTNER2014PMV2PPP - Calculate psychophysical predictions from PMVs for baumgartner2014
%     BAUMGARTNER2014LIKELISTAT - Calculate the likelihood statistics
%
%  For help, bug reports, suggestions etc. please send email to
%  amtoolbox-help@lists.sourceforge.net
%
%   Url: http://amtoolbox.sourceforge.net/doc/modelstages/Contents.php

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


