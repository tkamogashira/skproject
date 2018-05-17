% method of class @signal
% 
%   INPUT VALUES:
%  sig,attenuation
% sig is the signal
% attenuation is the attenuation against the lowdest possible tone
% 
% 
%
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function sig=attenuate(sig,attenuation)

if attenuation==0
    return
end

dat=sig.werte;
ma=max(dat);
mi=min(dat);
if -mi > ma
    ma=-mi;
end
amphigh=ma;

amp=amphigh / power(10,-attenuation/20);
if amp>0
    sig=scaletomaxvalue(sig,amp);
end

