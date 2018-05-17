%%%%%%%%%%%%%%%%%%%%%
% usermodule sst %
%%%%%%%%%%%%%%%%%%%%%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

% hidden parameters
sst.generatingfunction = 'gen_sst';
sst.displayname = 'Size-Shape Transform';
% sst.displayfunction = 'displaysst';
sst.revision = '$Revision: 1.2 $';

% Sets the frames, the sst image is calculated for.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If do_all_frames = 1 
% all frames of the auditory image are transformed to a sst image
% If do_all_frames = 0 only the frames specified in 
% framerange = [start_frame end_frame] are transformed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sst.do_all_frames = 1;
sst.framerange = [0 0];

% Sets the Range for the Auditory image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of the sst image for the points
% audiorange = [start_point end_point]
% if do_all_image = 1: start_point = 1, end_point = last point in the ai
% flipimage = 1 flips the auditory image (for ti1992)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sst.do_all_image = 1;
sst.audiorange = [1 200];
sst.flipimage = 0;

% Sets the variables h and c
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sst.c_2pi = [0:0.05:30];
sst.TFval = [0:0.05:16]; 

% TCW AIM2006
% These should be the same as the filterbank settings
% (this could be implemented better and will be in future versions, where
% these will not be required).
sst.lowest_frequency=100;
sst.highest_frequency=6000;