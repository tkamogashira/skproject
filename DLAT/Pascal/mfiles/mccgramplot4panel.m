function null = mccgramplot4panel(correlogram, optional_markersize, optional_linewidth)
% function null = mccgramplot4panel(correlogram, optional_markersize, optional_linewidth)
%
%------------------------------------------------------------------
% Plots a binaural correlogram in the 4-panel format 
% used by mcorrelogram.m
%------------------------------------------------------------------
%
% Input parameters
%    correlogram         = 'correlogram' structure as defined in mccgramcreate.m
%    optional_markersize = size of the crosses and asterisks
%    optional_linewidth  = linewidth of the crosses and asterisks
%
% Output parameters:
%    none
%
% The parameters 'optional_markersize' and 'optional_linewidth'
% are used in mccgramplot2dsqrt to plot symbols marking
% the tracks of the maxima. They are optional and do not 
% need to be specified.  The default values are:
%    markersize : 5
%    linewidth  : 1
% If either are set to 0 then the + and * are not plotted
%
%
% Examples:
% to plot a previously-made correlogram cc1, type:
% >> mccgramplot4panel(cc1);
%
% to plot a previously-made correlogram cc1 using super-big 
% and super-wide symbols,
% type:
% >> mccgramplot4panel(cc1, 10, 2);
%
% to plot a previously-made correlogram cc1 but without nay
% symbols, type:
% >> mccgramplot4panel(cc1, 0, 0);
%
%
% See mcorrelogram.m for another example.
%
%
% version 1.0 (Jan 20th 2001)
% MAA Winter 2001 
%----------------------------------------------------------------

% ******************************************************************
% This MATLAB software was developed by Michael A Akeroyd for 
% supporting research at the University of Connecticut
% and the University of Sussex.  It is made available
% in the hope that it may prove useful. 
% 
% Any for-profit use or redistribution is prohibited. No warranty
% is expressed or implied. All rights reserved.
% 
%    Contact address:
%      Dr Michael A Akeroyd,
%      Laboratory of Experimental Psychology, 
%      University of Sussex, 
%      Falmer, 
%      Brighton, BN1 9QG, 
%      United Kingdom.
%    email:   maa@biols.susx.ac.uk 
%    webpage: http://www.biols.susx.ac.uk/Home/Michael_Akeroyd/
%  
% ******************************************************************
   
   
% get variable names
programname = mfilename;
waveformname = inputname(1);


% this code is copied from mcorrelogram
screenwidth = 1024; 
screenheight = 768; 
aspectratio = screenwidth/screenheight; % used so a width=height figure actually looks square
figurewidth = 600; % pixels


% define the size  of the upcoming four-panel plots
% matlab's 'position' is a 4-member array: [x y width height]:   
%   (x, y) is of bottom lefthand corner of picture, relative to bottom left-hand corner of screen, in pixels I think
%   (width, height) is of figure, in pixels I think
position_figure1_xy = [100 85];
position_figure2_xy = [120 65];
position_figure3_xy = [140 45];
position_figure1_wh = [figurewidth*aspectratio, figurewidth];
position_figure2_wh = [figurewidth*aspectratio, figurewidth];
position_figure3_wh = [figurewidth*aspectratio, figurewidth];


% plot the correlogram in a variety of forms in figure 
set(gcf, 'Name', [programname, ' : input = ', waveformname, ' ... correlograms']);
set(gcf, 'Position', [position_figure3_xy position_figure3_wh]);


if (correlogram.nfilters > 1)
   fprintf('plotting 3-dimensional correlogram in figure %d.1 using mccgramplot3dmesh \n', gcf);
   subplot(2,2,1);
   mccgramplot3dmesh(correlogram);
   zlabel('Crossproduct');
   title(['3d correlogram']);

   fprintf('plotting 3-dimensional correlogram in figure %d.2 using mccgramplot3dsurf \n', gcf);
   subplot(2,2,2);
   mccgramplot3dsurf(correlogram);
   zlabel('Crossproduct');
   title(['3d correlogram']);

   subplot(2,2,3);
   fprintf('plotting 2-dimensional correlogram in figure %d.3 using mccgramplot2dsqrt \n', gcf);
   if nargin == 1 
      mccgramplot2dsqrt(correlogram);
   else
      mccgramplot2dsqrt(correlogram, optional_markersize, optional_linewidth);
   end;
   zlabel('Crossproduct');
   title(['2d correlogram with local and overall maxima']);

   subplot(2,2,4);
   fprintf('plotting across-freq average in figure %d.4 using mccgramplotaverage \n', gcf);
   mccgramplotaverage(correlogram);
   title(['Across-frequency average']);
end;


if (correlogram.nfilters == 1)
   % plot across-frequency average only as for a single-channel model that is
   % the same as the function in that channel
   subplot(2,2,4);
   fprintf('plotting across-freq average in figure %d.4 using mccgramplotaverage \n', gcf);
   mccgramplotaverage(correlogram);
   title(['Across-frequency average']);
end;


fprintf('\n');



% the end!
%----------------------------------------------------------