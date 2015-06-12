function h=lconv(f,g,varargin)
%LCONV  Linear convolution
%   Usage:  h=lconv(f,g);
%
%   LCONV(f,g) computes the linear convolution of f and g. The linear 
%   convolution is given by
%
%               Lh-1
%      h(l+1) = sum f(k+1) * g(l-k)+1)
%               k=0
%
%   with L_{h} = L_{f} + L_{g} - 1 where L_{f} and L_{g} are the lengths of f and g, 
%   respectively.
%
%   LCONV(f,g,'r') computes the linear convolution of f and g where g is reversed.
%   This type of convolution is also known as linear cross-correlation and is given by
%
%               Lh-1
%      h(l+1) = sum f(k+1) * conj(g(k-l+1))
%               k=0
%
%   LCONV(f,g,'rr') computes the alternative where both f and g are
%   reversed given by
%
%               Lh-1
%      h(l+1) = sum conj(f(-k+1)) * conj(g(k-l+1))
%               k=0
%     
%   In the above formulas, l-k, k-l and -k are computed modulo L_{h}.
%
%   Url: http://ltfat.github.io/doc/fourier/lconv.html

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

%   See also: pconv

%   AUTHOR: Jordy van Velthoven
%   TESTING: TEST_LCONV	
%   REFERENCE: REF_LCONV
  
complainif_notenoughargs(nargin, 2, 'LCONV');

definput.keyvals.L=[];
definput.keyvals.dim=[];
definput.flags.type={'default', 'r', 'rr'};

[flags,kv,L,dim]=ltfatarghelper({'L','dim'},definput,varargin);

[f,L1,Lf,Wf,dimout,permutedsize_f,order_f]=assert_sigreshape_pre(f,L,dim,'LCONV');
[g,L2,Lg,Wg,dimout,permutedsize_g,order_g]=assert_sigreshape_pre(g,L,dim,'LCONV');

Lh = Lf+Lg-1;

f = [f; zeros(Lh - Lf, 1)];
g = [g; zeros(Lh - Lg, 1)];

if isreal(f) && isreal(g)
  fftfunc = @(x) fftreal(x);
  ifftfunc = @(x) ifftreal(x, Lh);
else
  fftfunc = @(x) fft(x);
  ifftfunc = @(x) ifft(x, Lh);
end;

if flags.do_default
  h=ifftfunc(fftfunc(f).*fftfunc(g), Lh);
end;

if flags.do_r
  h=ifftfunc(fftfunc(f).*(conj(fftfunc(g))), Lh);
end;

if flags.do_rr
  h=ifftfunc((conj(fftfunc(f))).*(conj(fftfunc(g))), Lh);
end;

