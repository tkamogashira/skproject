% method of class @signal
% function sigresult=append(sig1,sig2)
% appends the second signal behind the first
%
%   INPUT VALUES:
%       sig1:  first @signal
%       sig2:  second @signal
%    
%   RETURN VALUE:
%       sigresult:  @signal
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function sig=append(sig,b)

nr=max(size(b));

if nr==1
%     b=setstarttime(b,getmaximumtime(sig));
 	a=[sig.werte' getvalues(b)'];
	sig.werte=a';
% 	sig=add(sig,b,getlength(sig));
    return;
end

for i=1:nr
    sig=add(sig,b{i},getlength(sig));
end

