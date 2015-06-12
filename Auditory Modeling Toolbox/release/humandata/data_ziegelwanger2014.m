function data = data_ziegelwanger2014(varargin)
%DATA_ZIEGELWANGER2014   Data from Ziegelwanger and Majdak (2014)
%   Usage: data = data_ziegelwanger2014(flag)
%
%   DATA_ZIEGELWANGER2014(flag) returns results for different HRTF
%   databases from Ziegelwanger and Majdak (2014).
%
%   The flag may be one of:
%  
%     'ARI'         ARI database. The output has the following
%                   fields: data.results and data.subjects.
%  
%     'CIPIC'       CIPIC database. The output has the following fields: 
%                   data.results and data.subjects.
%  
%     'LISTEN'      LISTEN database. The output has the following fields.
%                   data.results and data.subjects.
%  
%     'SPHERE_ROT'  HRTF sets for a rigid sphere placed in the center of
%                   the measurement setup and varying rotation. The
%                   output has the following fields: data.results,
%                   data.subjects, data.phi, data.theta and data.radius.
%  
%     'SPHERE_DIS'  HRTF sets for a rigid sphere with various positions in
%                   the measurement setup. The output has the following fields: 
%                   data.results, data.subjects, data.xM, data.yM,
%                   data.zM and data.radius.
%  
%     'Sphere'      HRTF set for a rigid sphere: The
%                   output has the following fields: data.hM,
%                   data.meta and data.stimPar.
%  
%     'SAT'         HRTF set for a rigid sphere combined with a neck and a
%                   torso: The output has the following fields: data.hM,
%                   data.meta and data.stimPar.
%  
%     'STP'         HRTF set for a rigid sphere combined with a neck, a
%                   torso and a pinna: The output has the following fields:
%                   data.hM,data.meta and data.stimPar.
%  
%     'NH89'        HRTF set of listener NH89 of the ARI database: The
%                   output has the following fields: data.hM,
%                   data.meta and data.stimPar.  
%  
%   The fields are given by:
%
%     data.results     Results for all HRTF sets
%
%     data.subjects    IDs for HRTF sets
%
%     data.phi         Azimuth of ear position
%
%     data.theta       Elevation of ear position
%
%     data.radius      sphere radius
%
%     data.xM          x-coordinate of sphere center
%
%     data.yM          y-coordinate of sphere center
%
%     data.zM          z-coordinate of sphere center
%
%     data             SOFA object
% 
%   Requirements: 
%   -------------
%
%   1) SOFA API from http://sourceforge.net/projects/sofacoustics for Matlab (in e.g. thirdparty/SOFA)
% 
%   2) Optimization Toolbox for Matlab
%
%   3) Data in hrtf/ziegelwanger2014
%
%   Examples:
%   ---------
% 
%   To get results from the ARI database, use:
%
%     data=data_ziegelwanger2014('ARI');
%
%   See also: ziegelwanger2014, ziegelwanger2014onaxis,
%   ziegelwanger2014offaxis, exp_ziegelwanger2014
%
%   References:
%     H. Ziegelwanger and P. Majdak. Modeling the direction-continuous
%     time-of-arrival in head-related transfer functions. J. Acoust. Soc.
%     Am., 135:1278-1293, 2014.
%     
%
%   Url: http://amtoolbox.sourceforge.net/doc/humandata/data_ziegelwanger2014.php

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

% AUTHOR: Harald Ziegelwanger, Acoustics Research Institute, Vienna,
% Austria

%% ------ Check input options --------------------------------------------

% Define input flags
definput.flags.type = {'missingflag','ARI','CIPIC','LISTEN','SPHERE_DIS','SPHERE_ROT','NH89','Sphere','SAT','STP'};
definput.import={'amtcache'}; % get the flags of amtcache

% Parse input options
[flags,~]  = ltfatarghelper({},definput,varargin);

if flags.do_missingflag
    flagnames=[sprintf('%s, ',definput.flags.type{2:end-2}),...
        sprintf('%s or %s',definput.flags.type{end-1},definput.flags.type{end})];
    error('%s: You must specify one of the following flags: %s.',upper(mfilename),flagnames);
end

%% ARI database
if flags.do_ARI
    
    tmp=amtload('ziegelwanger2014','info.mat');
    data=tmp.info.ARI;
    results=amtcache('get','ARI',flags.cachemode);
    if isempty(results)
        for ii=1:length(data.subjects)
            amtdisp(['Recalculate data for subject ' num2str(ii) '/' num2str(length(data.subjects)) ' (' data.subjects{ii} ') of ARI database'],'progress');
            Obj=SOFAload(fullfile(SOFAdbPath, 'ziegelwanger2014', [ 'ARI_' data.subjects{ii} '.sofa']));
            [~,tmp]=ziegelwanger2014(Obj,4,0,0);
            toaEst=tmp.toa;
            [~,results(ii).MCM{1}]=ziegelwanger2014(Obj,toaEst,0,1e-8);
            [~,results(ii).MCM{2}]=ziegelwanger2014(Obj,toaEst,[0.05 0.01],1e-8);
        end
        amtcache('set','ARI',results);
    end
    data.results=results;
    
end

%% CIPIC database
if flags.do_CIPIC
    
    tmp=amtload('ziegelwanger2014','info.mat');
    data=tmp.info.CIPIC;
    results=amtcache('get','CIPIC',flags.cachemode);
    if isempty(results)
        for ii=1:length(data.subjects)
            amtdisp(['Recalculate data for subject ' num2str(ii) filesep num2str(length(data.subjects)) ' of CIPIC database'],'progress');
            Obj=SOFAload(fullfile(SOFAdbPath, 'ziegelwanger2014', [ 'CIPIC_' data.subjects{ii} '.sofa']));
            [~,tmp]=ziegelwanger2014(Obj,4,0,0);
            toaEst=tmp.toa;
            [~,results(ii).MCM{1}]=ziegelwanger2014(Obj,toaEst,0,1e-8);
            [~,results(ii).MCM{2}]=ziegelwanger2014(Obj,toaEst,[0.05 0.01],1e-8);
        end
        amtcache('set','CIPIC',results);
    end
    data.results=results;
    
end

%% LISTEN database
if flags.do_LISTEN
    
    tmp=amtload('ziegelwanger2014','info.mat');
    data=tmp.info.LISTEN;
    results=amtcache('get','LISTEN',flags.cachemode);
    if isempty(results)
        for ii=1:length(data.subjects)
            if ~strcmp(data.subjects{ii},'34')
                amtdisp(['Recalculate data for subject ' num2str(ii) filesep num2str(length(data.subjects)) ' of LISTEN database'],'progress');
                Obj=SOFAload(fullfile(SOFAdbPath, 'ziegelwanger2014', [ 'LISTEN_' data.subjects{ii} '.sofa']));
                [~,tmp]=ziegelwanger2014(Obj,4,0,0);
                toaEst=tmp.toa;
                [~,results(ii).MCM{1}]=ziegelwanger2014(Obj,toaEst,0,1e-8);
                [~,results(ii).MCM{2}]=ziegelwanger2014(Obj,toaEst,[0.05 0.01],1e-8);
            end
        end
        amtcache('set','LISTEN',results);
    end
    data.results=results;    
end

%% SPHERE (Displacement) database
if flags.do_SPHERE_DIS
    
    tmp=amtload('ziegelwanger2014','info.mat');
    data=tmp.info.Displacement;
    results=amtcache('get','SPHERE_DIS',flags.cachemode);
    if isempty(results)
        results.p_onaxis=zeros(4,2,length(data.subjects));
        results.p_offaxis=zeros(7,2,length(data.subjects));
        for ii=1:length(data.subjects)
            amtdisp(['Recalculate data for subject ' num2str(ii) filesep num2str(length(data.subjects)) ' of SPHERE_DIS database'],'progress');
            Obj=SOFAload(fullfile(SOFAdbPath, 'ziegelwanger2014', [ 'Sphere_Displacement_' data.subjects{ii} '.sofa']));
            [~,tmp]=ziegelwanger2014(Obj,4,0,0);
            toaEst=tmp.toa;
            [~,results(ii).MCM{1}]=ziegelwanger2014(Obj,toaEst,0,1e-8);
            [~,results(ii).MCM{2}]=ziegelwanger2014(Obj,toaEst,[0.05 0.01],1e-8);
        end
        amtcache('set','SPHERE_DIS',results);
    end
    data.results=results;    
end

%% SPHERE (Rotation) database
if flags.do_SPHERE_ROT
    
    tmp=amtload('ziegelwanger2014','info.mat');
    data=tmp.info.Rotation;
    results=amtcache('get','SPHERE_ROT',flags.cachemode);
    if isempty(results)
        results.p=zeros(4,2,length(data.phi));
        for ii=1:length(data.subjects)
            amtdisp(['Recalculate data for subject ' num2str(ii) filesep num2str(length(data.subjects)) ' of SPHERE_ROT database'],'progress');
            Obj=SOFAload(fullfile(SOFAdbPath, 'ziegelwanger2014', [ 'Sphere_Rotation_' data.subjects{ii} '.sofa']));
            [~,tmp]=ziegelwanger2014(Obj,1,0,0);
            toaEst=tmp.toa;
            [~,results(ii).MAX{1}]=ziegelwanger2014(Obj,toaEst,0,1e-8);
            
            [~,tmp]=ziegelwanger2014(Obj,2,0,0);
            toaEst=tmp.toa;
            [~,results(ii).CTD{1}]=ziegelwanger2014(Obj,toaEst,0,1e-8);
            
            [~,tmp]=ziegelwanger2014(Obj,3,0,0);
            toaEst=tmp.toa;
            [~,results(ii).AGD{1}]=ziegelwanger2014(Obj,toaEst,0,1e-8);
             
            [~,tmp]=ziegelwanger2014(Obj,4,0,0);
            toaEst=tmp.toa;
            [~,results(ii).MCM{1}]=ziegelwanger2014(Obj,toaEst,0,1e-8);
            [~,results(ii).MCM{2}]=ziegelwanger2014(Obj,toaEst,[0.05 0.01],1e-8);
        end
        amtcache('set','SPHERE_ROT',results);
    end
    data.results=results;    
end

%% ARI database (NH89)
if flags.do_NH89

    data=SOFAload(fullfile(SOFAdbPath, 'ziegelwanger2014', 'ARI_NH89.sofa'));
    
    toaEst=amtcache('get','NH89',flags.cachemode);
    if isempty(toaEst)
        [~,tmp]=ziegelwanger2014(data,1,0,0);
        toaEst{1}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,2,0,0);
        toaEst{2}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,3,0,0);
        toaEst{3}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,4,0,0);
        toaEst{4}=tmp.toa;
        amtcache('set','NH89',toaEst);
    end
    data.Data.toaEst=toaEst;
    
end

%% Sphere
if flags.do_Sphere

    data=SOFAload(fullfile(SOFAdbPath, 'ziegelwanger2014', 'Sphere.sofa'));
    
    toaEst=amtcache('get','Sphere',flags.cachemode);
    if isempty(toaEst)
        [~,tmp]=ziegelwanger2014(data,1,0,0);
        toaEst{1}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,2,0,0);
        toaEst{2}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,3,0,0);
        toaEst{3}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,4,0,0);
        toaEst{4}=tmp.toa;
        amtcache('set','Sphere',toaEst);
    end
    data.Data.toaEst=toaEst;
    
end

%% Sphere and Torso
if flags.do_SAT

    data=SOFAload(fullfile(SOFAdbPath, 'ziegelwanger2014', 'SAT.sofa'));
    
    toaEst=amtcache('get','SAT',flags.cachemode);
    if isempty(toaEst)
        [~,tmp]=ziegelwanger2014(data,1,0,0);
        toaEst{1}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,2,0,0);
        toaEst{2}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,3,0,0);
        toaEst{3}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,4,0,0);
        toaEst{4}=tmp.toa;
        amtcache('set','SAT',toaEst);
    end
    data.Data.toaEst=toaEst;
    
end

%% Sphere, Torso and Pinna
if flags.do_STP

    data=SOFAload(fullfile(SOFAdbPath, 'ziegelwanger2014', 'STP.sofa'));
    
    toaEst=amtcache('get','STP',flags.cachemode);
    if isempty(toaEst)
        [~,tmp]=ziegelwanger2014(data,1,0,0);
        toaEst{1}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,2,0,0);
        toaEst{2}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,3,0,0);
        toaEst{3}=tmp.toa;
        [~,tmp]=ziegelwanger2014(data,4,0,0);
        toaEst{4}=tmp.toa;
        amtcache('set','STP',toaEst);
    end
    data.Data.toaEst=toaEst;
    
end
