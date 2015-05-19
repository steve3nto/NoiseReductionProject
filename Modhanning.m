function window = Modhanning(length);

% Modhanning    window = Modhanning(length);
%
% =========================================================================
% This code has been produced in the context of the STW project 'Sinusoidal
% Coding of Audio and Speech (SiCAS)'. The parties involved in this project
% are Philips Research, Delft University of Technology and the Royal 
% Institude of Technology (KTH). This code may only be used by the involved
% parties and in the context of this project.	  
% =========================================================================
%
% pre:       The variable 'length' contains the length of the window to be
%            generated.
%
% post:      The variable 'window' contains the window coefficients. 
%            
% imports:   
%
% author(s): R. Heusdens	
%
% date:      November 13, 2000

% Check usage
error(nargchk(1,1,nargin));

% Generate window
window =(.5 + .5*cos(2*pi*(-(length-1)/2:(length-1)/2)/length))';