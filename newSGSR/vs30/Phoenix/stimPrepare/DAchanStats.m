function [N, Names] = DAchannelStats(CT);
% DAchannelStats - number of currently active DA channels and their characterizations.
%   [N Names] = DAchannelStats returns the number of active DA channels
%   and the set of words to characterize the options of using them.
%   The avaliability of DA channels is obtained from the StimulusContext.
%   More specifically, the settings of the current experiment determines
%   the active DA channels.
%
%   DAchannelStats(CT) uses stimulus context CT instead of the current context.
%     
%   See also StimulusContext, stimDefinitionXXX.

if nargin<1, 
   CT = stimulusContext; 
end

if isnumeric(CT), chanNum = CT;
else, chanNum = CT.experiment.ActiveDA.as_chanNum; % 0|1|2|3 = both|left|right|none
end

Names = DAchanNaming; 
chn = [Names.chanNum{:}];
[dum isort] = sort(chn);
Names = Names.chanName(isort);

switch chanNum,
case 0, ii = [0 1 2 3];
case 1, ii = [1 3];
case 2, ii = [2 3];
case 3, ii = [3];
end

N = min(2, length(ii)-1) ;
Names = Names(ii+1);











