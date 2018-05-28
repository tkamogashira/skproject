function [RAPStat, LineNr, ErrTxt] = RAPCmdGV(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 06-02-2004

%------------------------------Syntax overview------------------------------------
%   GV V#/C#  @@..@@ [ERR=#]  Get value of specified 	
%				              variable and store in specified 	
%				              variable. Optionally branch to record 
%				              # in macro on error condition
%   GV V#/C# [ERR=#]          Show value of specified variable
%----------------------------------------------------------------------------------

ErrTxt = '';

%Checking input arguments ...
if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), ListRAPMem(RAPStat); end
    LineNr = LineNr + 1;
    return;
end    
VarName = varargin{1};
if (nargin == 5), 
    Expr    = varargin{2};
    ErrLine = ExtractRAPErrLineNr(varargin{3});
elseif (nargin == 4) & isRAPErr(varargin{end}), 
    Expr    = cell(0); 
    ErrLine = ExtractRAPErrLineNr(varargin{2});
elseif (nargin == 4), 
    Expr    = varargin{end}; 
    ErrLine = [];
elseif (nargin == 3), 
    Expr    = cell(0);
    ErrLine = [];
end

if isempty(Expr), 
    Value = GetRAPMemVar(RAPStat, VarName);
    if isempty(Value) & isempty(ErrLine), ErrTxt = 'Variable not yet set'; return; 
    elseif isempty(Value) & ~isempty(ErrLine), LineNr = ErrLine; return; 
    elseif isRAPStatDef(RAPStat, 'ComLineParam.Verbose'),
        if isa(Value, 'char'), fprintf('Variable %s = ''%s''.\n', VarName, Value);
        else, fprintf('Variable %s = %s.\n', VarName, mat2str(Value, 4)); end
    end
else,
    if isRAPCMemVar(VarName),
        [Value, ErrTxt] = GetRAPChar(RAPStat, Expr);
        if ~isempty(ErrTxt) & ~isempty(ErrLine), ErrTxt = ''; LineNr = ErrLine; return;
        elseif ~isempty(ErrTxt), return; end
    elseif isRAPVMemVar(VarName),
        if isRAPSubstVar(Expr, 'char'), %Character substitution variable ...
            if ~isempty(ErrLine), LineNr = ErrLine; return;
            else, ErrTxt = 'Substitution variable cannot be assigned to numeric memory variable'; return; end
        else, %Valid numeric expression ...
            [PFExpr, ErrTxt] = TransExprIF2PF(Expr);
            if ~isempty(ErrTxt) & isempty(ErrLine), return; 
            elseif ~isempty(ErrTxt), LineNr = ErrLine; return; end
            Value = EvalPFExpr(RAPStat, PFExpr);
            if isempty(Value) & isempty(ErrLine), ErrTxt = 'Could not evaluate expression'; return; 
            elseif isempty(Value), LineNr = ErrLine; return; end
        end    
    end
    
    [RAPStat, ErrTxt] = SetRAPMemVar(RAPStat, VarName, Value);
    if ~isempty(ErrTxt) & isempty(ErrLine), return; 
    elseif ~isempty(ErrTxt), ErrTxt = ''; LineNr = ErrLine; return; end
    
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'),
        if isa(Value, 'char'), fprintf('Variable %s set to ''%s''.\n', VarName, Value);
        else, fprintf('Variable %s set to %s.\n', VarName, mat2str(Value, 4)); end
    end
end

LineNr = LineNr + 1;