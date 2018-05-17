% parameter file for 'aim-mat'
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


%%%%%%%%%%%%%
% outer/middle ear filter function
% hidden parameters
gm2002.generatingfunction='gen_gm2002';
gm2002.displayname='outer/middle ear transfere function from Glasberg and Moore (2002)';
gm2002.revision='$Revision: 585 $';

% parameters relevant for the calculation of this module
gm2002.select_correction=1;
gm2002.delay_correction=-0.04205; 