function output = exp_wierstorf2013(varargin)
%EXP_WIERSTORF2013 Figures from Wierstorf (2013)
%   Usage: output = exp_wierstorf2013(flag)
%
%   EXP_WIERSTORF2013(flag) reproduces the results for the figure given
%   by flag from the Wierstorf (2013) paper. It will also plot the
%   results.  The format of its output depends on the chosen figure.
%   Note that the original figures in the paper are not plotted with Matlab, but
%   with gnuplot and may look a little bit different.
%
%   The Sound-Field-Synthesis Toolbox is required.
%   
%   The following flags can be specified;
%
%     'plot'     plot the output of the experiment. This is the default.
%
%     'noplot'   Don't plot, only return data.
%
%     'auto'     Re-calculate the file if it does not exist. Return 1 if the
%                file exist, otherwise 0. This is the default
%
%     'refresh'  Always recalculate the file.
%
%     'cached'   Always use the cached version. Throws an error if the
%                file does not exist.
%
%     'fig1'     Reproduce Fig.1 from Wierstorf (2013). The localization error
%                for a typical stereophony setup is calculated and shown for the
%                whole listening are, sampled with 21x21 point.
%
%     'fig3'     Simulations of the sound field for Wave Field Synthesis for
%                a mono-frequent virtual plane wave with three different
%                frequencies of 1kHz, 2kHz, 5kHz. In addition a spatio-temporal
%                impulse response of the sound field for a broadband plane wave
%                is shown at the time 4.8ms after its start.
%
%     'fig6'     Results from an experiment comparing the localization accuracy
%                for a real point source (loudspeaker) and a simulated point
%                source (binaural synthesis).
%
%     'fig7'     Results from a localization experiment for a virtual point
%                source in Wave Field Synthesis for different positions in the
%                listening area (data are the same as in Fig.10). The line is
%                always starting from a listener position and points towards the
%                direction the listener perceived the auditory event.
%
%     'fig8'     Mapping of ITD values in the first twelve frequency channels to
%                the corresponding azimuth angles in the range -90deg to 90deg.
%                The ITD values are calculated from an HRTF data base with the
%                binaural model after Dietz.
%
%     'fig9'     Deviation of the predicted sound source location with the
%                mapping function from Fig.8 for the same HRTF data set as in
%                Fig.8.
%
%     'fig10'    Results from a localization experiment for a virtual point
%                source in Wave Field Synthesis for different positions in the
%                listening area (data points are the same as in Fig.6). The
%                signals were simulated by binaural synthesis and given also to
%                the Dietz binaural model to predict the localization. The model
%                results are shown as lines. Three different loudspeaker array
%                setups were used.
%
%     'fig11a'   Prediction of the localization for a virtual point source in
%                Wave Field Synthesis in the whole listening area for a linear
%                loudspeaker array.
%
%     'fig11b'   Prediction of the localization for a virtual plane wave in Wave
%                Field Synthesis in the whole listening area for a linear
%                loudspeaker array.
%
%     'fig12a'   Prediction of the localization for a virtual point source in
%                Wave Field Synthesis in the whole listening area for a circular
%                loudspeaker array.
%
%     'fig12b'   Prediction of the localization for a virtual plane wave in Wave
%                Field Synthesis in the whole listening area for a circular
%                loudspeaker array.
%
%   If no flag is given, the function will print the list of valid flags.
%
%   Examples:
%   ---------
%
%   To display Figure 1 use :
%
%     exp_wierstorf2013('fig1');
%
%   To display Figure 3 use :
%
%     exp_wierstorf2013('fig3');
%
%   To display Figure 6 use :
%
%     exp_wierstorf2013('fig6');
%
%   To display Figure 7 use :
%
%     exp_wierstorf2013('fig7');
%
%   To display Figure 8 use :
%
%     exp_wierstorf2013('fig8');
%
%   To display Figure 9 use :
%
%     exp_wierstorf2013('fig9');
%
%   To display Figure 10 use :
%
%     exp_wierstorf2013('fig10');
%
%   To display Figure 11a use :
%
%     exp_wierstorf2013('fig11a');
%
%   To display Figure 11b use :
%
%     exp_wierstorf2013('fig11b');
%
%   To display Figure 12a use :
%
%     exp_wierstorf2013('fig12a');
%
%   To display Figure 12b use :
%
%     exp_wierstorf2013('fig12b');
%
%   References:
%     H. Wierstorf, A. Raake, and S. Spors. Binaural assessment of
%     multi-channel reproduction. In J. Blauert, editor, The technology of
%     binaural listening, chapter 10. Springer, Berlin-Heidelberg-New York
%     NY, 2013.
%     
%
%   Url: http://amtoolbox.sourceforge.net/doc/experiments/exp_wierstorf2013.php

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

%   AUTHOR: Hagen Wierstorf

definput.import={'amtcache'};
definput.flags.type={'missingflag','fig1','fig3','fig6','fig7','fig8', ...
                    'fig9','fig10','fig11a','fig11b','fig12a','fig12b'};

definput.flags.plot={'plot','noplot'};

[flags,keyvals]  = ltfatarghelper({},definput,varargin);

if flags.do_missingflag
  flagnames=[sprintf('%s, ',definput.flags.type{2:end-2}),...
             sprintf('%s or %s',definput.flags.type{end-1},definput.flags.type{end})];
  error('%s: You must specify one of the following flags: %s.',upper(mfilename),flagnames);
end;

% Checking for the Sound-Field-Synthesis Toolbox
if ~which('SFS_start')
    error(['%s: you need to install the Sound-Field-Synthesis Toolbox.\n', ...
        'You can download it at https://github.com/sfstoolbox/sfs.\n', ...
        'You need version 1.0.0 of the Toolbox (commit afe5c14359).'], ...
        upper(mfilename));
end


%% ------ F I G U R E  1 -------------------------------------------------
if flags.do_fig1
      
    % listening area
    X = [-2 2];
    Y = [-3.15 -0.15];
    % orientation of the listener (always to the front)
    phi = pi/2;
    % position of the virtual point source
    xs = [0 0];
    src = 'ps';
    % intra-loudspeaker distance on the stereo setup
    L = 2;
  
	  output = amtcache('get','fig1',flags.cachemode);
    if isempty(output),
        [loc_error,aud_event,~,xaxis,yaxis,x0] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'stereo');
				output.loc_error = loc_error;
				output.aud_event = aud_event;
				output.xaxis = xaxis;
				output.yaxis = yaxis;
				output.x0 = x0;
				amtcache('set','fig1',output);
    end;

    if flags.do_plot
        % ------ Plotting ------
        figure;
        [u,v,~] = pol2cart(rad(output.aud_event+90),ones(size(output.aud_event)), ...
            zeros(size(output.aud_event)));
        quiver(output.xaxis,output.yaxis,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        conf.plot.realloudspeakers = true;
        conf.plot.lssize = 0.16;
        draw_loudspeakers(output.x0,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
    end;

%% ------ F I G U R E  3  ------------------------------------------------
elseif flags.do_fig3

    % listening area
    X = [-2 2];
    Y = [-2 2];
    Z = 0;
    % circular array with 56 loudspeakers
    conf.secondary_sources.geometry = 'circle';
    conf.secondary_sources.size = 3;
    conf.secondary_sources.number = 56;
    conf.secondary_sources.center = [0 0 0];
    conf.secondary_sources.x0 = [];
    conf.xref = [0 0 0];
    % plane wave travelling upwards
    xs = [0 1 0];
    src = 'pw';
    % other neccessary settings
    conf.c = 343;
    conf.fs = 44100;
    conf.showprogress = false;
    conf.debug = 0;
    conf.tmpdir = '/tmp/sfs';
    conf.resolution = 300;
    conf.phase = 0;
    conf.N = 1024;
    conf.usenormalisation = true;
    conf.usebandpass = false;
    conf.bandpassflow = 0;
    conf.bandpassfhigh = 20000;
    conf.dimension = '2.5D';
    conf.driving_functions = 'default';
    conf.usetapwin = true;
    conf.tapwinlen = 0.3;
    conf.wfs.usehpre = false;
    conf.usefracdelay = false;
    conf.plot.useplot = false;
    conf.plot.usegnuplot = false;
    conf.plot.usedb = false;
    conf.plot.colormap = 'gray';
    conf.plot.loudspeakers = true;
    conf.plot.realloudspeakers = true;
    conf.plot.lssize = 0.16; % m
    conf.plot.cmd = '';
    conf.plot.mode = 'monitor';
    conf.plot.size = [540 404];
    conf.plot.size_unit = 'px';
    conf.plot.caxis = '';
    conf.plot.usefile = false;
    conf.plot.file = '';

  
    output = amtcache('get','fig3',flags.cachemode); 
    if isempty(output)
        % get secondary sources and tapering window for plotting
        x0 = secondary_source_positions(conf);
        % disable inactive loudspeakers for plot
        x0(:,7) = [zeros(1,29) ones(1,27)];
        % (a)
        f = 1000;
        [P_a,xaxis,yaxis,zaxis] = sound_field_mono_wfs(X,Y,Z,xs,src,f,conf);
        % (b)
        f = 2000;
        P_b = sound_field_mono_wfs(X,Y,Z,xs,src,f,conf);
        % (c)
        f = 5000;
        P_c = sound_field_mono_wfs(X,Y,Z,xs,src,f,conf);
        % (d)
        t = 212;
        P_d = sound_field_imp_wfs(X,Y,Z,xs,src,t,conf);
				
				output.P_a = P_a;
				output.P_b = P_b;
				output.P_c = P_c;
				output.P_d = P_d;
				output.xaxis = xaxis;
				output.yaxis = yaxis;
				output.zaxis = zaxis;
				output.x0 = x0;

        amtcache('set','fig3',output);
    end;

    if flags.do_plot
        % ------ Plotting ------
        % (a)
        plot_sound_field(-output.P_a,output.xaxis,output.yaxis,output.zaxis,output.x0,conf);
        axis([X(1) X(2) Y(1) Y(2)]);
        colorbar;
        xlabel('x/m');
        ylabel('y/m');
        title('(a) f_{pw} = 1kHz');
        % (b)
        plot_sound_field(-output.P_b,output.xaxis,output.yaxis,output.zaxis,output.x0,conf);
        axis([X(1) X(2) Y(1) Y(2)]);
        colorbar;
        xlabel('x/m');
        ylabel('y/m');
        title('(b) f_{pw} = 2kHz');
        % (c)
        plot_sound_field(-output.P_c,output.xaxis,output.yaxis,output.zaxis,output.x0,conf);
        axis([X(1) X(2) Y(1) Y(2)]);
        colorbar;
        xlabel('x/m');
        ylabel('y/m');
        title('(c) f_{pw} = 5kHz');
        % (d)
        conf.plot.usedb = 1;
        plot_sound_field(output.P_d,output.xaxis,output.yaxis,output.zaxis,output.x0,conf);
        axis([X(1) X(2) Y(1) Y(2)]);
        colorbar;
        xlabel('x/m');
        ylabel('y/m');
        title('(d) t_{pw} = 4.8ms');
    end


%% ------ F I G U R E  6 -------------------------------------------------
elseif flags.do_fig6

    if flags.do_plot
        [data,description] = data_wierstorf2013('fig6','plot');
    else
        [data,description] = data_wierstorf2013('fig6','noplot');
    end
    output.data = data;
    output.description = description;


%% ------ F I G U R E  7 -------------------------------------------------
elseif flags.do_fig7

    [data,description] = data_wierstorf2013('fig7','noplot');
    output.data = data;
    output.description = description;
    if flags.do_plot
        conf.secondary_sources.geometry = 'linear';
        conf.secondary_sources.size = 2.85;
        conf.secondary_sources.center = [0 0 0];
        conf.secondary_sources.x0 = [];
        conf.plot.realloudspeakers = true;
        conf.plot.lssize = 0.16;
        figure;
        subplot(1,3,1);
        conf.secondary_sources.number = 3;
        quiver(data(:,1),data(:,2),data(:,3),data(:,4),25,'.b');
        hold on;
        draw_loudspeakers(secondary_source_positions(conf),conf);
        hold on;
        plot(0,1,'*r');
        hold off;
        title(description{3,1});
        axis([-2.13 1.63 -2.2 1.2]);
        xlabel('x/m');
        ylabel('y/m');
        subplot(1,3,2);
        conf.secondary_sources.number = 8;
        quiver(data(:,1),data(:,2),data(:,5),data(:,6),25,'.b');
        hold on;
        draw_loudspeakers(secondary_source_positions(conf),conf);
        hold on;
        plot(0,1,'*r');
        hold off;
        title(description{5,1});
        axis([-2.13 1.63 -2.2 1.2]);
        xlabel('x/m');
        ylabel('y/m');
        subplot(1,3,3);
        conf.secondary_sources.number = 15;
        quiver(data(:,1),data(:,2),data(:,7),data(:,8),25,'.b');
        hold on;
        draw_loudspeakers(secondary_source_positions(conf),conf);
        hold on;
        plot(0,1,'*r');
        hold off;
        title(description{7,1});
        axis([-2.13 1.63 -2.2 1.2]);
        xlabel('x/m');
        ylabel('y/m');
    end


%% ------ F I G U R E  8 -------------------------------------------------
elseif flags.do_fig8

    [phi,itd] = amtcache('get','fig8', flags.cachemode);
    if isempty(phi)
        % Sound Field Synthesis Toolbox settings
        conf.ir.useinterpolation = true;
        conf.fs = 44100;
        % load HRTFs, see:
        % https://dev.qu.tu-berlin.de/projects/measurements/wiki/2010-11-kemar-anechoic
        irs=amtload('wierstorf2013','QU_KEMAR_anechoic_3m.mat');
        irs=irs.irs;
        % generate noise signal
        sig_noise = noise(44100/5,1,'white');
        % get only the -90 to 90 degree part of the hrtf set
        idx = (( irs.apparent_azimuth>-pi/2 & irs.apparent_azimuth<pi/2 & ...
            irs.apparent_elevation==0 ));
        irs = slice_irs(irs,idx);
        for ii=1:length(irs.apparent_azimuth)
            % generate noise coming from the given direction
            ir = get_ir(irs,[irs.apparent_azimuth(ii) 0 irs.distance],'spherical',conf);
            sig = auralize_ir(ir,sig_noise,1,conf);
            % calculate binaural parameters
            [fine,cfreqs,ild_tmp] = dietz2011(sig,44100,'fhigh',1400);
            % unwrap ITD
            itd_tmp = dietz2011unwrapitd(fine.itd,ild_tmp,fine.f_inst,2.5);
            % calculate the mean about time of the binaural parameters and store
            % them
            itd(ii,:) = median(itd_tmp,1);
            phi(ii) = deg(irs.apparent_azimuth(ii));
        end
        amtcache('set', 'fig8', phi,itd);
    end;

    output.phi = phi;
    output.itd = itd;

    if flags.do_plot
        % ------ Plotting ------
        figure;
        plot(phi,itd.*1000);
        axis([-90 0 0 0.9])
        xlabel('phi_{sound event}/deg');
        ylabel('interaural time difference/ms');
    end;

end;


%% ------ F I G U R E  9 -------------------------------------------------
if flags.do_fig9

    [phi_auditory_event,phi_sound_event] = amtcache('get', 'fig9', flags.cachemode);      
    if isempty(phi_auditory_event)
        % Sound Field Synthesis Toolbox settings
        conf.ir.useinterpolation = true;
        conf.fs = 44100;
        % load lookup table
        lookup = data_wierstorf2013('itd2anglelookuptable');
        % load HRTFs, see:
        irs=amtload('wierstorf2013','QU_KEMAR_anechoic_3m.mat');
        irs=irs.irs;
        % generate noise signal
        sig_noise = noise(44100/5,1,'white');
        % get only the -90 to 90 degree part of the hrtf set
        idx = (( irs.apparent_azimuth>-pi/2 & irs.apparent_azimuth<pi/2 & ...
            irs.apparent_elevation==0 ));
        irs = slice_irs(irs,idx);
        for ii=1:length(irs.apparent_azimuth)
            % generate noise coming from the given direction
            ir = get_ir(irs,[irs.apparent_azimuth(ii) 0 irs.distance], ...
                'spherical',conf);
            sig = auralize_ir(ir,sig_noise,1,conf);
            phi_auditory_event(ii) = wierstorf2013estimateazimuth(sig,lookup,'dietz2011');
            phi_sound_event(ii) = deg(irs.apparent_azimuth(ii));
        end
        amtcache('set', 'fig9', phi_auditory_event,phi_sound_event);
    end;

    output.phi_auditory_event = phi_auditory_event;
    output.phi_sound_event = phi_sound_event;

    if flags.do_plot
        % ------ Plotting ------
        figure;
        plot(phi_sound_event,phi_auditory_event-phi_sound_event);
        axis([-90 90 -3 3])
        xlabel('phi_{sound event}/deg');
        ylabel('phi_{auditory event}-phi_{sound event}/deg');
    end;
end


%% ------ F I G U R E  10 ------------------------------------------------
if flags.do_fig10

    % orientation of the listener (always to the front)
    phi = pi/2;
    % position of the virtual point source
    xs = [0 1];
    src = 'ps';
    % array size
    L = 2.85;

    % Y=1.5m
    X = -1.75:0.25:0;
    Y1 = -1.5;
    Y2 = -2.0;

    output = amtcache('get', 'fig10', flags.cachemode);
    if isempty(output)
        for ii=1:length(X)
            amtdisp([num2str(ii) ' of ' num2str(length(X))],'progress');
            for jj=1:5
                model_3_Y1(ii,jj) = wierstorf2013(X(ii),Y1,phi,xs,src,L,'wfs', ...
                                                  'resolution',1, ...
                                                  'nls',3, ...
                                                  'array','linear', ...
                                                  'showprogress',0);
                model_3_Y2(ii,jj) = wierstorf2013(X(ii),Y2,phi,xs,src,L,'wfs', ...
                                                  'resolution',1, ...
                                                  'nls',3, ...
                                                  'array','linear', ...
                                                  'showprogress',0);
                model_8_Y1(ii,jj) = wierstorf2013(X(ii),Y1,phi,xs,src,L,'wfs', ...
                                                  'resolution',1, ...
                                                  'nls',8, ...
                                                  'array','linear', ...
                                                  'showprogress',0);
                model_8_Y2(ii,jj) = wierstorf2013(X(ii),Y2,phi,xs,src,L,'wfs', ...
                                                  'resolution',1, ...
                                                  'nls',8, ...
                                                  'array','linear', ...
                                                  'showprogress',0);
                model_15_Y1(ii,jj) = wierstorf2013(X(ii),Y1,phi,xs,src,L,'wfs', ...
                                                   'resolution',1, ...
                                                   'nls',15, ...
                                                   'array','linear', ...
                                                   'showprogress',0);
                model_15_Y2(ii,jj) = wierstorf2013(X(ii),Y2,phi,xs,src,L,'wfs', ...
                                                   'resolution',1, ...
                                                   'nls',15, ...
                                                   'array','linear', ...
                                                   'showprogress',0);
            end
        end
				output.model_3_Y1 = model_3_Y1;
				output.model_3_Y2 = model_3_Y2;
				output.model_8_Y1 = model_8_Y1;
				output.model_8_Y2 = model_8_Y2;
				output.model_15_Y1 = model_15_Y1;
				output.model_15_Y2 = model_15_Y2;
        amtcache('set', 'fig10', output);
    end

    % get the human data
    [data,description] = data_wierstorf2013('fig10','noplot');
    
    output.data = data;
    output.description = description;

    if flags.do_plot

        figure; 
        subplot(3,1,1)
        errorbar(data(:,1)-0.025,data(:,2),data(:,3),'ob'); hold on;
        errorbar(data(:,1)+0.025,data(:,8),data(:,9),'or');
        plot(data(:,1),mean(output.model_3_Y1,2),'-b');
        plot(data(:,1),mean(output.model_3_Y2,2),'-r');
        axis([-1.85 0.125 -16 7]);
        legend(description{2,1},description{8,1});
        title(description{2,2});
        xlabel(description{1,3});
        ylabel(description{2,3});
        subplot(3,1,2)
        errorbar(data(:,1)-0.025,data(:,4),data(:,5),'ob'); hold on;
        errorbar(data(:,1)+0.025,data(:,10),data(:,11),'or');
        plot(data(:,1),mean(output.model_8_Y1,2),'-b');
        plot(data(:,1),mean(output.model_8_Y2,2),'-r');
        axis([-1.85 0.125 -16 7]);
        legend(description{4,1},description{10,1});
        title(description{4,2});
        xlabel(description{1,3});
        ylabel(description{2,3});
        subplot(3,1,3)
        errorbar(data(:,1)-0.025,data(:,6),data(:,7),'ob'); hold on;
        errorbar(data(:,1)+0.025,data(:,12),data(:,13),'or');
        plot(data(:,1),mean(output.model_15_Y1,2),'-b');
        plot(data(:,1),mean(output.model_15_Y2,2),'-r');
        axis([-1.85 0.125 -16 7]);
        legend(description{6,1},description{12,1});
        title(description{6,2});
        xlabel(description{1,3});
        ylabel(description{2,3});

    end
end


%% ------ F I G U R E  11a -----------------------------------------------
if flags.do_fig11a

    % listening area
    X = [-2 2];
    Y = [-3.15 -0.15];
    % orientation of the listener (always to the front)
    phi = pi/2;
    % position of the virtual point source
    xs = [0 1];
    src = 'ps';
    % array size
    L = 2.85;
  
    output = amtcache('get', 'fig11a', flags.cachemode);      
    if isempty(output)
        amtdisp('Warning: this will take a long time!','progress');
        % 3 speakers
        amtdisp('Calculating figure 1/6','progress');
        [~,aud_event_3,~,xaxis_31,yaxis_31,x0_3] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                          'resolution',31, ...
                          'nls',3, ...
                          'array','linear');
        amtdisp('Calculating figure 2/6','progress');
        [loc_error_3,~,~,xaxis_135,yaxis_135] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',3, ...
                'array','linear');
        % 8 speakers
        amtdisp('Calculating figure 3/6','progress');
        [~,aud_event_8,~,~,~,x0_8] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',31, ...
                'nls',8, ...
                'array','linear');
        amtdisp('Calculating figure 4/6','progress');
        loc_error_8 = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',8, ...
                'array','linear');
        % 15 speakers
        amtdisp('Calculating figure 5/6','progress');
        [~,aud_event_15,~,~,~,x0_15] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',31, ...
                'nls',15, ...
                'array','linear');
        amtdisp('Calculating figure 6/6','progress');
        loc_error_15 = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',15, ...
                'array','linear');
								
				output.loc_error_3 = loc_error_3;
				output.loc_error_8 = loc_error_8;
				output.loc_error_15 = loc_error_15;
				output.aud_event_3 = aud_event_3;
				output.aud_event_8 = aud_event_8;
				output.aud_event_15 = aud_event_15;
				output.x0_3 = x0_3;
				output.x0_8 = x0_8;
				output.x0_15 = x0_15;
				output.xaxis_31 = xaxis_31;
				output.yaxis_31 = yaxis_31;
				output.xaxis_135 = xaxis_135;
				output.yaxis_135 = yaxis_135;

        amtcache('set', 'fig11a', output);
    end;

    if flags.do_plot
        % ------ Plotting ------
        conf.plot.realloudspeakers = true;
        conf.plot.lssize = 0.16;
        figure;
        subplot(2,3,1);
        [u,v,~] = pol2cart(rad(output.aud_event_3+90),ones(size(output.aud_event_3)), ...
            zeros(size(output.aud_event_3)));
        quiver(output.xaxis_31,output.yaxis_31,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_3,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,2);
        [u,v,~] = pol2cart(rad(output.aud_event_8+90),ones(size(output.aud_event_8)), ...
            zeros(size(output.aud_event_8)));
        quiver(output.xaxis_31,output.yaxis_31,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_8,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,3);
        [u,v,~] = pol2cart(rad(output.aud_event_15+90),ones(size(output.aud_event_15)), ...
            zeros(size(output.aud_event_15)));
        quiver(output.xaxis_31,output.yaxis_31,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_15,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,4)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_3'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_3,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,5)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_8'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_8,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,6)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_15'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_15,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
    end;
end

%% ------ F I G U R E  11b -----------------------------------------------
if flags.do_fig11b
      
    % listening area
    X = [-2 2];
    Y = [-3.15 -0.15];
    % orientation of the listener (always to the front)
    phi = pi/2;
    % position of the virtual point source
    xs = [0 -1];
    src = 'pw';
    % array size
    L = 2.85;
  
    output = amtcache('get', 'fig11b', flags.cachemode);
    if isempty(output)
        amtdisp('Warning: this will take a long time!','progress');
        % 3 speakers
        amtdisp('Calculating figure 1/6','progress');
        [~,aud_event_3,~,xaxis_31,yaxis_31,x0_3] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                          'resolution',31, ...
                          'nls',3, ...
                          'array','linear');
        amtdisp('Calculating figure 2/6','progress');
        [loc_error_3,~,~,xaxis_135,yaxis_135] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',3, ...
                'array','linear');
        % 8 speakers
        amtdisp('Calculating figure 3/6','progress');
        [~,aud_event_8,~,~,~,x0_8] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',31, ...
                'nls',8, ...
                'array','linear');
        amtdisp('Calculating figure 4/6','progress');
        loc_error_8 = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',8, ...
                'array','linear');
        % 15 speakers
        amtdisp('Calculating figure 5/6','progress');
        [~,aud_event_15,~,~,~,x0_15] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',31, ...
                'nls',15, ...
                'array','linear');
        amtdisp('Calculating figure 6/6','progress');
        loc_error_15 = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',15, ...
                'array','linear');

				output.loc_error_3 = loc_error_3;
				output.loc_error_8 = loc_error_8;
				output.loc_error_15 = loc_error_15;
				output.aud_event_3 = aud_event_3;
				output.aud_event_8 = aud_event_8;
				output.aud_event_15 = aud_event_15;
				output.x0_3 = x0_3;
				output.x0_8 = x0_8;
				output.x0_15 = x0_15;
				output.xaxis_31 = xaxis_31;
				output.yaxis_31 = yaxis_31;
				output.xaxis_135 = xaxis_135;
				output.yaxis_135 = yaxis_135;
				
				amtcache('set', 'fig11b', output);
    end;

    if flags.do_plot
        % ------ Plotting ------
        conf.plot.realloudspeakers = true;
        conf.plot.lssize = 0.16;
        figure;
        subplot(2,3,1);
        [u,v,~] = pol2cart(rad(output.aud_event_3+90),ones(size(output.aud_event_3)), ...
            zeros(size(output.aud_event_3)));
        quiver(output.xaxis_31,output.yaxis_31,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_3,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,2);
        [u,v,~] = pol2cart(rad(output.aud_event_8+90),ones(size(output.aud_event_8)), ...
            zeros(size(output.aud_event_8)));
        quiver(output.xaxis_31,output.yaxis_31,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_8,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,3);
        [u,v,~] = pol2cart(rad(output.aud_event_15+90),ones(size(output.aud_event_15)), ...
            zeros(size(output.aud_event_15)));
        quiver(output.xaxis_31,output.yaxis_31,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_15,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,4)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_3'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_3,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,5)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_8'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_8,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,6)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_15'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_15,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
    end;
end

%% ------ F I G U R E  12a -----------------------------------------------
if flags.do_fig12a

    % listening area
    X = [-2.1 2.1];
    Y = [-2.1 2.1];
    % orientation of the listener (always to the front)
    phi = pi/2;
    % position of the virtual point source
    xs = [0 2.5];
    src = 'ps';
    % array size
    L = 3;
  
    output = amtcache('get', 'fig12a', flags.cachemode);      
    if isempty(output)
        amtdisp('\nWarning: this will take a long time!\n\n','progress');
        % 14 speakers
        amtdisp('Calculating figure 1/6','progress');
        [~,aud_event_14,~,xaxis_21,yaxis_21,x0_14] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',21, ...
                'nls',14, ...
                'array','circle');
        amtdisp('Calculating figure 2/6','progress');
        [loc_error_14,~,~,xaxis_135,yaxis_135] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',14, ...
                'array','circle');
        % 28 speakers
        amtdisp('Calculating figure 3/6','progress');
        [~,aud_event_28,~,~,~,x0_28] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',21, ...
                'nls',28, ...
                'array','circle');
        amtdisp('Calculating figure 4/6','progress');
        loc_error_28 = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',28, ...
                'array','circle');
        % 56 speakers
        amtdisp('Calculating figure 5/6','progress');
        [~,aud_event_56,~,~,~,x0_56] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',21, ...
                'nls',56, ...
                'array','circle');
        amtdisp('Calculating figure 6/6','progress');
        loc_error_56 = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',56, ...
                'array','circle');

				output.loc_error_14 = loc_error_14;
				output.loc_error_28 = loc_error_28;
				output.loc_error_56 = loc_error_56;
				output.aud_event_14 = aud_event_14;
				output.aud_event_28 = aud_event_28;
				output.aud_event_56 = aud_event_56;
				output.x0_14 = x0_14;
				output.x0_28 = x0_28;
				output.x0_56 = x0_56;
				output.xaxis_21 = xaxis_21;
				output.yaxis_21 = yaxis_21;
				output.xaxis_135 = xaxis_135;
				output.yaxis_135 = yaxis_135;

				amtcache('set', 'fig12a', output);
    end;

    if flags.do_plot
        % ------ Plotting ------
        conf.plot.realloudspeakers = true;
        conf.plot.lssize = 0.16;
        figure;
        subplot(2,3,1);
        [u,v,~] = pol2cart(rad(output.aud_event_14+90),ones(size(output.aud_event_14)), ...
            zeros(size(output.aud_event_14)));
        quiver(output.xaxis_21,output.yaxis_21,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_14,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,2);
        [u,v,~] = pol2cart(rad(output.aud_event_28+90),ones(size(output.aud_event_28)), ...
            zeros(size(output.aud_event_28)));
        quiver(output.xaxis_21,output.yaxis_21,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_28,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,3);
        [u,v,~] = pol2cart(rad(output.aud_event_56+90),ones(size(output.aud_event_56)), ...
            zeros(size(output.aud_event_56)));
        quiver(output.xaxis_21,output.yaxis_21,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_56,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,4)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_14'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_14,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,5)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_28'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_28,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,6)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_56'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_56,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
    end;
end

%% ------ F I G U R E  12b -----------------------------------------------
if flags.do_fig12b

    % listening area
    X = [-2.1 2.1];
    Y = [-2.1 2.1];
    % orientation of the listener (always to the front)
    phi = pi/2;
    % position of the virtual point source
    xs = [0 -1];
    src = 'pw';
    % array size
    L = 3;
  
    output = amtcache('get', 'fig12b', flags.cachemode);      
    if isempty(output)
        amtdisp('Warning: this will take a long time!','progress');
        % 14 speakers
        amtdisp('Calculating figure 1/6','progress');
        [~,aud_event_14,~,xaxis_21,yaxis_21,x0_14] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',21, ...
                'nls',14, ...
                'array','circle');
        amtdisp('Calculating figure 2/6','progress');
        [loc_error_14,~,~,xaxis_135,yaxis_135] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',14, ...
                'array','circle');
        % 28 speakers
        amtdisp('Calculating figure 3/6','progress');
        [~,aud_event_28,~,~,~,x0_28] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',21, ...
                'nls',28, ...
                'array','circle');
        amtdisp('Calculating figure 4/6','progress');
        loc_error_28 = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',28, ...
                'array','circle');
        % 56 speakers
        amtdisp('Calculating figure 5/6','progress');
        [~,aud_event_56,~,~,~,x0_56] = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',21, ...
                'nls',56, ...
                'array','circle');
        amtdisp('Calculating figure 6/6','progress');
        loc_error_56 = ...
            wierstorf2013(X,Y,phi,xs,src,L,'wfs', ...
                'resolution',135, ...
                'nls',56, ...
                'array','circle');

				output.loc_error_14 = loc_error_14;
				output.loc_error_28 = loc_error_28;
				output.loc_error_56 = loc_error_56;
				output.aud_event_14 = aud_event_14;
				output.aud_event_28 = aud_event_28;
				output.aud_event_56 = aud_event_56;
				output.x0_14 = x0_14;
				output.x0_28 = x0_28;
				output.x0_56 = x0_56;
				output.xaxis_21 = xaxis_21;
				output.yaxis_21 = yaxis_21;
				output.xaxis_135 = xaxis_135;
				output.yaxis_135 = yaxis_135;

				amtcache('set', 'fig12b', output);
    end;

    if flags.do_plot
        % ------ Plotting ------
        conf.plot.realloudspeakers = true;
        conf.plot.lssize = 0.16;
        figure;
        subplot(2,3,1);
        [u,v,~] = pol2cart(rad(output.aud_event_14+90),ones(size(output.aud_event_14)), ...
            zeros(size(output.aud_event_14)));
        quiver(output.xaxis_21,output.yaxis_21,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_14,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,2);
        [u,v,~] = pol2cart(rad(output.aud_event_28+90),ones(size(output.aud_event_28)), ...
            zeros(size(output.aud_event_28)));
        quiver(output.xaxis_21,output.yaxis_21,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_28,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,3);
        [u,v,~] = pol2cart(rad(output.aud_event_56+90),ones(size(output.aud_event_56)), ...
            zeros(size(output.aud_event_56)));
        quiver(output.xaxis_21,output.yaxis_21,u',v',0.5);
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_56,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,4)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_14'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_14,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,5)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_28'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_28,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
        subplot(2,3,6)
        imagesc(output.xaxis_135,output.yaxis_135,abs(output.loc_error_56'));
        turn_imagesc;
        axis([-2.13 2.13 -3.3 0.2])
        draw_loudspeakers(output.x0_56,[1 1 0],conf);
        xlabel('x/m');
        ylabel('y/m');
    end;
end

