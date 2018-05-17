%
%      Make BandPass Noise through FFT
%      Irino, T.
%      Created before: 29 Jan 98
%      Modified: 8 Jun 2006
%
%      function [BPNoise] = MkBPNoise(fs, BandPassFreq, TSnd, RandSeed)
%      INPUT:  fs : sampling rate
%              BandPassFreq: Band pass Freq. [Min, Max]
%              TSnd: length of sound in (ms)  
%              RandSeed: random seed
%      OUTPUT: BPNoise: Bandpass Noise  (Sigma = 1 when White Gaussian Noise)
%      
%
%
function [BPNoise] = MkBPNoise(fs, BandPassFreq, TSnd, RandSeed)

if nargin <  3, TSnd = 1000; end; 	%  msec
if nargin == 4, randn('seed',RandSeed); end; % randn: mean 0, variance 1.

LenSnd = TSnd*fs/1000;
RandSnd  = randn(1,LenSnd);
FRandSnd = fft(RandSnd);
Th = angle(FRandSnd);
df = fs/LenSnd;
freq = [0:df:(fs/2-df) -fs/2:df:-df];

NfBPp = find( freq >=  BandPassFreq(1) &  BandPassFreq(2) >= freq );
NfBPn = find( freq <= -BandPassFreq(1) & -BandPassFreq(2) <= freq );


MskAmp = zeros(1,LenSnd);
MskAmp(NfBPp) = ones(size(NfBPp));
MskAmp(NfBPn) = ones(size(NfBPn));

FRandSnd = MskAmp.*FRandSnd;
BPNoise  = real(ifft(FRandSnd));

% BPNoise = BPNoise(1:LenSnd);



