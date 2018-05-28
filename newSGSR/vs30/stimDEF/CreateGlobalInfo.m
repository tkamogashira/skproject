function GI = CreateGlobalInfo(cmenu, calib, var1Values, var2Values,nonPDP11);

% CreateGlobalInfo - create globalInfo field of SMS structure
% cmenu: calling stimulus menu
% calib: calibration table
% var1Values: per-subseq info on varied parameter
% var2Values (optional, def is 0*var1Values): per-subseq info on varied parameter

if nargin<4, 
   var2Values = [];end;
if isempty(var2Values),
   var2Values = 0*var1Values; % not used, but must have correct size
end;
if nargin<5, nonPDP11=0; end;
cmenu = upper(cmenu);
GI = [];
GI = CollectInStruct(cmenu, calib, var1Values, var2Values);
global SGSR;
GI.SGSRversion = SGSR.version;
if nonPDP11,
   GI.nonPDP11 = 1;
   dd=round(datevec(now)); 
   GI.today=dd([3 2 1 4 5 6]);
end
