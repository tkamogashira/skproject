function [output_correlogram, output_freqweight] = mccgramfreqweight(correlogram, fswitch, infoflag);
% function [output_correlogram, output_freqweight] = 
% mccgramfreqweight(correlogram, fswitch, infoflag);
%
%-------------------------------------------------------------------
% Applies a frequency-weighting function to a correlogram
%-------------------------------------------------------------------
%
% Input parameters:
%    correlogram = 'correlogram' structure as defined in mccgramcreate.m
%    fswitch    = freq weighting function to use: can be
%                  'stern' (    = Stern et al. (1988)
%                  'raatgever'  = Raatgever (1980)
%                  'mld'        = Masking-level difference function (Akeroyd and Summerfield, 1999)
%    infoflag   = 1: report some information while running only
%               = 0  dont report anything
%
% Output parameters:
%    output_correlogram = the input correlogram weighted by p(tau)
%    output_delayweight = the delay-weighting function in a correlogram structure
%
%
% Example:
% to apply Stern et al's weighting to a previously-made correlogram cc1, 
% and store the weighted correlogram in cc2 and the weighting-
% function itself in ccw, type:
% >> [cc2 ccw] = mccgramfreqweight(cc1, 'stern', 1);
%
%
% Citations:
% Akeroyd MA and Summerfield AQ (1999)  "A fully temporal account 
%  of the perception of dichotic pitches," Br. J.Audiol., 33(2), 
%  106-107 . 
% Raatgever, J. (1980).  On the binaural processing of stimuli 
%  with different interaural phase relations, (Doctoral 
%  dissertation, Delft University of Technology, The Netherlands). 
% Stern RM, Zeiberg AS and Trahiotis C (1988).  "Lateralization 
% of complex binaural stimuli: A weighted image model", J. Acoust. 
% Soc. Am., 84, 156-165 (erratum: J. Acoust. Soc. Am., 90, 2202).
%
%
% Thanks to Klaus Hartung for speeding the code up
%
% MAA Winter 2001 2i01
%--------------------------------------------------------

% ****************************************************************
% This MATLAB software was developed by Michael A Akeroyd for 
% supporting research at the University of Connecticut
% and the University of Sussex.  It is made available
% in the hope that it may prove useful. Any support is extremely
% limited; in particular, there is no guarantee that any help 
% can be offered in its use nor that any bugs will be fixed.
% 
% Any for-profit use or redistribution is prohibited. No warranty
% is expressed or implied. If you modify this software,
% please include a statement indicating what has been changed.
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


% define and clear central-weighting function
% (create by copying then changing input)
freqweight = correlogram;
freqweight.title = 'frequency-weighting function';
freqweight.data = zeros(freqweight.nfilters, freqweight.ndelays); 


switch fswitch
   
case 'raatgever'
   % This is Raatgever's fit to his data representing the dominance 
   % of certain frequencies in binaural localization
   %
   % See Raatgever J (1980) especially p. 64 eq. IV.1
   %
   if (infoflag >= 1)
      fprintf('creating Raatgever''s freq-weighting ...\n');
   end;
   for filter=1:correlogram.nfilters
      freq = correlogram.freqaxishz(filter);   
      if (freq < 600)
         freqweight.data(filter, :) = exp(-1.0 * power(((freq/300.0)-2.0), 2.0));
      else 
         freqweight.data(filter, :) = exp(-1.0 * power(((freq/600.0)-1.0), 2.0));
      end;
   end;
   
   
case 'stern'
   % This is Stern et al's fit to Raatgever's data representing 
   % the dominance of certain frequencies in binaural localization
   %
   % see Stern RM, Zeiberg AS, Trahiotis C (1988) 
   % (especially the q(f) function on p. 160)
   %
   if (infoflag >= 1)
      fprintf('creating Stern et al''s freq weighting function ...\n');
   end;
   for filter=1:correlogram.nfilters
      freq = correlogram.freqaxishz(filter);   
      if freq > 1200
         freq = 1200;
      end;
      b1 = -9.38272e-2;
      b2 = 1.12586e-4;
      b3 = -3.99154e-8;
      pwr = -1*(b1*freq + b2*freq^2 + b3*freq^3);
      answer = power(10.0, pwr/10);
      freqweight.data(filter, :) = answer;
   end;
  
  
case 'mld'
   % this is a fit to the N0S0-N0Spi masking level difference 
   % as a function of frequency 
   %
   % The fit is described in p 12-13 of a poster presented at the
   % BSA Short Papers Meeting on Experimental Studies of 
   % Hearing and Deafness, London, Autumn 1998,
   % A PDF version of the poster can be downloaded from my website/
   %
   % The fit is a 'roex' function which gives a maximum MLD of
   % about 12 dB at 300 Hz
   %
   if (infoflag >= 1)
      fprintf('creating freq-weighting function as fit to N0S0-N0Spi MLD ...\n');
   end;
   roex_p = 0.0046;
   roex_r = 0.125893; % -9 dB 
   roex_reffreq = 300.0; % Hz
   for filter=1:correlogram.nfilters
      freq = correlogram.freqaxishz(filter);   
      freqweight.data(filter, :) = (1.0-roex_r) * (1.0 + (freq - roex_reffreq)*roex_p) ...
         * exp( -1.0 *(freq - roex_reffreq)*roex_p) + roex_r;
   end;
   
   
otherwise
   fprintf('%s: error! unknown frequency-weight ''%s''\n\n', mfilename, fswitch);
   return;
   return;
   
end;


% apply weight (but copy first to get index values ok)
if (infoflag >= 1)
   fprintf('applying function ... \n');
end;
correlogram2 = correlogram;
correlogram2.data = freqweight.data .* correlogram.data;

% reset names
correlogram2.freqweight = fswitch;
freqweight.freqweight = fswitch;
freqweight.modelname = mfilename;

% return values
output_correlogram = correlogram2;
output_freqweight = freqweight;

if infoflag >= 1
   fprintf('\n');
end;
  
  
  
% the end
%----------------------------------
