% method of class @signal
% function sig=gennoise
%       sig: original @signal with length and samplerate 
%       
%  This function generates 1/f spatial noise, with a normal error 
% distribution (the grid must be at least 10x10 for the errors to be normal). 
% 1/f noise is scale invariant, there is no spatial scale for which the 
% variance plateaus out, so the process is non-stationary.
%
%     BETA defines the spectral distribution. 
%          Spectral density S(f) = N f^BETA
%          (f is the frequency, N is normalisation coeff).
%               BETA = 0 is random white noise.  
%               BETA  -1 is pink noise
%               BETA = -2 is Brownian noise
%          The fractal dimension is related to BETA by, D = (6+BETA)/2
% 
% 
%   RETURN VALUE:
%       sig:  @signal 
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

% function sig=gennoise(sig,beta,rms_desired)
function sig=gennoise(sig,beta)

% if nargin<3
%    rms_desired=-1; % 
% end
if nargin<2
    beta=0; % 
end

sr=getsr(sig);
len=getnrpoints(sig);

dots=spatialPattern([1,len],beta);

sig=setvalues(sig,dots);
sig=setname(sig,sprintf('Noise with beta = %2.1f',beta));


% if rms_desired>=0
%     sig=rms_desired*sig/rms(sig);
% end


