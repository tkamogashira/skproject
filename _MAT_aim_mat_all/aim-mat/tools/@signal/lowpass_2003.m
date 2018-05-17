%  
% function 
%
%   INPUT VALUES:
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




function sig=lowpass_2003(sig,cutoff,order)


if nargin<2
    order=1;
end


sr=getsr(sig);
vals=getvalues(sig);

[b a] = butter(order,cutoff/(sr/2));


sig_len = length(vals);


filt_vals(1:sig_len) = filter(b,a,vals);
vals=filt_vals;


sig=setvalues(sig,vals);
