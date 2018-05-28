function outText = str2line(inText, newChar)
% convert a multi-line string to a single-line string

if isempty(newChar)
    newChar = ' ';
end

if ~ischar(inText) | ~ischar(newChar)
    error('txt2line only takes character strings as an argument.');
end

outText = inText;

newLine = strfind(outText, sprintf('\n'));
while newLine
    outText = [outText(1:newLine-1) newChar outText(newLine+1:end)];    
    newLine = strfind(outText, sprintf('\n'));
end