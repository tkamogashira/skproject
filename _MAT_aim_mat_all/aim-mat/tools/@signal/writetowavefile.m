% method of class @
% function writetowavefile(sig,name)
%   INPUT VALUES:
%  		sig: @signal
%		name: name of the resulting wavefile
%   RETURN VALUE:
%	none
% 
% writetowavefile saves the signal to a wavefile without changing its
% amplitude (contrary to savewave)
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function writetowavefile(sig,name)
samplerate=getsr(sig);
readsounddata=getdata(sig);
wavwrite(readsounddata,samplerate,name);
