function varargout=amtload(model,data,variable)
%AMTLOAD Load auxiliary data of a model
%   Usage: amtload(MODEL, DATA);
%
%   AMTLOAD loads the auxiliary data from the file data. The data will loaded 
%   from the directory model located in the auxdata directory given by
%   amtauxdatapath. 
%
%   If the file is not in the auxdata directory, it will be downloaded from
%   the web address given by amtauxdataurl
%
%   The following file types are supported:
%     .wav: output will be as that from audioread
%     .mat: output as that as from load
%     others: output is the absolute filename
%
%
%   See also: amtauxdatapath amtauxdataurl
%
%
%   Url: http://amtoolbox.sourceforge.net/doc/amtload.php

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

  
%   Author: Piotr Majdak, 2015

localfn=fullfile(amtauxdatapath,model,data);
  % file not found? create directories, and download!
if ~exist(localfn,'file')
    % create dir if not existing
  if ~exist(fullfile(amtauxdatapath,model),'dir'), 
    [success,msg]=mkdir(fullfile(amtauxdatapath,model));
    if success~=1
      error(msg);
    end
  end
    % download
  amtdisp(['Model: ' model '. Downloading auxiliary data: ' data],'progress');
  webfn=[amtauxdataurl '/' model '/' data];
  webfn(strfind(webfn,'\'))='/';
  webfn=regexprep(webfn,' ','%20');        
  [~,stat]=urlwrite(webfn,localfn);
  if ~stat
    error(['Unable to download file: ' webfn]);
  end
end
  % load the content
[~,~,ext] = fileparts(localfn);
switch lower(ext)
  case '.wav'
    [y,fs]=audioread(localfn);
    varargout{1}=y;
    varargout{2}=fs;
  case '.mat'
    if exist('variable','var'),
        varargout{1}=load(localfn,variable);
    else
        varargout{1}=load(localfn);
    end
  otherwise
    varargout{1}=localfn;
end
