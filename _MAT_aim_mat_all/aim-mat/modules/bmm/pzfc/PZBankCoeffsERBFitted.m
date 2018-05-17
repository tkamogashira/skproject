function [Coeffs,  Nch, freqs] = PZBankCoeffsERBFitted(fs, CFMax, CFMin, ValParam)

% Calculates coefficients for the pole-zero filter cascade filterbank,
% using the ERB scale for bandwidths, taking its parameters from the fit 
% data provided in ValParam


% good defaults:
if nargin<1, fs = 44100; end
if nargin<2, CFMax = 18000; end % taken from 0.85*fs/2 from before
if nargin<3, CFMin = 40; end % as before
if nargin<4, ValParam = [ ... % Fit 515 from Dick
% Final, Nfit = 515, 9-3 parameters, PZFC, cwt 0
     1.72861   0.00000   0.00000 % SumSqrErr=  13622.24
     0.56657  -0.93911   0.89163 % RMSErr   =   3.26610
     0.39469   0.00000   0.00000 % MeanErr  =   0.00000
         Inf   0.00000   0.00000 % RMSCost  =       NaN
     0.00000   0.00000   0.00000
     2.00000   0.00000   0.00000
     1.27393   0.00000   0.00000
    11.46247   5.46894   0.11800
%    -4.15525   1.54874   2.99858 % Kv
     ];
end
 

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

    % Run the fit parameters through the necessary steps to get out s-plane
    % filter parameters for a low-low level signal at the noise floor.
    [b1, b2, c, n1, n2, frat] = PZFC_Small_Signal_Params(freqs(ch), ValParam);

    % Mapping of these outputs is as follows:
    % b1 -> brat
    % b2 -> coeferbw
    % c -> coefc - should be at infinity, ignore
    % n1 -> unused
    % n2 -> orderg (gives channel step factor)
    % frat -> frat

    % to define: zfactor
    
    % calculate pole bandwidth. This is a function of b2 (CoefERBw), and the current nominal
    % ERB width. Use this to calculate pole damping.
    [ERBrate ERBw] = Freq2ERB(freqs(ch));
    bw = b2.*ERBw.*(2*pi)/fs;  %  bandwidth (normalised)
    % pole bandwidth is same as bandwidth when n2=4 (n2 is orderg),
    % otherwise it needs recalculating:
    pbw=(bw/2).*(n2.^0.5);
    
    pdamp=pbw./sqrt(pfreq.^2+pbw.^2); % f(b)

    zfactor= frat; % frat is the frequency ratio of the zero to the pole
    bw=b1.*frat.*ERBw.*(2*pi)/fs; % check this
    zbw=(bw/2).*(n2.^0.5);
    
    % From the previous version:
    % % compute the coefficients for the zeros:
    zfreq = zfactor*pfreq;
    if zfreq > pi
       warning('Zero frequency exceeds Nyquist frequency in PZBankCoeffsERBFitted');
    end
    % We warn if this gets limited at pi, it implies that the zero is
    % trying to drift up above the Nyquist frequency, which is bad.
    
    % zero damping:
    zdamp=zbw./sqrt(zfreq.^2+zbw.^2);
    

    
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
    
    
    
    
    % This is calculated once per channel - but it should stay constant
    % unless the fit parameters are really odd (it will change if there
    % are nonzero entries in columns 2 and 3 in row 7 of ValParam).  
    stepfactor=1/n2; % this is what gives the final channel density
    

    % Bandwidth calculation, as before
    [dummy, bw] = Freq2ERB(pfreq/(2*pi)*fs); 
    bw=bw*(2*pi)/fs;
    bws(ch)=bw;
    pfreq = pfreq - stepfactor*bw;
    
end

Nch = ch;

Coeffs = [ pfreqs', pdamps', za0', za1', za2' ];

freqs = freqs';


