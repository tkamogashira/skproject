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
pzfc.generatingfunction='gen_pzfc';
pzfc.displayname='Pole-Zero Filter Cascade';
pzfc.revision='$Revision: $';

pzfc.default_nextmodule='hl';

% parameters relevant for the calculation of this module
pzfc.lowest_frequency=100;  % in Hz
pzfc.highest_frequency=6000;   % in Hz

pzfc.segment_length=200;

pzfc.erb_scale=1; % 1 to use ERB scale, 0 to use Lyon's original scale

pzfc.stepfactor=1/3; % step factor between channels

pzfc.pdamp=0.12;
pzfc.zdamp=0.2;
pzfc.zfactor=1.4;
pzfc.bw_over_cf=0.11; % only used when erb_scale==0
pzfc.bw_min_hz=27; %only used when erb_scale==0

pzfc.use_fitted_params=1;

% use fit parameters from specified file
% pzfc.fitted_params='fit524'; % 6 channels per ERB
pzfc.fitted_params='fit516'; % 2 channels per ERB

pzfc.agcfactor=12;

% Parameters for tinkering with the AGC for the filterbank
pzfc.do_agc=1; % Set to 1 to run the AGC as usual. 0 to disable the AGC after the noise excitation stage.
pzfc.pre_excite_with_noise=0;  % Set to 1 to run noise through the filterbank before the stimulus
pzfc.pre_excite_time=0.2; % 200ms by default, time in seconds.
pzfc.pre_excite_level_dB=-10; % dB re. max level for the sound file

