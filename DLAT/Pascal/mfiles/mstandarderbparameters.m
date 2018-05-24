function [output_q, output_bwmin] = mstandarderbparameters()
% function [output_q, output_bwmin] = 
% mstandarderbparameters()
%
% -----------------------------------------------------------------
% Returns the q-factor and bwmin values used in the Glasberg and 
% Moore (1990) ERB function
% q = 9.3; bwmin = 24.7
%------------------------------------------------------------------
% 
% Input parameters:
%   none
%
% Output parameters
%   q     = quality factor
%   bwmin = minimum bandwidth, hz
%
% Example:
% >> [q bw] = mstandarderbparameters;
%
% Citations: 
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


% the Glasberg & Moore (1990) equation for relating a frequency 
% in Hz to a frequency in ERB number is
%
% F_erb = 1000*ln(10) * log(4.368*F_hz + 1)
%         -----------       -------
%         24.673*4.368       1000
%
%       = 21.3log(4.7*F_hz + 1)
%                 -------
%                  1000
%
% The Holdsworth/Patterson parameterisation of this is
%
% F_erb = q * ln(F_hz + 1)
%               -----
%                bw.q
%
% where q is the 'quality factor' and bw is 'bwmin' or the 
% minimum bandwidth.
%
% Thus the values of q and bwemin are given by
%
% q =    1000          
%     ------------
%     24.673*4.368
%
% bwmin =    1000     
%         ---------
%         4.368 * q


output_q = 1000/(24.673*4.368);
output_bwmin = 1000/(4.368*output_q);


% For the Glasberg & Moore (1990) values, these equations give:
%   q     =  9.2789
%   bwmin = 24.673
%
% The values used in Slaney's Auditory Toolbox were:
%   q     =  9.26449
%   bwmin = 24.7
%
% The values in the UNIX version of AIM were
%   q     =  9.265
%   bwmin = 24.7              
 


% the end
%--------------------------------