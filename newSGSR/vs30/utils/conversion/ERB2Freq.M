function f=erb2freq(E);
% ERB2Freq - converts ERBscale to frequency in Hz
Y = exp((E-43) /11.17);
f = (Y*14675-312)./(1-Y);

