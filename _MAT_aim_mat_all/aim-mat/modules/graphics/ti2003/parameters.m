% parameter file for 'aim-mat'
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

%%%%%%%%%%%%%
% the parameters for the graphics.
% They are independent from the module parameters

ti2003.minimum_time=0.001;
ti2003.maximum_time=0.035;
ti2003.is_log=1;
ti2003.time_reversed=0;
ti2003.display_time=0;
ti2003.time_profile_scale=1;
ti2003.plotstyle='surf';
ti2003.colormap='gray';
ti2003.colorbar='off';
ti2003.viewpoint=[0 90];
ti2003.camlight=[50,30;0,90]; % several different possible
ti2003.lighting='phong';
ti2003.shiftcolormap=0.0; % a linear shift of the colormap towards higher numbers (if >0.5) or towards lower numbers