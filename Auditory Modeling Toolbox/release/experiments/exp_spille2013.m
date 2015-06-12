function example_output = exp_spille2013(varargin)
%EXP_SPILLE2013 Experiments from Spille et al 2013. Model: Dietz et al 2011
%
%   EXP_SPILLE2013 reproduce Fig. no. 6 from the Spille et
%   al. 2013 AABBA chapter.
%
%   Examples:
%   ---------
%
%   To display Figure 6 use :
%
%     exp_spille2013('fig6');
%
%   See also: exp_dietz2011
%
%   Url: http://amtoolbox.sourceforge.net/doc/experiments/exp_spille2013.php

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


% AUTHOR: Mathias Dietz

% choose input signal (e.g. spille2013_s123456)
% fn = 'exp_spille2013_s123456.wav';
% targetfn = fullfile(amtbasepath,'signals',fn);
% if not(exist(targetfn,'file'))
%   amtdisp(['Downloading ' fn ' from http://amtoolbox.sourceforge.net/data/signals/']);  
%   sourcefn = ['http://amtoolbox.sourceforge.net/data/signals/' fn];
%   urlwrite(sourcefn,targetfn);
% end
% signal=wavread(targetfn);
signal=amtload('spille2013','s123456.wav');
fs=44100;
s_pos =[-75 -40 -10 10 40 75];

ic_threshold=0.98;
cn = [10 1]; % channel numbers for separate plots (1st entry also for time plot)
panellabel = 'acbd';

% run IPD model on signal
[hairc_fine,fc,hairc_ild]=dietz2011(signal,fs,'fhigh',1400);

% convert interaural information into azimuth
itd_unwrapped = ...
    dietz2011unwrapitd(hairc_fine.itd_lp,hairc_ild,hairc_fine.f_inst_lp,2.5);
lookup = amtload('dietz2011','itd2anglelookuptable.mat');
angl=itd2angle(itd_unwrapped,lookup);

h_ic=zeros(91,12);
h_all=histc(angl,-90:2:90);
for n=1:12
    h_ic(:,n)=histc(angl(hairc_fine.ic(:,n)>ic_threshold&[diff(hairc_fine.ic(:,n))>0; 0],n),-90:2:90);
end

% plot
figure;
fontsize = 14;
set(gcf,'Position',[100 100 1170 700])

for panel = 1:4
    subplot(2,2,panel)
    switch panel
        case 1
            bar(-90:2:90,h_all(:,cn(1)))
            hold on
            bar(-90:2:90,h_ic(:,cn(1)),'r')
            title(['Azimuth histogram of ch. ' num2str(cn(1)) ' at cf = ' ...
                num2str(round(fc(cn(1)))) ' Hz'],'Fontsize',fontsize)
            ymax = max(h_all(:,cn(1)));
        case 2
            bar(-90:2:90,h_all(:,cn(2)))
            hold on
            bar(-90:2:90,h_ic(:,cn(2)),'r')
            title(['Azimuth histogram of ch. ' num2str(cn(2)) ' at cf = ' ...
                num2str(round(fc(cn(2)))) ' Hz'],'Fontsize',fontsize)
            ymax = max(h_all(:,cn(2)));
        case 3
            t=(1:length(signal))*1/fs;
            plot(t,angl(:,cn(1)),'b.');
            hold on;
            plot(t(hairc_fine.ic(:,cn(1))>ic_threshold),...
                angl(hairc_fine.ic(:,cn(1))>ic_threshold,cn(1)),'r.');
            title(['Azimuth over time in ch. ' num2str(cn(1)) ' at cf = ' ...
                num2str(round(fc(cn(1)))) ' Hz'],'Fontsize',fontsize)
        case 4
            bar(-90:2:90,mean(h_all,2))
            hold on
            bar(-90:2:90,mean(h_ic,2),'r')
            title('Mean histogram of all fine-structure channels','Fontsize',fontsize)
            ymax = max(mean(h_all,2));
    end
    set(gca,'Fontsize',fontsize)
    if panel ~= 3
        set(gca,'XTick',s_pos)
        xlim([-93 93])
        ylim([0 ymax*1.1])
        xlabel('Azimuth [deg]','Fontsize',fontsize)
        ylabel('Frequency of occurence','Fontsize',fontsize)
        text (-80,ymax*.95,panellabel(panel),'Fontsize',fontsize+1,'FontWeight','bold')
    else
        set(gca,'YTick',s_pos)
        xlim([0 5.5])
        ylim([-95 95])
        ylabel('Azimuth [deg]','Fontsize',fontsize)
        xlabel('Time [s]','Fontsize',fontsize)
        rectangle('Position',[0.32,60,0.3,21],'FaceColor','white')
        text (0.38,69,panellabel(panel),'Fontsize',fontsize+1,'FontWeight','bold')
    end
end

example_output.angle_fine = angl;
example_output.IVS_fine = hairc_fine.ic;
example_output.histogram_angle_label = -90:2:90;
example_output.histograms_with_IVS = h_ic;
example_output.histograms_without_IVS = h_all;

