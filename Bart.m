function Px = Bart(x,nsect)

%BART	Bartlett's method of periodogram averaging.

%----

%USAGE	Px = Bart(x,nsect) 

%

%	The spectrum of a process x is estimated using Bartlett's 

%	method of periodogrm averaging.

%	

%	x     :  Input sequence

%	nsect :	 Number of subsequences to be used in the average

%

%	The Bartlett estimate is returned in Px using a linear scale.

%

%  see also PER, MPER, WELCH, and SPER

%

%---------------------------------------------------------------

% copyright 1996, by M.H. Hayes.  For use with the book 

% "Statistical Digital Signal Processing and Modeling"

% (John Wiley & Sons, 1996).

%---------------------------------------------------------------



L  = floor(length(x)/nsect);

Px = 0;

n1 = 1;

for i=1:nsect

    Px = Px + per(x(n1:n1+L-1))/nsect;

    n1 = n1 + L;

    end;
