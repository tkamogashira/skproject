function dirNr = translateDirection(dirName)

if ~isequal(1, nargin)
    error('translateDirection expects a string as it''s only argument');
end
if ~ischar(dirName)
    error('translateDirection expects a string as it''s only argument');
end

dirName = lower(dirName);

if isequal( dirName(1), 'n')
    dirNr = 1;
elseif isequal( dirName(1), 'e')
    dirNr = 2;
elseif isequal( dirName(1), 's')
    dirNr = 3;
elseif isequal( dirName(1), 'w')
    dirNr = 4;
elseif isequal( dirName(1), 'c')
    dirNr = 0;
end