% method of class @signal
% function sig=generateirn(sig,delay,g,niter)
%   INPUT VALUES:
%       sig: original @signal with length and samplerate 
%       delay: delay, after which the noise is added again
%       g: gain
%       niter: number of iterations that are added
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


function sig=generateirn(sig,delay,g,niter)

srate=getsr(sig);
dur=getlength(sig);

dels=round(delay*srate);
npts=round(dur*srate);

nois=randn(size(1:npts));

for i=1:niter;
    dnois=nois;
    dnoist=dnois(1:dels);
    dnois=[dnois dnoist];
    dnois=dnois(dels+1:npts+dels);
    dnois=dnois.*g;
    nois=nois+dnois;
end;

rms=sqrt(mean(nois.*nois));
b=nois./rms;

sig=setvalues(sig,b);