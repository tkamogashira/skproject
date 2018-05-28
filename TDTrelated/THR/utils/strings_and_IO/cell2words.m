function W = cell2words(C,D);
% cell2words - concatenate char string to delimeter-separated string
%   Cell2words(C,D) concatenates the elements of char string C using a
%   separator D. Default D is ' ' (space character). D need not be a single
%   char.
%
%   EXAMPLES
%      cell2words({'I' 'need' 'some' 'space.'})
%    will return the char string:
%        'I need some space.'
% 
%      cell2words({'I' 'need' 'more' 'space' 'cake.'}, '      ')
%    will return the char string:
%        'I      need      more      space      cake.'
% 
%   See also words2cell.

if nargin<2, D=' '; end % default delimiter 
C = C(:).'; % single column
N = numel(C);
if N>1,
    [DD{1,1:N}] = deal(D);
    DD{end} = '';
    C = [C; DD];
    C = C(:).';
end
W = [C{:}];


