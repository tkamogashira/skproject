function [vL, vR] = SPKextractVarvalues(SD)

% function [vL, vR] = SPKextractVarvalues(SD); XXX messy

[stimtype sname] = StimTypeOf(SD);

% They don't want this! It messes with PDP-11 analysis programs.
% Report varvalues as "planned" by stim menus,  not exact values.
% This function is left intact because something like it 
% might be needed for non-PDP11 storage.
% The switch statement below is cheated by changing sname
% to an impossible value

if ~isequal(sname,'wav')
    sname = 'Natalie';
end

switch sname
case {'fs','fslog','bfs'} % true frequency values are not known at stimdef time
   % assuming identical freqs in both channels
   [vL vR] = extractStimGenParams(SD, 'trueFreq');
   for ii = 1:length(vL),
      if isstruct(vL{ii}), vL{ii} = vL{ii}.car; end;
      if isstruct(vR{ii}), vR{ii} = vR{ii}.car; end;
   end
% -------------non-PDP11 stuff------------------   
case 'wav',
   VV = SD.PRP.plotInfo.varValues;
   N = size(VV,1);
   vL = cell(N,1); vR = [];
   for ii=1:N
      vL{ii} = VV(ii,:);
   end
   return
otherwise % params were known at stimdef time; stored in SD.GlobalInfo
   vL = SD.GlobalInfo.var1Values(:,1);
   vR = SD.GlobalInfo.var1Values(:,2);
end

% what if channels are not active? 
% set to nonsense value according to Farminton wisdom, 
% e.g., idf1 seq 12
% the nonsense value equals -(1e30+1.5047e22+4.6626e17)
if ~iscell(vL)
    return
end
NONSENSE =  -(1e30+1.5047e22+4.6626e17);
for ii=1:length(vL)
   if isempty(vL{ii})
       vL{ii} = NONSENSE;
   end
   if isempty(vR{ii})
       vR{ii} = NONSENSE;
   end
end
