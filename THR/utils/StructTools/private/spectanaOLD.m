function [XS, YS, YSRunAv, DF] = spectana(X, Y, RunAvRange)
%SPECTANA   analyse spectrum of digital signal with DFT
%   [XS, YS, YSRunAv, DF] = SPECTANA(X, Y) analyses spectrum of digital signal given by vectors X and Y, where X
%   is a linear spaced time-axis(in millisec) and Y is de amplitude of the signal. This function returns the spectrum
%   as 2 vectors: XS is the frequency-axis(in Hz), YS is de ampiltude of each given frequency in the signal given in
%   dB(maximum A is reference, thus maximum is at 0 dB). The dominant frequency in the signal is given in DF.
%
%   [XS, YS, YSRunAv, DF] = SPECTANA(X, Y, RunAvRange) does the same analysis, but uses a running average of range
%   RunAvRange in Hz, which is returned as the vector YSRunAv, to calculated the DF.

%B. Van de Sande 25-03-2003

if ~any(nargin == [2,3]), error('Wrong number of input arguments.'); end
if ~any(size(X) == 1) | ~any(size(Y) == 1) | ~isequal(length(X), length(Y)), error('First two inputs should be vectors of same size.'); end
if nargin == 2, RunAvRange = 0; end

if size(Y, 1) == 1, Y = Y'; iscol = logical(0); end

%Discrete fourier transformatie in dB ...
NBin = length(X);
dt = X(2)-X(1); %BinWidth
HanFilter = hanning(NBin);
Zeros = zeros(2^(2+nextpow2(NBin))-NBin, 1);
NSamples = length(Zeros)+NBin;
Tmax = (NSamples) * dt; 
df = 1000/Tmax;
RunAvN = RunAvRange / df;

A = abs(fft([HanFilter.*Y; Zeros]));
YS = local_A2dB(A, max(A));
YSRunAv = runav(YS, RunAvN);
XS = (0:length(YS)-1)' * df;

%Het achterhalen van de dominante frequentie ...
DF = getmaxloc(XS, YSRunAv, 0, [0, max(XS)/2]);
if (DF < 10), DF = getmaxloc(XS, YSRunAv, 0, [50, max(XS)/2]); end %Waarschijnlijk DC aanwezig in signaal ... vanaf 50Hz zoeken naar maximum ...

if ~iscol, [XS, YS, YSRunAv] = deal(XS', YS', YSRunAv'); end

%---------------------------locals-----------------------------------
function dB = local_A2dB(A, RefA);

dB = 20.*log10(A/RefA); 
