%%%%%%%%%%%%%
% usermodules
pitchstrength.generatingfunction='genpitchstrength';
pitchstrength.displayname='Pitch strength';
pitchstrength.displayfunction='displaypitchstrength';
pitchstrength.revision='$Revision: 1.4 $';


% The frequency in the temporal profile, that we are interested in
pitchstrength.target_frequency=0;	% if zero, then look for the highest pitch strength on your own!
% if we have a target frequency, then the found frequency can deviate by so much:
pitchstrength.allowed_frequency_deviation=1.12; %two halftones

% how long the temporal profiles are averaged to get the peak
pitchstrength.tip_average_time=0.05;	% in sec (50 ms)
pitchstrength.low_pass_frequency=1000;	% Hz is used in the logarithmic(!) tip for averaging


% Parameters for the different ways to define the pitch strength
% Parameters for the qualitly measurement (hight/width)
pitchstrength.height_width_ratio=0.3;   % at witch point of the height, the width is measured


% parameters for the frequency profile
pitchstrength.start_frequency_integration=0.2;  % start the ratio calculation at a region at 20% of the maximum
pitchstrength.stop_frequency_integration=0.8;  % stop the ratio calculation at 80% below the maximum

