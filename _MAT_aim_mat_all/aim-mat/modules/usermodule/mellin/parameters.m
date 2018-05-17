%%%%%%%%%%%%%%%%%%%%%
% usermodule mellin %
%%%%%%%%%%%%%%%%%%%%%

% hidden parameters
mellin.generatingfunction = 'gen_mellin';
mellin.displayname = 'mellin Image';
mellin.displayfunction = 'displaymellin';
mellin.revision = '$Revision: 1.1 $';

% Sets the frames, the mellin image is calculated for.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If do_all_frames = 1 
% all frames of the auditory image are transformed to a mellin image
% If do_all_frames = 0 only the frames specified in 
% framerange = [start_frame end_frame] are transformed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mellin.do_all_frames = 1;
mellin.framerange = [0 0];

% Sets the Range for the Auditory image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of the mellin image for the points
% audiorange = [start_point end_point]
% if do_all_image = 1: start_point = 1, end_point = last point in the ai
% flipimage = 1 flips the auditory image (for ti1992)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mellin.do_all_image = 1;
mellin.audiorange = [1 200];
mellin.flipimage = 0;

% Sets the variables h and c
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mellin.c_2pi = [0:0.05:30];
mellin.TFval = [0:0.05:16]; 

% Sets if an additional SSI is displayed
mellin.ssi = 0;

mellin.log = 0;

% TCW AIM2006
% These should be the same as the filterbank settings
% (this could be implemented better and will be in future versions, where
% these will not be required).
mellin.lowest_frequency=100;
mellin.highest_frequency=6000;