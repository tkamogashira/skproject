function b = defaultfilter(this,L,M)
%DEFAULTFILTER   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

maxLM = max(L,M);

if maxLM==1,
	b = 1;
else
	Np = 12;            % Half of polyphase filter order
	N = 2*Np*maxLM;
	Astop = 80;         % Stopband Attenuation
	beta = 0.1102*(Astop-8.71); % Empirical formula when Astop > 50 dB
	b = firnyquist(N,maxLM,kaiser(N+1,beta));
	b = L*b; % Passband gain = L
    % Remove trailing zero so that the polyphase matrix doesn't have an
    % extra column of all zeros
    b = b(1:max(find(b~=0)));
end


% [EOF]
