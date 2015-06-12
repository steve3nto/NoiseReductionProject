function [outx,outy]  = data_joergensen2011(varargin)
%DATA_JOERGENSEN2011 XXX
%   Usage:  = data_joergensen2011()
%
%   [outx,outy]=DATA_JOERGENSEN2011('figXXX)
%   returns data points from the Joergensen2011 paper. The flag may be one
%   of:
%
%     'noplot'        Don't plot, only return data. This is the default.
%
%     'plot'          Plot the data.
%
%     'figXXX'        Describe output data.
%
%     'figXXX'        Describe output data.
%
%
%   Examples:
%   ---------
%
%   XXX Please provide a plot here to visualize the relevant figure:
%
%     [ur,fs]  = data_joergensen2011;
%     plot((0:length(ur)-1)/fs,ur);
%     xlabel('Time / seconds');
%     ylabel('Amplitude');
%
%   References:
%     S. Joergensen and T. Dau. Predicting speech intelligibility based on
%     the signal-to-noise envelope power ratio after modulation-frequency
%     selective processing. J. Acoust. Soc. Am., 130(3):1475-1487, 2011.
%     
%
%   Url: http://amtoolbox.sourceforge.net/doc/humandata/data_joergensen2011.php

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
  
definput.flags.plot = {'noplot','plot'};
definput.flags.type = {'figXXX','figYYY'};

[flags,keyvals]  = ltfatarghelper({},definput,varargin);

if flags.do_figXXX
    acrossSubdSRTs = ...
        [0, 1.3750, 1.3750, 1.6250, 1.8750, 2.7083];    
    std_acrossSubSRTs = ...        
        [0.4513, 0.7500, 0.2500, 0.4590, 0.3436, 0.5159];
    
    outx=acrossSubdSRTs;
    outy=std_acrossSubSRTs;
    
    if flags.do_plot
        % Put the visualization of the data here
        
    end;
    
end;

if flags.do_figYYY
    
    % repeat
    
end;


