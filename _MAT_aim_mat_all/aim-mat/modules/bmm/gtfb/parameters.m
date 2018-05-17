% parameter file for 'aim-mat'
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


%%%%%%%%%%%%%
% bmm
% hidden parameters
gtfb.generatingfunction='gen_gtfb';
gtfb.displayname='Gamma tone filter bank';
gtfb.revision='$Revision: 585 $';

gtfb.default_nextmodule='hcl';

% parameters relevant for the calculation of this module
gtfb.nr_channels=75;
gtfb.lowest_frequency=100;  % in Hz
gtfb.highest_frequency=6000;   % in Hz
gtfb.do_phase_alignment='off';	%'off','maximum_envelope','nr_cycles'
gtfb.phase_alignment_nr_cycles=3; % only relevant when do_align is nr_cylcles
gtfb.b=1.019; % Filterbandwidth standard: 1.019
