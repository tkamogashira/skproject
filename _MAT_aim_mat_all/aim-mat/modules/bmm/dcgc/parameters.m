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

dcgc.generatingfunction = 'gen_dcgc';
dcgc.displayname = 'dynamic compressive gammachirp';
dcgc.revision='$Revision: 585 $';

dcgc.default_nextmodule='hl';

% parameters relevant for the calculation of this module

dcgc.nr_channels = 50;
dcgc.lowest_frequency = 100;  % in Hz
dcgc.highest_frequency = 6000;   % in Hz
%dcgc.b=1.019; % Filterbandwidth standard: 1.019
dcgc.do_phase_alignment='off';	%'off','maximum_envelope','nr_cycles'
dcgc.phase_alignment_nr_cycles=1.5; % only relevant when do_align is nr_cylcles

dcgc.gain_ref=70;