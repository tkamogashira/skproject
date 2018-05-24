function [NS, Mess] = FullFieldnames(S, FullNames,Mode);
% FullFieldnames - change fieldnames of struct into their official versions
%    S = FullFieldnames(S, FullFieldnames) renames the field of S to their
%    "official" versions as listed in cellstring FullFieldnames. The
%    matching of fieldnames is case insensitive and fieldnames of S may be
%    abbreviated versions of those in FullFieldnames: see keywordMatch.
%    Errors will result from ambigious or non-matching field names. See the
%    'select' and 'sloppy' flags below to suppress this error.
%
%    S = FullFieldnames(S, FullFieldnames,'select') removes any fields of S
%    for which no full version is found in FullFieldnames. 
%
%    S = FullFieldnames(S, FullFieldnames,'sloppy') keeps any fields of S
%    for which no full version is found in FullFieldnames. 
%
%    S = FullFieldnames(S, FullFieldnames,'strict') is the same as
%    S = FullFieldnames(S, FullFieldnames), i.e., any non-matching or
%    ambiguous fielnames result in an error.
%
%    [S, Mess] = FullFieldnames(S, FullFieldnames) suppresses the error and
%    returns the message in Mess.
%
%    See also keywordMatch, CombineStruct.

if nargin<3, Mode='strict'; end
[Mode, Mess] = keywordMatch(Mode,{'strict' 'select' 'sloppy'},'flag input argument');

FN = fieldnames(S);
NS = [];
for ii=1:length(FN),
    oldname = FN{ii};
    [newname, Mess] = keywordMatch(oldname,FullNames,'field name');
    if isempty(Mess), % unique match
        NS(1).(newname) = S.(oldname);
    else, % non-mattching or ambiguous oldname
        switch Mode
            case 'strict', % throw error or at least return with error message
                if nargout<2, error(Mess);
                else return;
                end
            case 'select', % don't use oldname field
            case 'sloppy', % retain oldname field
                NS(1).(oldname) = S.oldname;
        end
    end
end



