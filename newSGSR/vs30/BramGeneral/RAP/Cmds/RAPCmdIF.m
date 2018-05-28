function [RAPStat, LineNr, ErrTxt] = RAPCmdIF(RAPStat, LineNr, VarName, CondOp, Expr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 24-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   IF @@@1 EQ/NE/GT/LT/LE/GE @@@2 @@@@3	If the variable @@@1
%					                        satisfies the given condition then 
%					                        execute the command @@@@3
%-----------------------------------------------------------------------------------

ErrTxt = '';

%Get value of memory variable ...
MemValue = GetRAPMemVar(RAPStat, VarName);
if isempty(MemValue), ErrTxt = 'Variable not yet set'; return; end

if ischar(MemValue),
    [ExprValue, ErrTxt] = GetRAPChar(RAPStat, Expr); if ~isempty(ErrTxt), return; end
    %Comparing two character strings in RAP is always case insensitive ...
    MemValue = lower(MemValue); ExprValue = lower(ExprValue);
elseif isnumeric(MemValue), %Evaluate expression ...
    if isRAPSubstVar(Expr, 'char'), %Character substitution variable ...
        ErrTxt = 'Substitution variable cannot be assigned to numeric memory variable'; return;
    else, %Valid numeric expression ...
        [PFExpr, ErrTxt] = TransExprIF2PF(Expr); if ~isempty(ErrTxt), return; end
        ExprValue = EvalPFExpr(RAPStat, PFExpr); if isempty(ExprValue) ErrTxt = 'Could not evaluate expression'; return; end
    end
    %When comparing a numerical expression the following conventions are respected: a relational
    %expression with two scalars rises no problems, comparing two vectors of the same size is also
    %no problem, but for comparing a scalar with a vector, the scalar should be expanded to the same
    %size as the vector (MATLAB doesn't do this automatically!) ... Comparing two vectors of different
    %sizes gives an error ...
    SzMemV = size(MemValue); SzExpV = size(ExprValue);
    if ~isequal(SzMemV, SzExpV),
        if (length(MemValue) == 1), MemValue = repmat(MemValue, SzExpV);
        elseif (length(ExprValue) == 1), ExprValue = repmat(ExprValue, SzMemV);            
        else, ErrTxt = 'Vectors of different sizes cannot be compared';  return; end    
    end
end

switch CondOp
case 'eq', boolean = isequal(MemValue, ExprValue);
case 'ne', boolean = ~isequal(MemValue, ExprValue);
case 'gt', boolean = all(MemValue > ExprValue);
case 'ge', boolean = all(MemValue >= ExprValue);
case 'lt', boolean = all(MemValue < ExprValue);
case 'le', boolean = all(MemValue <= ExprValue); end

if boolean,
    Cmd = varargin{1}; Args = varargin(2:end);
    [RAPStat, LineNr, ErrTxt] = ExecuteRAPCmd(RAPStat, LineNr, Cmd, Args{:});
else, LineNr = LineNr + 1; end      
