% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function sig=shiftcircular(sig,shifttime)
% shift the period in time circlular
% if shifttime > 0then circle positiv, otherwise negative


bin=time2bin(sig,shifttime);
nrpoints=getnrpoints(sig);
if bin<1
    bin=nrpoints+bin;
end

vals=getvalues(sig);
valnew=zeros(size(vals));

valnew(1:bin)=vals(end-bin+1:end);
valnew(bin+1:end)=vals(1:end-bin);

sig=setvalues(sig,valnew);
