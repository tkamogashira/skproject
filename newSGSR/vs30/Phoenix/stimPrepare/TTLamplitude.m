function A = TTLamplitude(sys);
% TTLamplitude - amplitude of synthesised TTL pulses over DAC of sys2
%   If the current setup uses TDT system-II stuff, TTLamplitude returns 
%   the amplitude for artifical sync pulses to be played over the DAC.
%   If system-II stuff is not used, TTLamplitude returns zero.
%
%   TTLamplitude('sys2') always returns the TTL amplitude as is sys-II 
%   stuff is used, regardles of the local setup.
%
%   See also TDTsystem.

if nargin<1, sys = TDTsystem; end; % local setup


if isequal('sys2', lower(sys)),
   global SGSR;
   A = SGSR.TTLamplitude;
else, 
   A = 0;
end
   
