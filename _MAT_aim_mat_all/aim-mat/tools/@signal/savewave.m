% method of class @signal
% savewave(sig,name[,ramp])
%   INPUT VALUES:
%  		name : name of the resulting sound file
% 		ramp: if given, then the signal is ramped with a linear ramp with
% 		that duration
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function savewave(sig,name,ramp)
% does some things, to make a nice sound out of it

if nargin < 3
    ramp=0.0;	% default ramp is off
end
if nargin < 2
    name='just saved';
end



sig=rampamplitude(sig,ramp);
sig=scaletomaxvalue(sig,0.999);
if isempty(strfind(name,'.wav'))
    name=sprintf('%s.wav',name);
end

fid=fopen(name, 'w');
if fid==-1
	disp(sprintf('can''t write file ''%s'', is file open in CoolEdit? If so please close!',name));
	error('file open in CoolEdit... Cant write');
else
    % TCW AIM 2006
    fclose(fid); % Otherwise MATLAB leaves the file open for writing for ever!
    
	writetowavefile(sig,name);
end
