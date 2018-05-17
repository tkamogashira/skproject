% parameter file for 'aim-mat'
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


%%%%%%%%%%%%%
% hl
% hidden parameters
hl.generatingfunction='gen_hl';
hl.displayname='halfwave rectification and lowpass filtering';
hl.revision='$Revision: 585 $';

% parameters relevant for the calculation of this module
hl.do_lowpassfiltering=1;
hl.lowpass_cutoff_frequency=1200;
hl.lowpass_order=2;
