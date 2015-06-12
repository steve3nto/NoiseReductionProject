%DEMO_ABSOLUTETHRESHOLD  Standards for absolute threshold of hearing
%
%   This demos generates a simple figure that shows the behaviour of
%   the different standards for absolute thresholds of hearing.
%
%   Figure 1: Thresholds of hearing by standard
%
%      The figure shows the behaviour of the different absolute thresholds of
%      hearing.
%
%   Figure 2: High frequencies
%
%      Absolute thesholds for the ER2A and the Sennheiser HDA-200
%      earphones are provided up to 16 kHz.
%
%   See also:  absolutethreshold
%
%   Url: http://amtoolbox.sourceforge.net/doc/demos/demo_absolutethreshold.php

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

amtdisp(['Type "help demo_absolutethreshold" to see a description of how this ', ...
      'demo works.']);


figure(1);

flow=125;
fhigh=8000;
plotpoints=30;

xrange=linspace(flow,fhigh,plotpoints);


types   = {'iso226_2003','map','er3a','er2a','hda200'};
legends = {'THR (free field)','MAP (free-field)','THR (ER-3A)','THR (ER-2A)','THR (HDA 200)'};
symbols = {'r-'         ,'k-' ,'g:'  ,'b-.','y--'  };
lines   = {2            , 1   , 2    , 2   , 2   };
ticks   = [125,250,500,1000,2000,4000,8000];

hold all;
for ii=1:numel(types)
  semiaudplot(xrange,absolutethreshold(xrange,types{ii}),...
		'tick', ticks,...
		'opts',{symbols{ii},'Linewidth',lines{ii}});
end;
legend(legends{:},'Location','North');
xlabel('Frequency (Hz)');
ylabel('Absolte threshold (dB SPL)');
xlim([2 35]);


figure(2);

flow=125;
fhigh=16000;
plotpoints=30;

xrange=linspace(flow,fhigh,plotpoints);
types   = {'er2a','hda200'};
legends = {'er2a','hda200'};
symbols = {'b+','y*'  };

hold all;
for ii=1:numel(types)
  semiaudplot(xrange,absolutethreshold(xrange,types{ii}),...
              'tick', ticks,...
              'opts',{symbols{ii},'Linewidth',lines{ii}});
end;
hold off;
legend(legends{:},'Location','North');
xlabel('Frequency (Hz)');
ylabel('Absolte threshold (dB SPL)');
xlim([2 41]);


types = {'iso226_2003','map','er3a','er2a','hda200'};
symbols = {'k' ,'r--' ,'g' ,'b:','y' };  
fc=125:125:8000; hold on; box on;  
for ii=1:numel(types),  opt={symbols{ii}, 'LineWidth', 3}; 
    semiaudplot(fc,absolutethreshold(fc,types{ii}),'opts',opt);  
end;
legend(types); 
xlabel('Frequency (Hz)');  
ylabel('Absolute hearing threshold (dB re 20 µPa)');
