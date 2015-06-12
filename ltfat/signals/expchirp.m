function outsig=expchirp(L,fstart,fend,varargin)
%EXPCHIRP  Exponential chirp
%   Usage: outsig=expchirp(L,fstart,fend)
% 
%   EXPCHIRP(L,fstart,fend) computes an exponential chirp of length L*
%   starting at normalized frequency fstart and ending at frequency fend.
%
%   EXPCHIRP takes the following parameters at the end of the line of input
%   arguments:
%
%     'fs',fs    Use a sampling frequency of fs Hz. If this option is
%                specified, fstart and fend will be measured in Hz.
%
%     'phi',phi  Starting phase of the chirp. Default value is 0.
%
%   See also: pchirp
%
%   Url: http://ltfat.github.io/doc/signals/expchirp.html

% Copyright (C) 2005-2015 Peter L. Soendergaard <peter@sonderport.dk>.
% This file is part of LTFAT version 2.1.0
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
    
% AUTHORS:  Piotr Majdak, Peter L. Søndergaard.

if nargin<3
  error('%s: Too few input parameters.',upper(mfilename));
end;

definput.keyvals.phi=0;
definput.keyvals.fs=[];

[flags,kv]=ltfatarghelper({},definput,varargin);

if ~isempty(kv.fs)
  fstart=fstart/kv.fs*2;
  fend  =  fend/kv.fs*2;
end;

w1=pi*fstart*L;
w2=pi*fend*L;

A=w1/log(w2/w1);
tau=1/log(w2/w1);

t=((0:L-1)/L).';
outsig=exp(i*A*(exp(t/tau)-1)+kv.phi);


