function null = maxislabels_freq(tickstring, ticklabelstring)
% function null = maxislabels_freq(tickstring, ticklabelstring)
%
%--------------------------------------------------------------------
% Sets the frequency axis for the correlogram plots
%--------------------------------------------------------------------
%
% Input parameters:
%   tickstring      = 'ytick' or 'xtick'
%   ticklabelstring = 'yticklabel' or 'xticklabel'
% 
% Output parameters:
%   none
%
% See mcorrelogram.m and mccgram2dsqrt.m for examples
%
%
% version 1.0 (January 20th 2001)
% MAA Winter 2001 
%--------------------------------

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


% define ticks where to put the ticks, Hz
freqaxisticks_hz = [50,100, 200:200:1000, 1500:500:2000, 2500:500:5000];
[q, bwmin] = mstandarderbparameters;
freqaxisticks_erb = mhztoerb(freqaxisticks_hz, q, bwmin, 0);

% plot!
set(gca, tickstring, freqaxisticks_erb); 
    % put the ticks in the right (erb) spots ...
set(gca, ticklabelstring, freqaxisticks_hz);
     % ... but with the hz labels


% the end!
%---------------------------------------------------------------------------
