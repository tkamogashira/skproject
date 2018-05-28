function [RAPStat, LineNr, ErrTxt] = RAPEscape2MATLAB(RAPStat, LineNr, CmdStr)
%RAPEscape2MATLAB  Execute escape sequence to MATLAB
%   [RAPStat, LineNr, ErrTxt] = RAPEscape2MATLAB(RAPStat, LineNr, CmdStr)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 03-03-2004

ErrTxt = '';

%Removing exclamation mark from escape sequence ...
CmdStr = CmdStr(2:end);

%Saving all memory variables currently used in RAP in a structure
Vidx = find(~cellfun('isempty', RAPStat.Memory.V));
if (size(Vidx, 2) > 1)
    Vidx = Vidx';
end
if ~isempty(Vidx)
    VNames = RmBlanks(cellstr([repmat('V', length(Vidx), 1), num2str(Vidx)])');
    VValues = RAPStat.Memory.V(Vidx);
    VArgs = vectorzip(VNames, VValues);
else
    [VNames, VValues, VArgs] = deal(cell(0));
end

Cidx = find(~cellfun('isempty', RAPStat.Memory.C));
if (size(Cidx, 2) > 1)
    Cidx = Cidx';
end
if ~isempty(Cidx) 
    CNames = RmBlanks(cellstr([repmat('C', length(Cidx), 1), num2str(Cidx)])'); 
    CValues = RAPStat.Memory.C(Cidx);
    CArgs = vectorzip(CNames, CValues);
else
    [CNames, CValues, CArgs] = deal(cell(0));
end

Args = cat(2, VArgs, CArgs); VarNames = cat(2, VNames, CNames);
if ~isempty(Args)
    RAPMem = struct(Args{:});
end

%Exporting RAP Memory structure to the MATLAB base workspace ...
if evalin('base', 'exist(''RAPMem'', ''var'');')
    fprintf('WARNING: ''RAPMem'' variable already exists in the MATLAB base workspace.\n');
    fprintf('WARNING: This variable is cleared by RAP.\n');
    evalin('base', 'clear RAPMem;');
end
if exist('RAPMem', 'var')
    assignin('base', 'RAPMem', RAPMem);
end

%Replacing all references to RAP memory variables in the escape sequence, with
%references to the newly created structure ...
%PROBLEM : References to RAP memory variables within single quotes are also
%replaced by the reference to the structure RAPMem ...
%Separators defined by more than one character don't give problems, because always
%one element of these complex separators is equal to a non complex separator ...
Separators = {',', ' ', '(', ')', '[', ']', '{', '}', '+', '-', '*', '/', '^', ';'};
SepIdx = find(ismember(CmdStr, cat(2, Separators{:})));
TokBgnIdx = sort(cat(2, 1, SepIdx, SepIdx+1));
TokEndIdx = sort(cat(2, SepIdx-1, length(CmdStr), SepIdx));
NTokens = length(TokBgnIdx); Tokens = cell(1, NTokens);
%Finding tokens that refer to RAP memory variables (case-insensitive!) ...
for n = 1:NTokens, 
    Tokens{n} = CmdStr(TokBgnIdx(n):TokEndIdx(n)); 
    if isRAPMemVar(lower(Tokens{n}))
        Tokens{n} = ['RAPMem.' upper(Tokens{n})];
    end
end

%Envoking the command interpreter ...
try
    evalin('caller', CmdStr);
catch
    ErrTxt = 'Invalid MATLAB escape sequence';
    return;
end

%Retrieving RAP Memory structure from the MATLAB base workspace ...
if evalin('base', 'exist(''RAPMem'', ''var'');')
    RAPMem = evalin('base', 'RAPMem;');
end

%Setting the RAP memory variables to the values in the structure ...
if exist('RAPMem', 'var') && ~isempty(RAPMem),
    Names = fieldnames(RAPMem); Values = struct2cell(RAPMem);
    C = strvcat(Names{:});
    
    idx = find(C(:, 1) == 'V'); 
    Vidx = str2num(C(idx, 2:end)); VValues = Values(idx);
    if ~all(cellfun('isclass', VValues, 'double'))
        ErrTxt = 'RAP memory variable was assigned object of invalid class';
        return;
    else
        RAPStat.Memory.V(Vidx) = VValues;
    end
    
    idx = find(C(:, 1) == 'C'); 
    Cidx = str2num(C(idx, 2:end)); CValues = Values(idx);
    if ~all(cellfun('isclass', CValues, 'char'))
        ErrTxt = 'RAP memory variable was assigned object of invalid class';
        return;
    else
        RAPStat.Memory.C(Cidx) = CValues;
    end
end

%Clearing the RAP Memory structure in the MATLAB base workspace ...
evalin('base', 'clear RAPMem;');

LineNr = LineNr + 1;

%------------------------------------local functions-----------------------------------
function Str = RmBlanks(Str)

if ischar(Str)
    Str = cellstr(Str);
end

NElem = length(Str);
for n = 1:NElem
    Str{n}(find(isspace(Str{n}))) = [];
end