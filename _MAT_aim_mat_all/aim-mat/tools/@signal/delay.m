% method of class @signal
% function delay(sig)
% delays the signal by so many seconds. Fills the start with zeros and cuts
% the end
%
%   INPUT VALUES:
%       sig: original @signal
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=delay(sig,del)

sr=getsr(sig);
% nr_del=del*sr;
nr_del=round(del*sr);
vals=getvalues(sig);
nvals1=zeros(1,nr_del);
nvals2=vals(1:end-nr_del);

new_vals=[nvals1 nvals2'];
sig=setvalues(sig,new_vals);
sig=setname(sig,sprintf('%s delayed by %f sec',getname(sig),del));


