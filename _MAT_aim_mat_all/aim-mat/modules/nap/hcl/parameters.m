% parameter file for 'aim-mat'
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


%%%%%%%%%%%%%
% hcl
% hidden parameters
hcl.generatingfunction='gen_hcl';
hcl.displayname='halfwave rectification, compression and lowpass filtering';
hcl.revision='$Revision: 585 $';

% parameters relevant for the calculation of this module
hcl.compression='log';
hcl.do_lowpassfiltering=1;
hcl.lowpass_cutoff_frequency=1200;
hcl.lowpass_order=2;
