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
maf.generatingfunction='genmaf';
maf.displayname='outer/middle ear transfere function: Minimum Audible Field';
maf.revision='$Revision: 585 $';

% parameters relevant for the calculation of this module
maf.delay_correction=-0.0063;