function f=erb2freq(E);
% ERB2Freq - converts Oxford ERB-scale to frequency in Hz
%    ERB2freq(E) returns the frequncy in Hz of the ERB value E.
%    
%    See also freq2ERB

Y = exp((E-43) /11.17);
f = (Y*14675-312)./(1-Y);

