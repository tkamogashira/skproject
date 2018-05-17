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


function w=getcenterofmass(sig)

vals=getvalues(sig);
nr=getnrpoints(sig);

su1=0;
su2=0;

for i=1:nr
   su1=su1+vals(i)*i;
   su2=su2+vals(i);
end

if su2~=0
	w=su1/su2;
else
	w=nr/2;
end
	