function [m, c] = cv2mx(CV)
%CV2MX convert struct- or cell-array(container variables) to numeric array.
%   M = CV2MX(CV) converts the container variable CV to the numeric array M. If the container variable
%   is a cell-array and the cell-array doesn't have non-numeric columns, then M has the same dimensions as CV.
%   Otherwise non-numeric columns aren't converted if present. For structure-arrays, numeric fields are 
%   successively converted to columns in matrix M, non-numeric fields are discarded.
%
%   [M, C] = CV2MX(CV) does the same, but puts the non-numeric fields or cell-columns in the cell-array C.
%   
%   E.g.: cv = struct('grape', {12, 34}, 'banana', {56, 67}); 
%         m = cv2mx(cv);
%
%   See also CV2STR

%B. Van de Sande 20-3-2003

if (nargin ~= 1) | (~isstruct(CV) & ~iscell(CV)), error('Only argument should be container variable.'); end

m = []; c = cell(0);
switch class(CV)
case 'struct'
    NElem   = length(CV);
    FNames  = fieldnames(CV);
    NFields = length(FNames);
    
    for n = 1:NFields
        FClass = class(getfield(CV, {1}, FNames{n}));
        switch FClass
        case 'double', m = [m, eval(sprintf('cat(1, CV.%s)', FNames{n}))];
        case 'struct', 
            [sm, sc] = cv2mx(descstruct(CV, FNames{n}));
            m = [m, sm]; c = [c, sc];
        otherwise, c = [c, eval(sprintf('{CV.%s}''', FNames{n}))]; end
    end
case 'cell'
    [Nrow, Ncol] = size(CV);
    
    m = []; c = cell(0);
    for i = 1:Ncol,
        if strcmpi(class(CV{1,i}), 'double'), m = [m, cat(1,CV{:,i})]; 
        else, c = cat(2, c, CV{:,i}); end
    end
end    




