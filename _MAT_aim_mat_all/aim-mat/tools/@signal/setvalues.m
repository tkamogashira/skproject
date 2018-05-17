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


function sig=setvalues(org_sig,new_vals,startint)
%usage: sig=setvalues(si,new,vals)
% sets all values of the signal org_sig to the new values
% if only one value is given, than all vals are set to this value

if getnrpoints(org_sig)~=max(size(new_vals)) & nargin < 3 
    disp('error: setvalues: different size of signal and new values');
end

if nargin < 3
    startint=1;
end

if length(new_vals)==1
    len=getnrpoints(org_sig)-startint+1;
    new_vals=ones(len,1)*new_vals;
end
if size(new_vals,1)< size(new_vals,2)
    new_vals=new_vals';
end

len=size(new_vals,1);

nval=org_sig.werte;
nval(startint:startint+len-1)=new_vals;
org_sig.werte=nval;
sig=org_sig;
 