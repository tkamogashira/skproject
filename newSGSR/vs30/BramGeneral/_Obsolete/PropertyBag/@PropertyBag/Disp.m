function Str = Disp(PB, Mode)
%PROPERTYBAG/DISP   general display function for property bag.
%   DISP(PB) or Str = DISP(PB) displays information of the supplied property bag
%   on the command window. If an output argument is given the output is returned
%   as a character string instead of diplayed.
%   DISP(PB, 'total') or Str = DISP(PN, 'total') is the same as the previous syntax.
%
%   DISP(PB, 'propvalues') only displays the properties and their respective values
%   in the property bag.
%   DISP(PB, 'propconstraints') only displays the properties and the constraints on
%   their value.

%B. Van de Sande 13-05-2004

Indent = blanks(5);

if (nargin == 1), Mode = 'total'; end

%An empty property bag ...    
if isempty(PB), Str = [Indent 'empty property bag'];
else,
    if strcmpi(Mode, 'total'),
        if length(PB.Properties) == 1, 
            Str = [Indent 'property bag with one property:'];
        else,    
            Str = [Indent 'property bag with ' int2str(length(PB.Properties)) ' properties:'];
        end
        TblStr = ConstructTable(PB.Properties, {'name', 'value', 'constraints'});
        TblStr = [repmat(Indent, size(TblStr, 1), 1), TblStr];
        Str = strvcat(Str, TblStr);
        
        if length(PB.Relations) == 0, 
            Str = char(Str, '', [Indent 'no relations defined for properties']);
        elseif length(PB.Relations) == 1, 
            TblStr = ConstructTable(PB.Relations, {'name', 'function'});
            TblStr = [repmat(Indent, size(TblStr, 1), 1), TblStr];
            Str = char(Str, '', [Indent 'one relations defined for properties:'], TblStr);
        else,
            TblStr = ConstructTable(PB.Relations, {'name', 'function'});
            TblStr = [repmat(Indent, size(TblStr, 1), 1), TblStr];
            Str = char(Str, '', [Indent int2str(length(PB.Relations)) ' relations defined for properties:'], TblStr);
        end    
    elseif strcmpi(Mode, 'propvalues'),
        Str = ConstructTable(PB.Properties, {'name', 'value'});
        Str = [repmat(Indent, size(Str, 1), 1), Str];
    elseif strcmpi(Mode, 'propconstraints'), 
        Str = ConstructTable(PB.Properties, {'name', 'constraints'}); 
        Str = [repmat(Indent, size(Str, 1), 1), Str];
    else, error('Invalid mode'); end
end

if (nargout < 1), disp(Str); clear('Str'); end

%-------------------------------locals-----------------------------
function Str = ConstructTable(S, Fields)

NElem   = length(S);
NFields = length(Fields);

Str = '';
for f = 1:NFields,
    if strcmpi(Fields{f}, 'function'),
        Col = '';
        for n = 1:NElem, Col = strvcat(Col, Func2Str(S(n).function)); end
    elseif strcmpi(Fields{f}, 'value'), 
        Col = '';
        for n = 1:NElem, Col = strvcat(Col, Value2Str(S(n).value)); end
    elseif strcmpi(Fields{f}, 'constraints'),
        Col = '';
        for n = 1:NElem, Col = strvcat(Col, Constraints2Str(S(n).constraints)); end
    else, Col = eval(sprintf('char(S.%s)', Fields{f})); end
    
    Col = char(Fields{f}, '', Col);
    Col = [repmat(' ', NElem+2, 1), Col, repmat(' |', NElem+2, 1)];
    Col(2, 1:end-1) = repmat('-', 1, size(Col, 2)-1);
    
    Str = [Str, Col];
end
Str(:, end) = [];

%------------------------------------------------------------------
function Str = Value2Str(Value)

MaxNElem = 10; %Always even ...
NumDec   = 2;

if isnumeric(Value),
    if all(~mod(Value, 1)), NumDec = 0; end %Integer numbers ...
    Pattern = sprintf('%%.%df', NumDec);

    N = prod(size(Value));
    if (N == 0), Str = '[]';
    elseif (N == 1), Str = num2str(Value, Pattern);
    elseif (N <= MaxNElem),
        [NRows, NCols] = size(Value); Str = '[';
        for r = 1:NRows
            for c = 1:NCols, Str = [Str, num2str(Value(r, c), Pattern), ',']; end
            Str(end) = ';';
        end
        Str(end) = ']';
    elseif (N > MaxNElem) & any(size(Value) == 1),
        switch find(size(Value) == 1),
        case 1, Sep = ','; case 2, Sep = ';'; end
        Str = '[';
        for n = 1:MaxNElem/2, Str = [Str, num2str(Value(n), Pattern), Sep]; end    
        Str = [Str, '...', Sep];
        for n = N-MaxNElem/2+1:N, Str = [Str, num2str(Value(n), Pattern), Sep]; end    
        Str(end) = ']';
    else, Str = sprintf('%dx%d double', size(Value)); end
elseif ischar(Value) & ((size(Value, 1) == 1) | isempty(Value)),
    Str = sprintf('''%s''', Value);
else, Str = sprintf('<%s>', class(Value)); end    

%------------------------------------------------------------------
function Str = Func2Str(Func)

if ischar(Func), Str = sprintf('<%s>', Func);
elseif isa(Func, 'function_handle'), Str = sprintf('<%s>', func2str(Func)); end

%------------------------------------------------------------------