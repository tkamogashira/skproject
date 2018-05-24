function erb = merb(f_hz, q, bwmin, infoflag)
% function erb = 
% merb(f_hz, q, bwmin, infoflag)
%
% -------------------------------------------------------------------
% Returns the equivalent rectangular bandwidth (ERB) at a 
% frequency f (in Hz), using Glasberg and Moore's equation
%--------------------------------------------------------------------
% 
% Input parameters:
%   f_hz     = frequency (Hz)
%   q        = q factor 
%   bwmin    = bwmin factor
%   infoflag = 1  report answer to terminal window as well 
%              0 dont report anything
%
% Output parameters:
%   erb      = equivalent rectangular bandwidth (Hz)
%
% If values of -1 are used for 'q' or 'bwin' then the
% standard values (9.3, 24.7, respectively) are used instead
%
% Example:
% to get the ERB at 500 Hz, type:
% >> erb = merb(500, -1, -1, 1);
% or
% >> [q bw] = mstandarderbparameters;
% >> erb = merb(500, q, bw, 1);
% 
% Citation:
% Glasberg BR and Moore BCJ (1990). "Derivation of auditory filter 
% shapes from notched-noise data," Hearing Research, 47,103-138.
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
   
 

% Glasberg/Moore eqn (see Hearing Research (1990), vol 47, p 103-138)
% erb = 24.673*(4.368*f_hz/1000+1);


if q == -1
   [q  blank] = mstandarderbparameters;
end;
if bwmin == -1
   [blank bwmin] = mstandarderbparameters;
end;

erb = bwmin * (f_hz/(q*bwmin) +1);
 

if infoflag == 1
   fprintf('frequency = %.1f Hz : equivalent rectangular bandwidth = %.2f Hz\n', f_hz, erb);
   fprintf('\n');
end;


%--------------------------------