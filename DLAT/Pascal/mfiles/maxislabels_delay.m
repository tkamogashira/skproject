function null = maxislabels_freq(correlogramtype)
% function null = maxislabels_freq(correlogramtype)
%
%-------------------------------------------------------------------
% Sets the delay axis for the correlogram plots
%-------------------------------------------------------------------
%
% Input parameters:
%   correlogramtype = 'binauralcorrelogram' or 'autocorrelogram'
%                     (used to set usecs or msecs as units in the 
%                      plots)
%
% Output parameters:
%   none
%
% See mccgram2dsqrt.m for examples
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


switch correlogramtype
   
case 'binauralcorrelogram';
   % dont reset axes if binaural correlogram
   % as they're already in usecs
   xlabel('Internal delay \tau (\musecs)');
   ;
   
case 'autocorrelogram';
   % reset from usecs to msecs 
   ticklabels = get(gca, 'XTickLabel');      
   tickvalues = str2num(ticklabels);
   newtickvalues = tickvalues/1000;
   newticklabels = num2str(newtickvalues);
   % plot!
   set(gca, 'XTickLabel', newticklabels);
   xlabel('Autocorrelation lag \tau (ms)');
   
end;



% the end!
%---------------------------------------------------------------------------
