% method of class @signal
% function sig=convolute(sig1,sig2)
%
% calculates the convolution between the signals sig1 and sig2. The
% return value is a signal 
%
%   INPUT VALUES:
%       sig1: original @signal
%       sig2: @signal to correlate with
% 		
%   RETURN VALUE:
% 		@sig: the convolution values at each delay
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=convolute(sig1,sig2)


values1=getvalues(sig1);
values2=getvalues(sig2);

% do the convolution
sr1=getsr(sig1);
sr2=getsr(sig2);

if sr1~=sr2
    error('sample rates of both signals must be the same!');
    return
end

corrcovs=conv(values1,values2);

% return a signal:
sig=signal(corrcovs,sr1);
sig=setname(sig,'Convolution');






