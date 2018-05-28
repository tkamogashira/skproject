function [CellNr, TestNr, ID, StimType] = unraveldsID(dsID)

if (nargin ~= 1) | ~ischar(dsID)
    error('Wrong input argument.'); 
end

idx = findstr(dsID, '-');

if isempty(idx)
    error('Wrong dsID.'); 
end

if length(idx) == 1
    idx = [idx length(dsID)+1]; 
end

CellNr = str2num(cipherfilt(dsID(1:idx(1)-1)));
TestNr = str2num(cipherfilt(dsID(idx(1)+1:idx(2)-1)));
ID       = dsID(1:idx(2)-1);
StimType = dsID(idx(2)+1:end);

%--------------------locals---------------
function s = cipherfilt(s)

c = '0123456789';

idx = find(~ismember(s, c));
s(idx) = [];    
