function initialize(h,L,delta,AvgFactor,BlockLength,Offset,Coefficients,FFTStates)
%INITIALIZE  Initialize properties to correct dimension.


%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,8,nargin,'struct'));


if nargin > 3, set(h,'AvgFactor',AvgFactor); end

if nargin > 4,
    set(h,'BlockLength',BlockLength);
else,
    set(h,'BlockLength', L);
end

N = get(h,'BlockLength');
if nargin > 2,
    set(h,'Power',delta*ones(L+N,1));
else,
    set(h,'Power', ones(L+N,1));
end

if nargin > 5, set(h,'Offset',Offset); end

if nargin > 6,
    % Make sure coefficients are a row
    Coefficients = Coefficients(:).';
    if length(Coefficients)~= L,
        error(message('dsp:initialize:invalidTimeDomainCoeffs'));
    end
    set(h,'FFTCoefficients',fft(Coefficients,L+N));
else,
    set(h,'FFTCoefficients',zeros(1,L+N));
end

if nargin > 7,
    set(h,'FFTStates',FFTStates);
else,
    set(h,'FFTStates',zeros(L,1));
end

