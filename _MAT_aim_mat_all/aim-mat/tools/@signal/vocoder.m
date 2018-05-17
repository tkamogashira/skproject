% method of class @signal
% function sig=vocoder(sig,warp_factor)
% produces a time warped version of the signal. 
% built on the "A Phase Vocoder in Matlab" on 
% http://www.ee.columbia.edu/~dpwe/resources/matlab/pvoc/
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=vocoder(a,warp_factor)

data=get(a); % get the values

newdata=pvoc(data,warp_factor); % call the warping routine
sig=signal(newdata,getsr(a));