function auxPath=amtauxdatapath(newPath)
%amtauxdatapath Path of the auxiliary data
%   Usage: auxpath=amtauxdatapath
%          amtauxdatapath(newpath)
%
%   auxPath=AMTAUXDATAPATH returns the path of the directory containing
%   auxiliary data.
%
%   Default path to the auxiliary data is the amtbasepath/auxdata.
% 
%   AMTAUXDATAPATH(newpath) sets the path of the directory for further calls
%   of AMTAUXDATAPATH.
%
%   See also: amtauxdataurl amtload amtbasepath
%
%   Url: http://amtoolbox.sourceforge.net/doc/amtauxdatapath.php

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

% AUTHOR: Piotr Majdak, 2015


persistent CachedPath;

if exist('newPath','var')
  CachedPath=newPath;
elseif isempty(CachedPath)
  CachedPath=fullfile(amtbasepath, 'auxdata');
end
auxPath=CachedPath;

  
