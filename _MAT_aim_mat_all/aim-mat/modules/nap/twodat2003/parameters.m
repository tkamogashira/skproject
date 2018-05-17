% parameter file for 'aim-mat'
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

%
% hidden parameters
twodat2003.generatingfunction='gen_twoDat2003';
twodat2003.displayname='two dimensional adaptive threshold';
twodat2003.revision='$Revision: 585 $';

% parameters relevant for the calculation of this module
% napoptions
twodat2003.nap.compression='log';
twodat2003.nap.do_lowpassfiltering=1;
twodat2003.nap.lowpass_cutoff_frequency=1200;
twodat2003.nap.time_constant=0.000133;
twodat2003.nap.lowpass_order=2;

% sharpening options
twodat2003.time_constant_factor=0.9;
twodat2003.frequency_constant_factor=0.9;
twodat2003.threshold_rise_constant=1;
twodat2003.b=1.019;