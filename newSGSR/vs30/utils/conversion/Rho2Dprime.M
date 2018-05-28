function dprime = Rho2Dprime(rho1, rho2, SNR, BW, Dur);
% Rho2Dprime - detection index d' for correlation discrimination by an ideal detector
%   Rho2Dprime(rho1, rho2, SNR, BW, Dur) returns d1 for discriminating between
%   two binaural Gaussian noise stimuli. Parameters:
%        rho1, rho2: interaural correlation values of the respective stimuli.
%        SNR: signal-to-noise ratio in dB of stimulus coding at the input of detector.
%        Dur, BW: duration and bandwidth in reciprocal units, e.g. s & Hz or ms & kHz.
%
%   Input parameters may be vectors. If several parameters are vectors, their
%   sizes must match.
%        
%   Note: It is assumed that BW*Dur>>1, justifying the use of Gaussian statistics. 
%   Small BW*Dur values will require a more rigorous analysis. A warning is
%   given if BW*Dur<10.
%
%   EXAMPLE. The following code displays d' as a function of a decorrelation
%   from one (called Drho) for various values of the S/N ratio.
%      Drho = linspace(0,2)'; % decorrelation column vector
%      dprime = []; % dprime will be stored in matrix
%      for SNR=[0:5:35], % add column to dprime
%          dprime = [dprime rho2Dprime(1,1-Drho,SNR,100,1)]; 
%      end; 
%      plot(Drho, dprime); % SNR is parameter
%      xlabel('Decorrelation from one');
%      ylabel('d''');
%
%   Consult the source code for details of the computation.
%
%   See also DrhoThreshold.

% convert SNR to power factor: PowerOfInternalNoise = beta*PowerOfStimulus.
beta = db2p(-SNR);

% # degrees of freedom: number of independent sample of the noise segment.
Ndf = BW*Dur; 
if Ndf<10, warning('#degrees of freedom<10; use of Gaussian statistics not justified.'); end

% The ideal detector subtracts the two channels. The power of the resulting
% difference signal is a measure of the correlation. In fact the expected
% power is  P_diff = 2*P*(1-rho), where P is the power of the effective signal
% at the two ears and rho is the net correlation of the binaural stimulus.
% (see vdH & Trahiotis, "a new way ..")
% The addition of internal noise as quantified by SNR changes the effective
% power and correlation in a simple way to yield:
%     P_diff = 2*P*(1+beta-rho), where now P and rho are the true stimulus
% values, i.e., prior to the contamination by internal noise.
%
% The difference signal D ("residual noise after attempted cancellation" is an
% alternative way to look at it) is Gaussian because it is a sum of
% two Gaussian noises (the stimulus and the internal noise). The power of D 
% therefore obeys a chi^2 distribution with Ndf degrees of freedom (see above).
% The mean M of this distribution equals the expected power as above:
%   M = (1+beta-rho),
% where, without loss of generality, we took 2*P = 1.
% From chi^2 statistics it follows that the variance Var is:
%   Var = 2*M^2/Ndf = 2*(1+beta-rho)^2/Ndf.
%
% The detection parameter d' for discriminating between 2 values of rho
% is the mean-to-stdev ratio of the distribution of the difference of the
% decision variables for the two respective rho values. Because the 
% distributions are (approx.) Gaussian, the variances add and we get:
%   d' = [M(rho1)-M(rho2)]/sqrt(Var(rho1)+Var(rho2)).
%
% This yields the following code:

variance1 = (1+beta-rho1).^2;
variance2 = (1+beta-rho2).^2;
dprime = (rho1-rho2).*sqrt(Ndf)./sqrt((variance1+variance2)/2);
% (have to check the /2 factor in the denominator - check definition of d')













