function impResp = CalibImpulseResponse(SampleFreq, Duration, Channel, Fmin);

% CalibImpulseResponse - returns impulse response for calibration
% SYNTAX:
% impResp = CalibImpulseResponse(SampleFreq, Duration, Fmin);
% SampleFreq & Fmin in Hz, Duration in ms. Channel = 'L' | 'R' 
% (left or right D/A channel).
% impResp is vector containing impulse response, sampled with
% specified Duration and SampleFreq. Convolving a signal with
% this impulse response filters the signal according to the 
% pre-emphasis dictated by the current calibration. (see calibrate)
% Optional Fmin indicates that freqs below Fmin are treated as
% if they equal Fmin. This serves to avoid a huge boost of 
% very low frequencies which are both irrelevant and
% poorly coupled (the poor coupling causes the boost).

% modified by EVE 05/06/09: impulse response was not correct

if nargin<4, Fmin=[]; end;
global SGSR

% compose frequency axis from total amount of samples. 
	[dd filterIndex] = min(abs(SampleFreq-SGSR.samFreqs));	% filter index closest to realizing samfreq
	N = 2*round(0.5*SampleFreq*Duration*1e-3);				% # (even) points of complex spectrum
	M = N/2;												% # points of positive-freq part of spectrum, nyquist freq not included

	freqs = linspace(0,SampleFreq,N+1);						% make freq components from DC .. sample freq
 	freqs = freqs(1:M);										% positive freqs only, nyquist freq excluded also

	% note example: sample freq = 10; dur = 1s; 
	%				--> N = 10; M = 5;
	%				--> freqs : 0 1 2 3 4 5 6 7 8 9 10
	%				--> freqs =	0 1 2 3 4				% --> no nyquist freq!
	
% get the correction [dB, cycles] from calibration
% the calibration is an analog value and expressed in dB re to (1DACbits/µPa)
% So how many DACbits levels do we need to have 20µPa at the eardrum
 	[amp phase] = calibrate(freqs, filterIndex, Channel);	
	% apply same calibration below Fmin as Fmin to avoid too large calibration values
	amp		= zeros(1,length(amp));
	phase	= zeros(1,length(amp));
	if ~isempty(Fmin),
	   [constAmp constPhase]	= calibrate(Fmin, filterIndex, Channel);
	   ToLow					= find(freqs<Fmin);
	   amp(ToLow)				= constAmp;
	   phase(ToLow)				= constPhase;
	end
		%	note example: freqs =	0  1  2  3  4
		% 				--> amp =   1 .1 .2 .3 .4 % no nyquist data in here!
		%		Fmin = 2--> amp =  .2 .2 .2 .3 .4
		%	   (Dc remov--> amp =   0 .2 .2 .3 .4 )
		% 

% convert spectrum to polar form
	Spec = db2a(amp).*exp(2*pi*i*phase);	% polar --> complex format and cycle->rad
%  	Spec(1) = 0;							% remove DC <add EVE 05/06/2009>

% construct full spectrum for ifft 
% negative-freq components: mirrored complex conjugate of pos-freq components
	%<added & modified by  EVE 05/06/09>
	Spec = Spec ./ 2;					% amplitude will be divided over pos & neg freq. spectrum 
 	Spec = [Spec 0 conj(Spec(M:-1:2))];	% compose full spectrum; nyquist freqency = 0
	Spec = Spec .*(length(Spec));		% ifft convertion factor
	%	note example:   0 .2 .4 .2 .4
	%				-->	0 10 20 10 20 0 20 10 20 10	

% make time impulse response from calibration spectrum
	impResp = real(ifft(Spec));
