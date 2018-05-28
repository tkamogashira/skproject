function E = freq2erb(f);
% Freq2ERB - converts frequency in Hz to Oxford ERB scale.
%    Freq2ERB(f) returns the ERB value of frequeny f in Hz.
%    
%    See also ERB2freq

Q = (f+312)./(f+14675);
E = 43+11.17*log(Q);


