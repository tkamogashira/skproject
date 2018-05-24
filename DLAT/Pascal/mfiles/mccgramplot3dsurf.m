function null = mccgramplot3dsurf(correlogram)
% function null = mccgramplot3dsurf(correlogram)
%
%--------------------------------------------------------------------
% Plots a 3-dimensional binaural correlogram uising 'surf'
%--------------------------------------------------------------------
%
% Input:
%    correlogram = 'correlogram' structure as defined in mccgramcreate.m
%
% Output parameters:
%    none
%
% Examples:
% to plot a previously-made correlogram cc1, type:
% >> mccgramplot3dsurf(cc1);
%
% See mccgramplot4panel.m for another example.
%
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
   
   
hold off;


% plot!
surf(correlogram.delayaxis, correlogram.freqaxiserb, correlogram.data);
shading interp;
view(-10,70);
zlabel('Crossproduct');
switch correlogram.type
case 'binauralcorrelogram' ; 
   title('Binaural correlogram');
case 'autocorrelogram' ; 
   title('Autocorrelogram');
end;
colormap(jet);


% reset freq axes to filterbank limits
oldaxes = axis;
[filter_q, filter_bwmin] = mstandarderbparameters;
xmin = correlogram.mindelay;  
xmax = correlogram.maxdelay;  
ymin = mhztoerb(correlogram.mincf,filter_q, filter_bwmin, 0);
ymax = mhztoerb(correlogram.maxcf,filter_q, filter_bwmin, 0);
axis([xmin xmax ymin ymax oldaxes(5) oldaxes(6)]);
maxislabels_freq('ytick', 'yticklabel');
ylabel('Frequency (Hz)');
maxislabels_delay(correlogram.type);

% the end!
%---------------------------------------------------------------------------