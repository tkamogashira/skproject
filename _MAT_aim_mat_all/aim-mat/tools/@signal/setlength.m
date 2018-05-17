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


function sig=setlength(sig,newlen)

% sig.length=newlen;
nr_points=time2bin(sig,newlen);
old_nr_points=getnrpoints(sig);
if nr_points < old_nr_points
    new_vals=sig.werte(1:nr_points);
else
    new_vals=zeros(nr_points,1);
    new_vals(1:old_nr_points)=sig.werte;
end    
clear sig.werte;
sig.werte=new_vals;
