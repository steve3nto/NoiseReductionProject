function doit=amtredofile(filename,varargin)
%AMTREDOFILE  Determine if file should be redone
%   Usage: doit=amtredofile(filename,mode);
%
%   AMTREDOFILE(file,mode) returns 1 if the file should be redone, based
%   on the setting described in mode, otherwise is returns 0.
%
%   mode may one of the following flags:
%
%     'autorefresh'  Re-calculate the file if it does not exist. Return 1 if the
%                    file exist, otherwise 0. This is the default
%
%     'refresh'      Always recalculate the file.
%                  
%     'cached'       Always use the cached version. Throws an error if the
%                    file does not exist.
%
%   Url: http://amtoolbox.sourceforge.net/doc/amtredofile.php

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

warning('amtredofile is deprecated and will be removed in future releases.\n For caching your data use AMTCACHE instead.');
  
if nargin<2
  error('%s: Too few input parameters.',upper(mfilename));
end;

definput.import={'amtredofile'};
[flags,kv]=ltfatarghelper({},definput,varargin);

doit=1;

if flags.do_refresh
  return;
end;

if exist(filename,'file')
  doit=0;  
else
  if flags.do_cached
    f=dbstack;  
    callfun=f(2).name;
    error('%s: A cached version of %s was requested, but it does not exist.',upper(callfun),filename);
  end;
end;
