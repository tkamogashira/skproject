% parameter file for 'aim-mat'
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


%%%%%%%%%%%%%
% strobes
% hidden parameters
sf2003.generatingfunction='gen_sf2003';
sf2003.displayname='strobe finding';
sf2003.revision='$Revision: 585 $';

% parameters relevant for the calculation of this module
sf2003.strobe_criterion='interparabola'; % can be 'parabola', 'bunt','adaptive'
% sf2003.unit='sec'; % which unit all the other parameters have

sf2003.strobe_decay_time=0.02;
% parameters for parabola:
sf2003.parabel_heigth=1.2;
sf2003.parabel_width_in_cycles=1.5;
% parameters for bunt:
sf2003.bunt=1.02;
sf2003.wait_cycles=1.5; % the time, that no new strobe is accepted
sf2003.wait_timeout_ms=20;

% parameters for 'adaptive':
sf2003.slope_coefficient=1;

