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


function savewaveprescaled(sig,name)
% does some things, to make a nice sound out of it
% but assumes sig has already been scaled!
% just take out one line of savewave

sig=rampamplitude(sig,0.005);
%sig=scaletomaxvalue(sig,0.999);
if ~strfind(name,'.wav')
    name=sprintf('%s.wav',name);
end

writetowavefile(sig,name);