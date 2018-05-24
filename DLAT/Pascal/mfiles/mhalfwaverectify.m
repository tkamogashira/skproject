function multichanneldata2 = mhalfwaverectify(multichanneldata)
% function multichanneldata2 = ...
% mhalfwaverectify(multichanneldata)
%
%--------------------------------------------------------
% Halfwave rectifies a multichannel filterbank output
%--------------------------------------------------------
%
% Input:
%   multichanneldata  = first output of mgammatonefilterbank
%
% Output:
%   multichanneldata2  = transduced input, same format as first output of mgammatonefilterbank
%
%
% See mmonauraltransduction.m for examples.
%
%% version 1.0 (Jan 20th 2001)
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


% first do non-zero values
multichanneldata2 = multichanneldata;

% next replace negative values with zero
temp1 = find(multichanneldata < 0);
multichanneldata2(temp1) = zeros(size(temp1));


% the end
%--------------------------------------------------------
