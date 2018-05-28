function CS = cell2cellstr(varargin)

%B. Van de Sande 15-03-2005

%------------------------------default parameters---------------------------
DefParam.coloriented   = 'yes';
DefParam.emptyformat   = '';
DefParam.charstrformat = '';
DefParam.integerformat = '%.0f';
DefParam.flpointformat = '%.3f';
DefParam.unknownformat = '<invalid>';

%--------------------------------main program-------------------------------
%Checking input arguments ...
if (nargin == 1) && ischar(varargin{1}) && strcmpi(varargin{1}, 'factory')
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return
end
if (nargin == 0)
    error('Wrong number of input arguments.');
end
C = varargin{1};
if ~iscell(C) || (ndims(C) > 2)
    error('First argument must be two-dimensional cell-array.');
end
Param = CheckPropList(DefParam, varargin{2:end});
CheckParam(Param);

%Subdivide the elements of the supplied cell-array in different sets ...
[NRow, NCol] = size(C);
NElem = NRow*NCol;
idxEmpty   = find(cellfun('isempty', C));
idxCharStr = setdiff(find(cellfun('isclass', C, 'char')), idxEmpty);
idxNumeric = setdiff(find(cellfun('isclass', C, 'double')), idxEmpty);
idxMatrix  = intersect(idxNumeric, find(cellfun('prodofsize', C) > 1));
idxScalar  = setdiff(idxNumeric, idxMatrix);
if strncmpi(Param.coloriented, 'y', 1) %Column-oriented or not ...
    [idxInteger, idxFlPoint] = deal([]);
    [rowNr, colNr] = ind2sub([NRow, NCol], idxScalar);
    colNrs = unique(colNr);
    for n = colNrs(:)'
        idx = idxScalar(colNr == n);
        % Matlab 7 requires replacing NaN's by 1
        isFloat = mod(cat(2, C{idx}), 1);
        isFloat(isnan(isFloat)) = deal(1);
        
        if all(~isFloat)
            idxInteger = [idxInteger; idx];
        else
            idxFlPoint = [idxFlPoint; idx]; 
        end
    end
else
    idxInteger = idxScalar(~mod(cat(2, C{idxScalar}), 1));
    idxFlPoint = setdiff(idxScalar, idxInteger);
end    
idxUnknown = setdiff(1:NElem, [idxEmpty(:); idxCharStr(:); idxNumeric(:)]);

%Format each set separatly of the column ...
CS = cell(NRow, NCol); %Preallocation ...
if ~isempty(idxEmpty)
    [CS{idxEmpty}] = deal(Param.emptyformat); 
end

if ~isempty(Param.charstrformat)
    CS(idxCharStr) = FormatCharStr(C(idxCharStr), Param.charstrformat); 
else
    CS(idxCharStr) = C(idxCharStr); 
end

CS(idxMatrix)  = FormatMatrix(C(idxMatrix), Param.integerformat, Param.flpointformat, Param.unknownformat);
CS(idxInteger) = cellstr(num2str(cat(1, C{idxInteger}), Param.integerformat));
CS(idxFlPoint) = cellstr(num2str(cat(1, C{idxFlPoint}), Param.flpointformat));
if ~isempty(idxUnknown)
    [CS{idxUnknown}] = deal(Param.unknownformat); 
end

%---------------------------local functions------------------------
function CheckParam(Param)

if ~ischar(Param.coloriented) || ~any(strncmpi(Param.coloriented, {'y', 'n'}, 1))
    error('Property coloriented must be ''yes'' or ''no''.');
end
if ~ischar(Param.emptyformat) || ~(isempty(Param.emptyformat) || (size(Param.emptyformat, 1) == 1))
    error('Property emptyformat must have a character string as value.');
end
if ~ischar(Param.charstrformat) || ~(isempty(Param.charstrformat) || (size(Param.charstrformat, 1) == 1))
    error('Property charstrformat must have a character string as value.');
end
if ~ischar(Param.integerformat) || ~(isempty(Param.integerformat) || (size(Param.integerformat, 1) == 1))
    error('Property integerformat must have a character string as value.');
end
if ~ischar(Param.flpointformat) || ~(isempty(Param.flpointformat) || (size(Param.flpointformat, 1) == 1))
    error('Property flpointformat must have a character string as value.');
end
if ~ischar(Param.unknownformat) || ~(isempty(Param.unknownformat) || (size(Param.unknownformat, 1) == 1))
    error('Property unknownformat must have a character string as value.');
end

%------------------------------------------------------------------
function CS = FormatCharStr(CS, FormatStr)

NElem = length(CS);
for n = 1:NElem
    CS{n} = sprintf(FormatStr, CS{n});
end

%------------------------------------------------------------------
function CS = FormatMatrix(C, IntFormatStr, FlPtFormatStr, UnkwnFormatStr)

NElem = length(C); CS = cell(NElem, 1); %Preallocation ...
for n = 1:NElem,
    if (ndims(C{n}) > 2)
        CS{n} = UnkwnFormatStr;
    else
        isFloat = mod(C{n}, 1);
        isFloat(isnan(isFloat)) = deal(1);
        
        if all(~isFloat)
            CS{n} =  Mat2Str(C{n}, IntFormatStr);
        else
            CS{n} =  Mat2Str(C{n}, FlPtFormatStr);
        end
    end
end

%------------------------------------------------------------------
function Str = Mat2Str(M, FormatStr)
%Adaptation of MAT2STR.M ...

[Nrows, Ncols] = size(M);

if isempty(M),    
    if (Nrows == 0) && (Ncols == 0)
        Str = '[]';
    else
        Str = ['zeros(' int2str(Nrows) ',' int2str(Ncols) ')'];
    end
    return
end

if ((Nrows * Ncols) ~= 1)
    Str = '[';
else
    Str = '';
end
for i = 1:Nrows
    for j = 1:Ncols
        if (M(i,j) == Inf)
            Str = [Str,'Inf'];
        elseif (M(i,j) == -Inf)
            Str = [Str,'-Inf'];
        else
            Str = [Str,sprintf(FormatStr,real(M(i,j)))];
            if (imag(M(i,j)) < 0)
                Str = [Str,'-i*',sprintf(FormatStr,abs(imag(M(i,j))))];
            elseif (imag(M(i,j)) > 0)
                Str = [Str,'+i*',sprintf(FormatStr,imag(matrix(i,j)))];
            end
        end
        Str = [Str,','];
    end
    Str(end) = ';';
end
if (Nrows == 0)
    Str = [Str, ' '];
end
if ((Nrows * Ncols) ~= 1)
    Str(end)  = ']';
else
    Str(end) = [];
end

%------------------------------------------------------------------