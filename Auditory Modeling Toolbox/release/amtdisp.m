function amtdisp(in,flag)
%AMTDISP AMT-specific overload of the function 'disp'
%   Usage: amtdisp(X);
%     amtdisp(X,'progress');
%
%   AMTDISP(X); can be used for displaying information in the command
%   window in AMT functions. The output of amtdisp depends on the start-up
%   configuration of the AMT. 
%     
%   When the AMT is started in the 'verbose' mode, amtdisp will always
%   display. 
%
%   When the AMT is started in the 'documentation' mode, amtdisp will
%   display unless supressed by the flag 'progress' is provided. Thus, 
%   AMTDISP(in,'progress'); can be used as progress indicator when 
%   used in interactive way with the user but supress the progress in the
%   documentation.
%
%   When the AMT is started in the 'silent' mode, amtdisp will never
%   display. 
%
%   Url: http://amtoolbox.sourceforge.net/doc/amtdisp.php

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
  
%   Author: Piotr Majdak, 2014

if exist('flag','var')
  if ~strcmp(flag,'progress'),
    error(['Unsupported flag ' flag]);
  end
else
  flag='';
end

flags=amtflags;

if flags.do_verbose
  disp(in);
end

if flags.do_documentation
  if ~strcmp(flag,'progress'), disp(in); end
end

if flags.do_silent
  % do nothing
end
