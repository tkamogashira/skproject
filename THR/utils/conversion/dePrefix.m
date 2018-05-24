function [S2, Mess] = dePrefix(S, Prefix);
% dePrefix - remove prefix from field names of struct
%    S = dePrefix(S, 'Foo') changes those fieldnames of S that start with
%    Foo to their "proper value" without the Foo prefix. An error occurs
%    when the prefix-less field already exists in S. The prefix is case
%    sensitive. If Prefix equal '', nothing is changed, and no errors are
%    thrown.
%
%    [S, Mess] = dePrefix(S, 'Foo') suppresses any error and returns the
%    error message in char string Mess instead.
%
%    See also AddPrefix, keywordMatch.

Mess = ''; S2 = [];
if isempty(Prefix), % nothing to remove. Do that and quit.
    S2 = S;
    return
end

FN = fieldnames(S);
imatch = strmatch(Prefix, FN);
if isempty(imatch),
    S2 = S;
    return;
end
L = length(Prefix);
for ii=1:numel(FN),
    fn = FN{ii};
    fv = S.(fn);
    if ismember(ii,imatch) && length(fn)>L, % remove prefix from fieldname
        fn = fn(L+1:end);
        if isfield(S,fn),
            S2 = [];
            Mess = ['Removing prefix ''' Prefix ''' from field yields existing fieldname ''' fn '''.'];
            break;
        end
    end
    S2.(fn) = fv;
end

if nargout<2, % throw the error
    error(Mess); 
end


