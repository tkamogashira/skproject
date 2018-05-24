function [output_peak] = mccgrampeak(correlogram, peaktype, infoflag)
% function [output_peak] = 
% mccgrampeak(correlogram, peaktype, infoflag)
%
%-------------------------------------------------------------------
% Calculates the position of the peak in the across-frequency 
% average of a correlogram. Peak can be either 'largest' or 'best'.
%-------------------------------------------------------------------
%
% Input parameters:
%    correlogram  = 'correlogram' structure as defined in mccgramcreate.m
%    peaktype     = type of peak to find: can be one of
%                    'best' 
%                    'largest'
%    infoflag     = 2 draw pictue of polynomial fit and report data
%                   1 report position to screen
%                 = 0 don report anything
%
% Output
%    output_peak = the position of the peak, in microseconds
%                    
% The 'largest' peak is the peak with the most activity across the
% whole delay line.  The 'best' peak is the peak closest
% to 0 usecs.
%
% A polynomial function is fit to the data in order to interpoalte
% the position of the peak to a resolution better than
% that provided by the sampling rate. This is a 6th-order 
% function fit  over +/- 250 us about the center of the peak.
% (250 was chosen as anything much bigger sometimes means 
%  'polyfit' reports "Matrix is close to singular or badly scaled")
% The fit can be plotted using a value of 2 for the infoflag.
%
%
% Examples:
% to measure the position of the largest peak of a previously
% made correlogram cc1, type:
% >> peak = mccgrampeak(cc1, 'largest', 1);
%
% to measure the position of the 'best' (ie, closest-to-0) peak of 
% a previously made correlogram cc1, type:
% >> peak = mccgrampeak(cc1, 'best', 1);
%
% to measure the position of the 'best' (ie, closest-to-0) peak of 
% a previously made correlogram cc1, and to also plot the 
% polynomial fit,type:
% >> peak = mccgrampeak(cc1, 'best', 2);
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
   
   
% average across-frequency 
if infoflag >= 1
   fprintf('averaging across frequency ... \n');
end;
integratedccfunction = sum(correlogram.data);   


%-----------------------------------------

switch peaktype
   
case 'best'
   % find most-central ('best') peak
   if (infoflag >= 1)
      fprintf('finding best (most-central) peak ...\n');
   end;
   % find the central position of the peak closest to the midline (t=0)
   % first, find midline:
   for delay=1:correlogram.ndelays,
      if (correlogram.delayaxis(delay) == 0)
            midlineindex1 = delay;
      end;
   end;
   % next, starting at left edge, find closestpeak
   midlinedistance = 999;
   for delay=2:correlogram.ndelays-1,
      if ((integratedccfunction(delay) > integratedccfunction(delay-1)) & (integratedccfunction(delay) > integratedccfunction(delay+1)))
         % peak!
         thismidlinedistance = abs(delay-midlineindex1);
         % if this midline distance is *worse* than the previous one,
         % then that was clearly the most central peak
         if (thismidlinedistance > midlinedistance)
            % success!
            % return previous bestpeakindex;
            break;
         else 
            midlinedistance = thismidlinedistance;
            chosenpeakindex = delay;
         end;
      end;
   end;
   chosenpeak_usecs = correlogram.delayaxis(chosenpeakindex);
   if (infoflag >= 1)
      fprintf('location: %d samples = %d usecs\n', chosenpeakindex, chosenpeak_usecs);
   end;      
   
   
case 'largest'
   % find largest peak in average
   if (infoflag >= 1)
      fprintf('finding largest peak ...\n');
   end;
   % first, find midline:
   for delay=1:correlogram.ndelays,
      if (correlogram.delayaxis(delay) == 0)
            midlineindex1 = delay;
      end;
   end;
   % next, starting at left edge, find largestpeak
   largestpeakheight = 0;
   for delay=2:correlogram.ndelays-1,
      if ((integratedccfunction(delay) > integratedccfunction(delay-1)) & (integratedccfunction(delay) > integratedccfunction(delay+1)))
         % peak!
         if (integratedccfunction(delay) > largestpeakheight)
            % success!
            largestpeakheight = integratedccfunction(delay);
            chosenpeakindex = delay;
         end;
      end;
   end;
   chosenpeak_usecs = correlogram.delayaxis(chosenpeakindex);
   if (infoflag >= 1)
      fprintf('location: %d samples = %d usecs\n', chosenpeakindex, chosenpeak_usecs);
   end;      
   
   
otherwise
   % unknown peaktype 
   fprintf('%s! error! unknown peaktype ''%s'' \n\n', mfilename, peaktype);
   output_peak = [];
   return;
  
end;
   
   
   
% reset average to +/- 250 us centered on the peak
halfwidth_us = 250;
halfwidth_samples = halfwidth_us/(1000000/correlogram.samplefreq);
halfwidth_samples = round(halfwidth_samples);
cutdownaverage = [];
cutdowndelays = [];
counter=0;
startcount = chosenpeakindex-halfwidth_samples;
stopcount = chosenpeakindex+halfwidth_samples;
if startcount < 1
   startcount = 1;
end;
if stopcount > correlogram.ndelays
   stopcount = correlogram.ndelays;
end;
  
for delay=startcount:stopcount
   counter=counter+1;
   cutdownaverage(counter) = integratedccfunction(delay);
   cutdowndelays(counter) = correlogram.delayaxis(delay);
end;


% use 'polyfit' to fit a smooth curve to the data
polypoints = 6;
if (infoflag >= 1)
  fprintf('interpolating using %-d order ''polyfit'' ... \n', polypoints);
  end;      
[polycoefs polyfactor] = polyfit(cutdowndelays, cutdownaverage, polypoints);

% measure to 1 usec resolution to use for later maximum
counter=1;
predcurve = [];
predxaxis = [];
for xpoint = correlogram.delayaxis(startcount):1:correlogram.delayaxis(stopcount)
   predcurve(counter) = polyval(polycoefs, xpoint);
   predxaxis(counter) = xpoint;
   counter=counter+1;
end;
      
% plot if required 
if infoflag >= 2
   close;
   figure(1);
   plot(cutdowndelays, cutdownaverage, 'r*', predxaxis, predcurve, '-');
   xlabel('Internal delay \tau (\musecs)');
   ylabel('Across-frequency average');
end;

% measure the x axis (=timedelay) corresponding to the maximum of the smooth curve
maximum = 0;
counter=1;
bestitd = -999999;
for xpoint = correlogram.delayaxis(startcount):1:correlogram.delayaxis(stopcount)
  if (predcurve(counter) >= maximum)
     maximum = predcurve(counter);
     bestitd = xpoint;
  end;
counter=counter+1;
end; 
   
% report answers   
if infoflag >= 1
   fprintf('interpolated position = %.0f usecs\n', bestitd);
   fprintf('\n');
end;
   
% return values
output_peak = bestitd;

   
% the end!
%----------------------------------------------------------