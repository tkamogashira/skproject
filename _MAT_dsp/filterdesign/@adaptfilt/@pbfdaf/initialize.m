function initialize(h,L,delta,AvgFactor,N,Offset,Coefficients,States)
%INITIALIZE  Initialize properties to correct dimension.


%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.


if nargin > 3, set(h,'AvgFactor',AvgFactor); end

if nargin > 4,
    if N >= L | rem(L,N),        
        error(message('dsp:adaptfilt:pbfdaf:initialize:InvalidBlockLength'));
    end
    set(h,'BlockLength',N);
else,
    if isprime(L),
        error(message('dsp:adaptfilt:pbfdaf:initialize:InvalidDimensions1'));
    end
    N = factor(L);
    set(h,'BlockLength', N(1));
end

N = get(h,'BlockLength');
if nargin > 2,
    set(h,'Power',delta*ones(2*N,1));
else,
    set(h,'Power', ones(2*N,1));
end

if nargin > 5, set(h,'Offset',Offset); end

if nargin > 6,
    % Make sure coefficients are a row
    Coefficients = Coefficients(:).';
    if length(Coefficients)~= L,
        error(message('dsp:adaptfilt:pbfdaf:initialize:InvalidDimensions2'));
    end  
else,
    Coefficients = zeros(1,L);
end
M = L/N;
WW0 = zeros(N,M);
WW0(:) = Coefficients;
set(h,'FFTCoefficients',fft([WW0;zeros(N,M)]).');


if nargin > 7,
    % Make sure States are a column
    States = States(:);
    if length(States)~= L-N,
        error(message('dsp:adaptfilt:pbfdaf:initialize:InvalidDimensions3'));
    end  
else,
    States = zeros(L-N,1);
end
X0 = zeros(N,M-1);
X0(:) = States;
set(h,'FFTStates',fft([X0;zeros(N,M-1)]));

