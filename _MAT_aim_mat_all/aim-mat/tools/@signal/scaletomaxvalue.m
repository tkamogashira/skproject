% method of class @signal
% 
%   INPUT VALUES:
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

function sig=scaletomaxvalue(si,maxv)
%usage: sig=scaleToMaxValue(si,maxv)
% scales signal so, that the maximum value is maxv (usefull for saving as wav)

sig=si;
dat=sig.werte;
ma=max(dat);
mi=min(dat);
if -mi > ma
    ma=-mi;
end

sig.werte(:)=sig.werte(:)*maxv/ma;
 