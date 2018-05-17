function [Coeffs, Nch, freqs, bws] = PZBankCoeffsERB(fs, CFMax, CFMin, pdamp, zdamp, ...
					     zfactor, stepfactor)
                     
% Calculates coefficients for the pole-zero filter cascade filterbank,
% using the ERB scale for bandwidths. 

                     
% good defaults:
if nargin<1, fs = 44100; end
if nargin<2, CFMax = 18000; end % taken from 0.85*fs/2 from before
if nargin<3, CFMin = 40; end % as before
if nargin<4, pdamp = 0.12; end % can be as low as 0.1 if you start carefully
if nargin<5, zdamp = 0.2; end
if nargin<6, zfactor = 1.4; end % 1.4 seems to be the min for decent shape at low CF
if nargin<7, stepfactor = 0.3333; end


% initialize loop and storage:
freqs = [ ];
zfreqs = [ ];
zdamps = [ ];
pfreqs = [ ];
pdamps = [ ];
za0 = [ ];
za1 = [ ];
za2 = [ ];


pfreq= CFMax/fs*(2*pi); % normalised maximum pole frequency

ch=0;

% design channel coeffs:
while (pfreq/(2*pi))*fs > CFMin % keep above the lowest centre frequency
    ch = ch+1;
    freqs(ch) = pfreq/(2*pi)*fs;   %  next freq in Hz
    % compute the coefficients for the zeros:
    zfreq = min(pi, zfactor*pfreq);
    % impulse-invariance mapping z=exp(sT):
    ztheta = zfreq*sqrt(1-zdamp^2);
    zrho = exp(-zdamp*zfreq);
    % direct form coefficients from z-plane rho and theta:
    a1 = -2*zrho*cos(ztheta);
    a2 = zrho*zrho;
    % normalize to unity gain at DC:
    asum = 1 + a1 + a2;
    za0(ch) = 1/asum;
    za1(ch) = a1/asum;
    za2(ch) = a2/asum;
    pfreqs(ch) = pfreq;
    pdamps(ch) = pdamp;
    
    %bw = bwOverCF*pfreq + 2*pi*bwMinHz/fs; % Greenwood formula?
    [dummy, bw] = Freq2ERB(pfreq/(2*pi)*fs); 
    bw=bw*(2*pi)/fs;
    bws(ch)=bw;
    pfreq = pfreq - stepfactor*bw;
end

Nch = ch;

Coeffs = [ pfreqs', pdamps', za0', za1', za2' ];

freqs = freqs';



