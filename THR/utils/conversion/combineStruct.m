function [cs, ofn] = combineStruct(s1,s2, aflag);
% combineStruct - combine two struct into one
%    CombineStruct(S1,S2) is a struct that contains the
%    the fields of both S1 and S1.
%    In case of identical fieldnames, S2 values take precedence.
%
%    By definition, CombineStruct(S,[]) == CombineStruct([],S) == S.
%
%    [CS, OFN]=CombineStruct(S1,S2, 'amend') only accepts those fields from S2
%    that are already present in S1. Cell string OFN returns the "offending
%    fieldnames" of S2, i.e., those that didn't match S1.
%    Note that fieldnames, like all MatLab identifiers, are case sensitive.
%
%    [CS, OFN]=CombineStruct(S1,S2, 'unique') only accepts those fields from S2
%    that are NOT present in S1. Cell string OFN returns the "offending
%    fieldnames" of S2, i.e., those that did match S1.
%
%    [CS, IGN]=CombineStruct(S1,S2, 'ignorecase') is a case-insensitive
%    version. Fields of S2 take precedence over any fields in S1 having the
%    same name in an case-insensitive sense.
%
%    See also CollectInStruct, struct/union, struct/intersect.

% XXX handle arrays

if nargin<3, aflag = '---'; end;

[aflag, Mess] = keywordMatch(aflag, {'amend', 'unique', 'ignorecase', '---'}, 'flag');
error(Mess);
ofn = {};
if isempty(s1), cs = s2;
elseif isempty(s2), cs = s1;
else,
    if ~isstruct(s1) || ~isstruct(s2),
        error('Arguments of CommbineStruct must be either structs or [].');
    end
    fns1 = fieldnames(s1); % collect S1 fieldnames for 'ignorecase' case.
    cs = s1;
    fns = fieldnames(s2);
    N = length(fns);
    fieldsTobeRemoved = {};
    for ii=1:N,
        fn = fns{ii};
        doSetField = 1; % default: do include the field in cs
        switch aflag, % if requested, check if fieldname exists in s1
            case 'amend',  doSetField = isfield(s1,fn);
            case 'unique', doSetField = ~isfield(s1,fn);
            case 'ignorecase', % remove any field that matches fn 
                mmm = keywordmatch(fn,fns1);
                if ~isempty(mmm),
                    cs = rmfield(cs,mmm);
                    ofn = [ofn mmm]; % store ignored/overruled fieldname
                end
        end % switch/case
        if doSetField,
            cs.(fn) = s2.(fn);
        else,
            ofn = [ofn fn]; % store ignored/overruled fieldname
        end
    end
end

