function m=phaseMean(ph)
% phaseMean - vector avarage of phase values in cycles
%    phaseMean(Ph) returns the vector average of the phase values in array
%    Ph [cycles!].
%   
%    See also cunwrap, ucunwrap, DelayPhase.

m = angle(mean(exp(2*pi*i*ph)))/2/pi;


