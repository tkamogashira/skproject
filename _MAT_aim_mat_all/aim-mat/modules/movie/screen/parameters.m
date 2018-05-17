% parameter file for 'aim-mat'
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


%%%%%%%%%%%%%
% user defined module
% hidden parameters
screen.generatingfunction='gen_screen_movie';
screen.displayname='produces a movie from the auditory image or whatever is on the screen';
screen.revision='$Revision: 585 $';

% parameters relevant for the calculation of this module
% how fast the movement of the bmm should be recorded 
screen.physical_frames_per_second=1000;

% how many frames per second shell the movie have.
screen.shown_frames_per_second=20;

% how many seconds of the BMM should be shown
screen.show_bmm_duration=0.01;

% instead of the bmm we can also generate movies of the nap:
screen.use_nap_instead=0;

screen.withfre=1;
screen.withtime=1;
screen.withsignal=1;
screen.data_scale=1;
screen.movie_width=640;
screen.movie_height=400;
screen.quality=0.9;



