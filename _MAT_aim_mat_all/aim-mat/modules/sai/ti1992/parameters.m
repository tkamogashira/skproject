% parameter file for 'aim-mat'
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

%%%%%%%%%%%%%
% sai
% hidden parameters
ti1992.generatingfunction='gen_ti1992';
ti1992.displayname='time integration stabilized auditory image old model';
ti1992.revision='$Revision: 585 $';

% parameters relevant for the calculation of this module
ti1992.buffer_memory_decay=0.03;
ti1992.buffer_tilt=0.04; % memory decay in the buffer
ti1992.maxdelay=0.035;
ti1992.mindelay=0.001;
ti1992.frames_per_second=100;