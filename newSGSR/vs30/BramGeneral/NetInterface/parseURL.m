function URL = parseURL(s)
%PARSEURL   parse unified resource locater
%   URL = PARSEURL(S) parses the character string S, containing a unified resource locater and returns the
%   scalar structure with following fields: Protocol, CompName, Dir, FileName.
%
%   See also PROBENETFILE, GETNETFILE

%B. Van de Sande 16-07-2003

if nargin ~= 1 | ~ischar(s), error('Wrong input arguments.'); end

[Protocol, R] = strtok(s, ':');
if isempty(R), 
    Protocol = ''; 
else 
    if ~strncmp(R, '://', 3), error('Wrong URL syntax.'); end
    s = R(4:end); 
end

[CompName, s] = strtok(s, '/'); 
if ~isempty(s), s(1) = []; end
s = strrep(s, '/', '\');

[Dir, FileName, FileExt] = fileparts(s); FileName = [FileName, FileExt];

[Protocol, CompName] = deal(lower(Protocol), lower(CompName));
URL = CollectInStruct(Protocol, CompName, Dir, FileName);