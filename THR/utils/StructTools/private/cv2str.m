function s = cv2str(CV, ColSep, LineSep)
%CV2STR convert struct- or cell-array(container variables) to character array
%   S = CV2STR(CV) converts the container variable CV to the character array S. S is a row vector, with
%   columns separated by TAB(ASCII 9) and lines separated by CR(ASCII 13).
%
%   S = CV2STR(CV, ColSep, LineSep) does the same, but uses the character ColSep as separator for columns,
%   and LineSep as separator for lines.
%   
%   E.g.: cv = struct('grape', {12, 34}, 'banana', {56, 67}); 
%         s = cv2str(cv);
%
%   See also CV2MX

%B. Van de Sande 20-03-2003

if ~any(nargin == [1,3]), error('Wrong number of input parameters.'); end
if ~isstruct(CV) & ~iscell(CV), error('First argument should be container variable.'); end
if nargin == 1, ColSep = char(9); LineSep = char(13); end

switch class(CV)
case 'struct'    
    NElem   = length(CV);
    FNames  = fieldnames(CV);
    NFields = length(FNames);
    
    ColSep  = repmat(ColSep, (NElem+1), 1);
    LineSep = repmat(LineSep, (NElem+1), 1);
    
    s = '';
    for n = 1:NFields
        FClass = class(getfield(CV, {1}, FNames{n}));
        switch FClass
        case 'double', 
            %col = char(FNames{n}, num2str(eval(sprintf('cat(1, CV.%s)', FNames{n}))));
            col = char(cat(2, FNames(n), eval([ '{' sprintf([ 'mat2str(CV(%d).' FNames{n} ') '], 1:NElem) '}' ]) ));
        case 'char', col = eval(sprintf('char(FNames{n}, CV.%s)', FNames{n}));
        case 'struct' %Recursion ...
            col = cv2str(descstruct(CV, FNames{n}));
            col = col(:,2:end-1);
        otherwise, error(sprintf('Class %s not implemented.', FClass)); end
        s = [ s ColSep col];
    end
    s = [ s LineSep ];
case 'cell'
    [Nrow Ncol] = size(CV);
    
    ColSep  = repmat(ColSep,Nrow, 1);
    LineSep = repmat(LineSep,Nrow, 1);
    
    s = ''; 
    for i= 1:Ncol,
        CClass = class(CV{1,i});
        switch CClass
        case 'double', 
            %col = num2str(cat(1,CV{:,i}));
            col = char(eval([ '{' sprintf(['mat2str(CV{%d,' int2str(i) '}) '], 1:Nrow) '}' ]));
        case 'char', col = char(CV{:,i});
        otherwise, error(sprintf('Class %s not implemented.', CClass)); end
        s = [s ColSep col];
    end
    s = [s LineSep];
end


