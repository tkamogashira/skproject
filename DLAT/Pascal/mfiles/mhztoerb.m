function f_erb = mhztoerb(f_hz, q, bwmin, infoflag)
% function f_erb = 
% mhztoerb(f_hz, q, bwmin, infoflag)
%
% ----------------------------------------------------------------
% Transforms a frequeny from units of Hz to units of ERB number
%-----------------------------------------------------------------
% 
% Input parameters:
%   f_hz     = frequency (Hz)
%   q        = q factor 
%   bwmin    = bwmin factor
%   infoflag = 1  report answer to terminal window as well 
%              0 dont report anything
%
% Output parameters:
%   f_erb    = frequency (ERB number)
%
% If values of -1 are used for 'q' or 'bwin' then the
% standard values (9.3, 24.7, respectively) are used instead
%
% Example:
% to convert 500 Hz from Hz to ERB number, using the 
% standard values of q and bwmin, type:
% >> f_erb = mhztoerb(500, -1, -1, 1);
% or
% >> [q bw] = mstandarderbparameters;
% >> f_erb = mhztoerb(500, q, bw, 1);
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
   
   
% Glasberg/Moore eqn (see p. 138, 'fqtoerb' function in
% Glasberg BR and Moore BCJ (1990). "Derivation of auditory filter 
% shapes from notched-noise data," Hearing Research, 47,103-138.
% c1 = 24.673;
% c2 = 4.368;
% c3 = 1000*log(10)/(c1*c2); % natural log
% f_erb = c3 *(log10(c2*f_hz/1000+1.0));

if q == -1
   [q  blank] = mstandarderbparameters;
end;
if bwmin == -1
   [blank bwmin] = mstandarderbparameters;
end;

   
f_erb = q * log(1+f_hz/(q*bwmin));

if infoflag == 1
   fprintf('%.1f Hz -> %.3f ERB number\n', f_hz, f_erb);
   fprintf('\n');
end;
   
   
   
% the end
%--------------------------------