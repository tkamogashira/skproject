% parameter file for 'aim-mat'
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


%%%%%%%%%%%%%
% signal options
% hidden parameters
signal.generatingfunction=''; % there is no generating fungction for signal
signal.revision='$Revision: 585 $';
signal.displayname='the signal';

% parameters relevant for the calculation of this module
signal.start_time=0;
signal.duration=inf;
signal.sampleratemax=16000; % the only important parameter