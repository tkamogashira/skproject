function null = mccgramplotaverage(correlogram)
% function null = mccgramplotaverage(correlogram)
%
%--------------------------------------------------------------------
% Plots the across-frequency average of a binaural correlogram
%--------------------------------------------------------------------
%
%
% Input:
%    correlogram = 'correlogram' structure as defined in mccgramcreate.m
%
% Output parameters:
%    none
%
% Examples:
% to plot a previously-made correlogram cc1, type:
% >> mccgramplotaverage(cc1);
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

% average
for delay=1: correlogram.ndelays,
   integratedccfunction(delay) = 0;   
   for filter=1: correlogram.nfilters,
      integratedccfunction(delay) = integratedccfunction(delay) + correlogram.data(filter, delay);   
   end;
end;


% plot !
plot(correlogram.delayaxis, integratedccfunction);
ylabel('Across-frequency average');
title('Across-frequency average');
 

% reset axes
oldaxes = axis;
xmin = correlogram.mindelay;  
xmax = correlogram.maxdelay;  
axis([xmin xmax oldaxes(3) oldaxes(4)]);
maxislabels_delay(correlogram.type);


% the end!
%---------------------------------------------------