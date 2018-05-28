function Drho = DRhoThreshold(SNR, BW, Dur, dprime);
% DRhoThreshold - detection threshold of decorrelation from 1 by an ideal detector.
%   DRhoThreshold(SNR, BW, Dur) returns the threshold decorrelation that
%   can be detected by an ideal detector in the sense that d'=1 at threshold.
%   The stimulus is assumed to be a two-schannel Gaussion noise segment;
%   BW and Dur are the bandwidth and duration of the stimulus in recipocal
%   units, e.g. s & Hz or ms & kHz.
%   SNR is the signal-to-noise ratio in dB of the signal coding at the input of
%   the detector. 
%   An imaginary threshold decorrelation is returned if the criterion
%   dprime can never be attained due to low values of SNR, BW and/or Dur.
%
%   DRhoThreshold(SNR, BW, Dur, dprime) uses a different criterion dprime for
%   the definition of threshold.
%
%   DRhoThreshold is the inverse function of Rho2dprime for the special case
%   of a unity reference correlation.
%
%   Note: It is assumed that BW*Dur>>1, justifying the use of Gaussian statistics. 
%   Small BW*Dur values will require a more rigorous analysis. A warning is
%   given if BW*Dur<10.
%
%   See also Rho2dprime.

if nargin<4, dprime=1; end

% convert SNR to power factor: PowerOfInternalNoise = beta*PowerOfStimulus.
beta = db2p(-SNR);

% # degrees of freedom: number of independent sample of the noise segment.
Ndf = BW*Dur; 
if Ndf<10, warning('#degrees of freedom<10; use of Gaussian statistics not justified.'); end

% next invert Rho2dprime in 2 steps.
gamma = sqrt(2*Ndf./dprime.^2-1);

Drho = 2*beta./(gamma-1);












