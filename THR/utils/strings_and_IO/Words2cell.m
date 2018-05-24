function [c, Nw] = w2c(str,D);
% Words2cell - distribute words of char string to cell array
%   Words2cell(S) deals words in string S separated by white space
%
%   Words2cell(S,D) deals words separated by character D
%
%   [C, N] Words2cell(S ..) also returns the wordcount N=length(C).
%
%   Words2cell(s) deals words separated by white space
%   Note: multiple adjacent delimiters count as one
%
%   EXAMPLES
%      words2cell('The number  of   spaces    don''t     count')
%    will return the cell array:
%      {'The'   'number'   'of'    'spaces'    'don't' 'count'}
% 
%      words2cell('comma,separated,bull', ',')
%    will return the cell array:
%      {'comma'   'separated'   'bull'}
% 
%   See also cell2words, ISSPACE, STRTOK.


% find positions of delimiters
if nargin<2,
   isep = find(isspace(str));
else, 
    if length(D)>1,
        error('Delimiter must be single char.')
    end
    isep = strfind(str,D);
end


isep = [0 isep length(str)+1]; % virtual separators enclosing the string
multsep = [diff(isep)==1];  % repeated delimeter is single delimeter by convention
isepend = isep(find(~multsep));
isepstart = isep(find([0 ~multsep]));
iwordstart = 1+isepend;
iwordend = isepstart-1;
Nw = length(iwordstart);
c = cell(1,Nw);
for ii=1:Nw,
   c{ii} = str(iwordstart(ii):iwordend(ii));
end