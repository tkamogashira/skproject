function [xn, sxn] = IDFxvarnames(stimType, XN, SXN);
% IDFxvar - names of independent variable for various IDF/SPK stim menus

[xn, sxn] = deal(''); % name and shortname
switch upper(stimType),
case {'FS', 'FSLOG', 'BFS'},  [xn, sxn] = deal('Carrier frequency', 'Fcar');
case {'IMS', 'LMS', 'BMS'},[xn, sxn] = deal('Modulation frequency', 'Fmod');
case {'SPL', 'CSPL', 'NSPL'},  [xn, sxn] = deal('Intensity', 'Level');
case 'IID',[xn, sxn] = deal('Interaural intensity', 'IID');
case {'ITD' 'NTD', 'CTD'},[xn, sxn] = deal('Interaural time', 'ITD');
case 'BB',[xn, sxn] = deal('Beat frequency', 'Fbeat');
case 'CFS',[xn, sxn] = deal('Repetition rate', 'Rate');
case 'ICI',[xn, sxn] = deal('Inter-click interval', 'ICI');
end

if nargin>2, % keep using original suggestions
   if isempty(xn), xn = XN; end;
   if isempty(sxn), sxn = SXN; end;
end