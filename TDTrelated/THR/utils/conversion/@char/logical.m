function L=logical(c);
% char/logical - convert char string to logical
%   logical(S) converts char string S to a logical according to the
%   following rules (quotes omitted).
%
%   True-producing char strings (case INsensitive):
%       True, Yes, Y, 1, Correct, Okay
%
%   False-producing char strings (case INsensitive):
%       False, No, N, 0, Incorrect, Bullshit
%
%   All other inputs produce an error.

switch lower(c),
    case {'true', 'yes', 'y', '1', 'correct', 'okay'},
        L = true;
    case {'false', 'no', 'n', '0', 'incorrect', 'bullshit'},
        L = false;
    otherwise,
        error(['Cannot convert char string ''' c ''' tp a logical value.']);
end





