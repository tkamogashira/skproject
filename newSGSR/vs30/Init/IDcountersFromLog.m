function [iCell, iseqPerCell] = IDcountersFromLog(FN);
% IDcountersFromLog - gets PXJ-style counters from log file

iCell = 1; iseqPerCell = 0; % defaults when starting a new datafile
FN = [FN '.log'];
if ~isequal(2,exist(FN)), return; end

IDline = '';
fid = fopen(FN,'rt');
while 1,
   lin = fgetl(fid);
   if ~ischar(lin), break; end;
   if ~isempty(findstr(lin,'<')) & ~isempty(findstr(lin,'>')),
      lin = strtok(lin,'>');
      lastST = max(findstr('<',lin));
      if ~isempty(lastST), IDline = trimspace(lin(lastST+1:end)); end;
   end
end
fclose(fid);

% IDline
if isempty(IDline), return; end;
[S1, S2] = strtok(IDline,'-');
S2 = strtok(S2,'-');
N1 = str2num(S1);
N2 = str2num(S2);
if ~isempty(N1), iCell = N1; end;
if ~isempty(N2), iseqPerCell = N2; end;
