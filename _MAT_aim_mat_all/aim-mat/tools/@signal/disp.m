% method of class @signal
% function display(sig)
% overwritten function that is called from the shell and for the tooltips
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


function disp(sig)
disp(sprintf('%s',sig.name));
if ~isempty(strfind(sig.unit_x,'ms'))
    disp(sprintf('sr=%5.0f/s length:%4.0f ms points:%5d',sig.samplerate,getlength(sig)*1000,getnrpoints(sig)));
elseif ~isempty(strfind(sig.unit_x,'s'))
    disp(sprintf('sr=%5.0f/s length:%2.2f sec points:%5d',sig.samplerate,getlength(sig),getnrpoints(sig)));
else
    disp(sprintf('unit(x)=%s',sig.unit_x));
    disp(sprintf('signal: sr=%5.0f length:%4.2f points:%5d',sig.samplerate,getlength(sig),getnrpoints(sig)));
end
% sig.werte(1:10)'

vals=sig.werte;
nans=find(isnan(vals));
if length(nans)>0
    disp('has NANs');
end