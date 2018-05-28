function Str = StrTruncate(Str,Nmax,E);
% StrTruncate - truncated representation of char string
%    StrTruncate(Str,Nmax) truncates a char string Str to Nmax characters.
%
%    StrTruncate(Str,Nmax, E) also appends the string E  in case any
%    characters have been cut off.
%
%    Str may also be a cell array of strings.
%
%    EXAMPLE
%      StrTruncate({'ABC' 'ABCDEFGH'}, 5, '...')
%       ans = 
%         'ABC'    'ABCDE...'

if nargin<3, E = ''; end

if iscellstr(Str), % recursive
    for ii=1:length(Str),
        Str{ii} = StrTruncate(Str{ii},Nmax,E);
    end
    return;
end

%-----non-cell Str from here--------------------

if length(Str)>Nmax,
    Str = [Str(1:Nmax) E];
end




