function Str = cell2chararray(C, Sep, Align);
% cell2chararray - convert cellstring to char matrix with columns aligned
%   cell2chararray(C) returns a char array in which the columns C{:,k} of
%   cellstring array C are aligned.
%   
%   cell2chararray(C,N) separates the columns using N blanks. Default N=2.
%   
%   cell2chararray(C,'foo') separates the columns using string foo.
%
%   cell2chararray(C,Sep, 'right') right-aligns the columns. Default is
%   left alignment.
%
%   See also prettyprint, cellstr2char10str.

if nargin<2, Sep=[]; end
if nargin<3, Align='left'; end

RightAlign = isequal('R', upper(Align(1)));

if isempty(Sep),
    Sep = 2; 
end
if isnumeric(Sep),
    Sep = blanks(Sep);
end

if ~iscellstr(C),
   error('Argument C is not a cell array of strings. See ISCELLSTR.')
end

if RightAlign, % lr-flip all strings in C and their order
    C = fliplr(cellfun(@fliplr, C, 'UniformOutput', false));
end

[Nrow, Ncol] = size(C);
Sep = repmat(Sep,Nrow,1);
Str = '';
for icol=1:Ncol-1,
    Str = [Str, strvcat(C{:, icol}), Sep];
end
Str = [Str, strvcat(C{:, end})];

if RightAlign, % reflip
    Str = fliplr(Str);
end
