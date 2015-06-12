function c=constructphase(s,g,a)
%CONSTRUCTPHASE  Construct the phase of a DGT
%   Usage:  c=constructphase(s,g,a);
%           c=constructphase(s,g,a,tol);
%
%   CONSTRUCTPHASE(s,g,a) will construct a suitable phase for the postive
%   valued coefficients s. 
%  
%   If s is the absolute values of the Gabor coefficients of a signal
%   obtained using the window g and time-shift a, i.e.:
%
%     c=dgt(f,g,a,M);
%     s=abs(c);
%
%   then constuctphase(s,g,a) will attempt to reconstruct c.
%
%   The window g must be Gaussian, i.e. g must have the value 'gauss'
%   or be a cell array {'gauss',tfr}.
%
%   CONSTRUCTPHASE(s,g,a,tol) does as above, but sets the phase of
%   coefficients less than tol to zero phase. This speeds up the
%   computation. By default, tol has the value 1e-10.
%
%   This function requires a computational subroutine that is only
%   available in C. Use LTFATMEX to compile it.
%
%   See also:  dgt, gabphasegrad, ltfatmex
%
%   Demos:  demo_constructphase
%
%   Url: http://ltfat.github.io/doc/gabor/constructphase.html

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
  
% AUTHOR: Peter L. Søndergaard
M=size(s,1);
N=size(s,2);
L=N*a;
  
% Obtain the vectors.
[tgrad,fgrad] = gabphasegrad('abs',s,g,a);

tol=1e-10;

newphase=comp_heapint(s,tgrad,fgrad,a,tol);

c=s.*exp(i*newphase);


