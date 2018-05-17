% method of class @signal
% function sig=generategauss(sig,pos,hight,sigma)
%   INPUT VALUES:
%       sig: original @signal with length and samplerate 
%       pos: medium of the curve
%       hight: its height
%       sigma: and its standart derivation
% produces a gaussian bell curve with the parameters
% 
%   RETURN VALUE:
%       sig:  @signal 
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=generategauss(sig,pos,hight,sigma)

vals=1:getnrpoints(sig);

evals=exp(-(pos-vals).^2/(2*sigma^2));

evals=evals*hight;

sig=setvalues(sig,evals);

