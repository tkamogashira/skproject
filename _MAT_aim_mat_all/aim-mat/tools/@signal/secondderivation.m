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


function sig=secondderivation(sig)
% calculates the second derivation by calculation of the differences


val=getvalues(sig);

nr=length(val);


nval=val;
nval(1)=0;
nval(2)=0;
for i=3:nr

    if i==370
        a=0;
    end
    nval(i)=(val(i-2)-2*val(i-1)+val(i))/2;
end

sig=setvalues(sig,nval);
