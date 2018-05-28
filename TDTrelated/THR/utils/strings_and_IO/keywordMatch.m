function [Kw, Mess] = keywordMatch(Kw, AllKeywords, Kwname);
% keywordMatch - test if a string matches one of a set of keywords
%   [Kw, Mess] = keywordMatch(Kw, AllKeywords, Kwname) 
%   tests if Kw matches any if the keywords in cellstring AllKeywords.
%   Matching is case-insensitive; abbreviations are allowed, unless
%   ambiguous.
%
%   If Kw matches any of the keywords in the list, then on exit Kw
%   is the full matching keyword as specified in the list.
%   If Kw fails to match one and not more than one keyword in the set, 
%   then on exit Kw is empty and Mess contains an appropriate error message
%   that uses Kwname to indicate the failing keyword. The default
%   value for Kwname is the inputname of Kw. If that is empty then
%   'keyword' is used.
%
%   By convention Kw='' results in Kw='' on exit and a Message 
%   "Empty <Kwname>."
%
%   Note: if one keyword in the list is the prefix of another, then the
%   shorter one has to be matched exactly. Thus:
%      keywordMatch('ABC', {'ABC' 'ABCDEF'}) returns 'ABC'
%      keywordMatch('AB',  {'ABC' 'ABCDEF'}) is ambiguous.
%
%   See also strmatch, inputname

if nargin<3, Kwname = inputname(1); end
if isempty(Kwname), Kwname = 'keyword'; end

if ~ischar(Kw),
    error('Kw must be char string.')
end
if ~iscellstr(AllKeywords),
    error('AllKeywords input arg must be cell array of strings.')
end

Mess = '';
% test if condition is known & unique
imatch = strmatch(lower(Kw),lower(AllKeywords));
imatchexact = strmatch(lower(Kw),lower(AllKeywords), 'exact');
if isempty(Kw), % see help
    Nmatch = inf;
else,
    Nmatch = length(imatch);
end

if Nmatch==1,
    Kw = AllKeywords{imatch};
elseif Nmatch>1 && isscalar(imatchexact),
    Kw = AllKeywords{imatchexact};
elseif isinf(Nmatch),
    Mess = ['Empty ' Kwname '.'];
    Kw = '';
elseif Nmatch>1,
    Mess = ['Ambiguous ' Kwname ' ''' Kw '''.'];
    Kw = '';
elseif Nmatch==0,
    Mess = ['Invalid ' Kwname ' ''' Kw '''.'];
    Kw = '';
end



